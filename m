Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab1FJULm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 16:11:42 -0400
Date: Fri, 10 Jun 2011 15:11:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 11/13] rtlwifi: rtl8192de: Merge TX and RX routines
Message-ID: <4df27a7c.IKwjJTa/z4EaMi2c%Larry.Finger@lwfinger.net> (sfid-20110610_221146_138334_3C88AC09)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

Merge routines trx.c and trx.h for RTL8192DE.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
===================================================================
--- /dev/null
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -0,0 +1,959 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+#include "../pci.h"
+#include "../base.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "trx.h"
+#include "led.h"
+
+static u8 _rtl92de_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
+{
+	__le16 fc = rtl_get_fc(skb);
+
+	if (unlikely(ieee80211_is_beacon(fc)))
+		return QSLT_BEACON;
+	if (ieee80211_is_mgmt(fc))
+		return QSLT_MGNT;
+
+	return skb->priority;
+}
+
+static int _rtl92de_rate_mapping(bool isht, u8 desc_rate)
+{
+	int rate_idx;
+
+	if (false == isht) {
+		switch (desc_rate) {
+		case DESC92D_RATE1M:
+			rate_idx = 0;
+			break;
+		case DESC92D_RATE2M:
+			rate_idx = 1;
+			break;
+		case DESC92D_RATE5_5M:
+			rate_idx = 2;
+			break;
+		case DESC92D_RATE11M:
+			rate_idx = 3;
+			break;
+		case DESC92D_RATE6M:
+			rate_idx = 4;
+			break;
+		case DESC92D_RATE9M:
+			rate_idx = 5;
+			break;
+		case DESC92D_RATE12M:
+			rate_idx = 6;
+			break;
+		case DESC92D_RATE18M:
+			rate_idx = 7;
+			break;
+		case DESC92D_RATE24M:
+			rate_idx = 8;
+			break;
+		case DESC92D_RATE36M:
+			rate_idx = 9;
+			break;
+		case DESC92D_RATE48M:
+			rate_idx = 10;
+			break;
+		case DESC92D_RATE54M:
+			rate_idx = 11;
+			break;
+		default:
+			rate_idx = 0;
+			break;
+		}
+		return rate_idx;
+	} else {
+		switch (desc_rate) {
+		case DESC92D_RATE1M:
+			rate_idx = 0;
+			break;
+		case DESC92D_RATE2M:
+			rate_idx = 1;
+			break;
+		case DESC92D_RATE5_5M:
+			rate_idx = 2;
+			break;
+		case DESC92D_RATE11M:
+			rate_idx = 3;
+			break;
+		case DESC92D_RATE6M:
+			rate_idx = 4;
+			break;
+		case DESC92D_RATE9M:
+			rate_idx = 5;
+			break;
+		case DESC92D_RATE12M:
+			rate_idx = 6;
+			break;
+		case DESC92D_RATE18M:
+			rate_idx = 7;
+			break;
+		case DESC92D_RATE24M:
+			rate_idx = 8;
+			break;
+		case DESC92D_RATE36M:
+			rate_idx = 9;
+			break;
+		case DESC92D_RATE48M:
+			rate_idx = 10;
+			break;
+		case DESC92D_RATE54M:
+			rate_idx = 11;
+			break;
+		default:
+			rate_idx = 11;
+			break;
+		}
+		return rate_idx;
+	}
+}
+
+static u8 _rtl92d_query_rxpwrpercentage(char antpower)
+{
+	if ((antpower <= -100) || (antpower >= 20))
+		return 0;
+	else if (antpower >= 0)
+		return 100;
+	else
+		return 100 + antpower;
+}
+
+static u8 _rtl92d_evm_db_to_percentage(char value)
+{
+	char ret_val = value;
+
+	if (ret_val >= 0)
+		ret_val = 0;
+	if (ret_val <= -33)
+		ret_val = -33;
+	ret_val = 0 - ret_val;
+	ret_val *= 3;
+	if (ret_val == 99)
+		ret_val = 100;
+	return ret_val;
+}
+
+static long _rtl92de_translate_todbm(struct ieee80211_hw *hw,
+				     u8 signal_strength_index)
+{
+	long signal_power;
+
+	signal_power = (long)((signal_strength_index + 1) >> 1);
+	signal_power -= 95;
+	return signal_power;
+}
+
+static long _rtl92de_signal_scale_mapping(struct ieee80211_hw *hw, long currsig)
+{
+	long retsig;
+
+	if (currsig >= 61 && currsig <= 100)
+		retsig = 90 + ((currsig - 60) / 4);
+	else if (currsig >= 41 && currsig <= 60)
+		retsig = 78 + ((currsig - 40) / 2);
+	else if (currsig >= 31 && currsig <= 40)
+		retsig = 66 + (currsig - 30);
+	else if (currsig >= 21 && currsig <= 30)
+		retsig = 54 + (currsig - 20);
+	else if (currsig >= 5 && currsig <= 20)
+		retsig = 42 + (((currsig - 5) * 2) / 3);
+	else if (currsig == 4)
+		retsig = 36;
+	else if (currsig == 3)
+		retsig = 27;
+	else if (currsig == 2)
+		retsig = 18;
+	else if (currsig == 1)
+		retsig = 9;
+	else
+		retsig = currsig;
+	return retsig;
+}
+
+static void _rtl92de_query_rxphystatus(struct ieee80211_hw *hw,
+				       struct rtl_stats *pstats,
+				       struct rx_desc_92d *pdesc,
+				       struct rx_fwinfo_92d *p_drvinfo,
+				       bool packet_match_bssid,
+				       bool packet_toself,
+				       bool packet_beacon)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
+	struct phy_sts_cck_8192d *cck_buf;
+	s8 rx_pwr_all, rx_pwr[4];
+	u8 rf_rx_num = 0, evm, pwdb_all;
+	u8 i, max_spatial_stream;
+	u32 rssi, total_rssi = 0;
+	bool is_cck_rate;
+
+	is_cck_rate = RX_HAL_IS_CCK_RATE(pdesc);
+	pstats->packet_matchbssid = packet_match_bssid;
+	pstats->packet_toself = packet_toself;
+	pstats->packet_beacon = packet_beacon;
+	pstats->is_cck = is_cck_rate;
+	pstats->rx_mimo_signalquality[0] = -1;
+	pstats->rx_mimo_signalquality[1] = -1;
+
+	if (is_cck_rate) {
+		u8 report, cck_highpwr;
+		cck_buf = (struct phy_sts_cck_8192d *)p_drvinfo;
+		if (ppsc->rfpwr_state == ERFON)
+			cck_highpwr = (u8) rtl_get_bbreg(hw,
+						 RFPGA0_XA_HSSIPARAMETER2,
+						 BIT(9));
+		else
+			cck_highpwr = false;
+		if (!cck_highpwr) {
+			u8 cck_agc_rpt = cck_buf->cck_agc_rpt;
+			report = cck_buf->cck_agc_rpt & 0xc0;
+			report = report >> 6;
+			switch (report) {
+			case 0x3:
+				rx_pwr_all = -46 - (cck_agc_rpt & 0x3e);
+				break;
+			case 0x2:
+				rx_pwr_all = -26 - (cck_agc_rpt & 0x3e);
+				break;
+			case 0x1:
+				rx_pwr_all = -12 - (cck_agc_rpt & 0x3e);
+				break;
+			case 0x0:
+				rx_pwr_all = 16 - (cck_agc_rpt & 0x3e);
+				break;
+			}
+		} else {
+			u8 cck_agc_rpt = cck_buf->cck_agc_rpt;
+			report = p_drvinfo->cfosho[0] & 0x60;
+			report = report >> 5;
+			switch (report) {
+			case 0x3:
+				rx_pwr_all = -46 - ((cck_agc_rpt & 0x1f) << 1);
+				break;
+			case 0x2:
+				rx_pwr_all = -26 - ((cck_agc_rpt & 0x1f) << 1);
+				break;
+			case 0x1:
+				rx_pwr_all = -12 - ((cck_agc_rpt & 0x1f) << 1);
+				break;
+			case 0x0:
+				rx_pwr_all = 16 - ((cck_agc_rpt & 0x1f) << 1);
+				break;
+			}
+		}
+		pwdb_all = _rtl92d_query_rxpwrpercentage(rx_pwr_all);
+		/* CCK gain is smaller than OFDM/MCS gain,  */
+		/* so we add gain diff by experiences, the val is 6 */
+		pwdb_all += 6;
+		if (pwdb_all > 100)
+			pwdb_all = 100;
+		/* modify the offset to make the same gain index with OFDM. */
+		if (pwdb_all > 34 && pwdb_all <= 42)
+			pwdb_all -= 2;
+		else if (pwdb_all > 26 && pwdb_all <= 34)
+			pwdb_all -= 6;
+		else if (pwdb_all > 14 && pwdb_all <= 26)
+			pwdb_all -= 8;
+		else if (pwdb_all > 4 && pwdb_all <= 14)
+			pwdb_all -= 4;
+		pstats->rx_pwdb_all = pwdb_all;
+		pstats->recvsignalpower = rx_pwr_all;
+		if (packet_match_bssid) {
+			u8 sq;
+			if (pstats->rx_pwdb_all > 40) {
+				sq = 100;
+			} else {
+				sq = cck_buf->sq_rpt;
+				if (sq > 64)
+					sq = 0;
+				else if (sq < 20)
+					sq = 100;
+				else
+					sq = ((64 - sq) * 100) / 44;
+			}
+			pstats->signalquality = sq;
+			pstats->rx_mimo_signalquality[0] = sq;
+			pstats->rx_mimo_signalquality[1] = -1;
+		}
+	} else {
+		rtlpriv->dm.rfpath_rxenable[0] = true;
+		rtlpriv->dm.rfpath_rxenable[1] = true;
+		for (i = RF90_PATH_A; i < RF6052_MAX_PATH; i++) {
+			if (rtlpriv->dm.rfpath_rxenable[i])
+				rf_rx_num++;
+			rx_pwr[i] = ((p_drvinfo->gain_trsw[i] & 0x3f) * 2)
+				    - 110;
+			rssi = _rtl92d_query_rxpwrpercentage(rx_pwr[i]);
+			total_rssi += rssi;
+			rtlpriv->stats.rx_snr_db[i] =
+					 (long)(p_drvinfo->rxsnr[i] / 2);
+			if (packet_match_bssid)
+				pstats->rx_mimo_signalstrength[i] = (u8) rssi;
+		}
+		rx_pwr_all = ((p_drvinfo->pwdb_all >> 1) & 0x7f) - 106;
+		pwdb_all = _rtl92d_query_rxpwrpercentage(rx_pwr_all);
+		pstats->rx_pwdb_all = pwdb_all;
+		pstats->rxpower = rx_pwr_all;
+		pstats->recvsignalpower = rx_pwr_all;
+		if (pdesc->rxht && pdesc->rxmcs >= DESC92D_RATEMCS8 &&
+		    pdesc->rxmcs <= DESC92D_RATEMCS15)
+			max_spatial_stream = 2;
+		else
+			max_spatial_stream = 1;
+		for (i = 0; i < max_spatial_stream; i++) {
+			evm = _rtl92d_evm_db_to_percentage(p_drvinfo->rxevm[i]);
+			if (packet_match_bssid) {
+				if (i == 0)
+					pstats->signalquality =
+						 (u8)(evm & 0xff);
+				pstats->rx_mimo_signalquality[i] =
+						 (u8)(evm & 0xff);
+			}
+		}
+	}
+	if (is_cck_rate)
+		pstats->signalstrength = (u8)(_rtl92de_signal_scale_mapping(hw,
+				pwdb_all));
+	else if (rf_rx_num != 0)
+		pstats->signalstrength = (u8)(_rtl92de_signal_scale_mapping(hw,
+				total_rssi /= rf_rx_num));
+}
+
+static void rtl92d_loop_over_paths(struct ieee80211_hw *hw,
+				   struct rtl_stats *pstats)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	u8 rfpath;
+
+	for (rfpath = RF90_PATH_A; rfpath < rtlphy->num_total_rfpath;
+	     rfpath++) {
+		if (rtlpriv->stats.rx_rssi_percentage[rfpath] == 0) {
+			rtlpriv->stats.rx_rssi_percentage[rfpath] =
+			    pstats->rx_mimo_signalstrength[rfpath];
+
+		}
+		if (pstats->rx_mimo_signalstrength[rfpath] >
+		    rtlpriv->stats.rx_rssi_percentage[rfpath]) {
+			rtlpriv->stats.rx_rssi_percentage[rfpath] =
+			    ((rtlpriv->stats.rx_rssi_percentage[rfpath] *
+			      (RX_SMOOTH_FACTOR - 1)) +
+			     (pstats->rx_mimo_signalstrength[rfpath])) /
+			    (RX_SMOOTH_FACTOR);
+			rtlpriv->stats.rx_rssi_percentage[rfpath] =
+			    rtlpriv->stats.rx_rssi_percentage[rfpath] + 1;
+		} else {
+			rtlpriv->stats.rx_rssi_percentage[rfpath] =
+			    ((rtlpriv->stats.rx_rssi_percentage[rfpath] *
+			      (RX_SMOOTH_FACTOR - 1)) +
+			     (pstats->rx_mimo_signalstrength[rfpath])) /
+			    (RX_SMOOTH_FACTOR);
+		}
+	}
+}
+
+static void _rtl92de_process_ui_rssi(struct ieee80211_hw *hw,
+				     struct rtl_stats *pstats)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 last_rssi, tmpval;
+
+	if (pstats->packet_toself || pstats->packet_beacon) {
+		rtlpriv->stats.rssi_calculate_cnt++;
+		if (rtlpriv->stats.ui_rssi.total_num++ >=
+		    PHY_RSSI_SLID_WIN_MAX) {
+			rtlpriv->stats.ui_rssi.total_num =
+						 PHY_RSSI_SLID_WIN_MAX;
+			last_rssi = rtlpriv->stats.ui_rssi.elements[
+				rtlpriv->stats.ui_rssi.index];
+			rtlpriv->stats.ui_rssi.total_val -= last_rssi;
+		}
+		rtlpriv->stats.ui_rssi.total_val += pstats->signalstrength;
+		rtlpriv->stats.ui_rssi.elements
+			[rtlpriv->stats.ui_rssi.index++] =
+			pstats->signalstrength;
+		if (rtlpriv->stats.ui_rssi.index >= PHY_RSSI_SLID_WIN_MAX)
+			rtlpriv->stats.ui_rssi.index = 0;
+		tmpval = rtlpriv->stats.ui_rssi.total_val /
+			rtlpriv->stats.ui_rssi.total_num;
+		rtlpriv->stats.signal_strength = _rtl92de_translate_todbm(hw,
+			(u8) tmpval);
+		pstats->rssi = rtlpriv->stats.signal_strength;
+	}
+	if (!pstats->is_cck && pstats->packet_toself)
+		rtl92d_loop_over_paths(hw, pstats);
+}
+
+static void _rtl92de_update_rxsignalstatistics(struct ieee80211_hw *hw,
+					       struct rtl_stats *pstats)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int weighting = 0;
+
+	if (rtlpriv->stats.recv_signal_power == 0)
+		rtlpriv->stats.recv_signal_power = pstats->recvsignalpower;
+	if (pstats->recvsignalpower > rtlpriv->stats.recv_signal_power)
+		weighting = 5;
+	else if (pstats->recvsignalpower < rtlpriv->stats.recv_signal_power)
+		weighting = (-5);
+	rtlpriv->stats.recv_signal_power = (rtlpriv->stats.recv_signal_power *
+		5 + pstats->recvsignalpower + weighting) / 6;
+}
+
+static void _rtl92de_process_pwdb(struct ieee80211_hw *hw,
+				  struct rtl_stats *pstats)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	long undecorated_smoothed_pwdb;
+
+	if (mac->opmode == NL80211_IFTYPE_ADHOC	||
+		mac->opmode == NL80211_IFTYPE_AP)
+		return;
+	else
+		undecorated_smoothed_pwdb =
+		    rtlpriv->dm.undecorated_smoothed_pwdb;
+
+	if (pstats->packet_toself || pstats->packet_beacon) {
+		if (undecorated_smoothed_pwdb < 0)
+			undecorated_smoothed_pwdb = pstats->rx_pwdb_all;
+		if (pstats->rx_pwdb_all > (u32) undecorated_smoothed_pwdb) {
+			undecorated_smoothed_pwdb =
+			      (((undecorated_smoothed_pwdb) *
+			      (RX_SMOOTH_FACTOR - 1)) +
+			      (pstats->rx_pwdb_all)) / (RX_SMOOTH_FACTOR);
+			undecorated_smoothed_pwdb =
+			      undecorated_smoothed_pwdb + 1;
+		} else {
+			undecorated_smoothed_pwdb =
+			      (((undecorated_smoothed_pwdb) *
+			      (RX_SMOOTH_FACTOR - 1)) +
+			      (pstats->rx_pwdb_all)) / (RX_SMOOTH_FACTOR);
+		}
+		rtlpriv->dm.undecorated_smoothed_pwdb =
+				 undecorated_smoothed_pwdb;
+		_rtl92de_update_rxsignalstatistics(hw, pstats);
+	}
+}
+
+static void rtl92d_loop_over_streams(struct ieee80211_hw *hw,
+				     struct rtl_stats *pstats)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int stream;
+
+	for (stream = 0; stream < 2; stream++) {
+		if (pstats->rx_mimo_signalquality[stream] != -1) {
+			if (rtlpriv->stats.rx_evm_percentage[stream] == 0) {
+				rtlpriv->stats.rx_evm_percentage[stream] =
+				    pstats->rx_mimo_signalquality[stream];
+			}
+			rtlpriv->stats.rx_evm_percentage[stream] =
+			    ((rtlpriv->stats.rx_evm_percentage[stream]
+			      * (RX_SMOOTH_FACTOR - 1)) +
+			     (pstats->rx_mimo_signalquality[stream] * 1)) /
+			    (RX_SMOOTH_FACTOR);
+		}
+	}
+}
+
+static void _rtl92de_process_ui_link_quality(struct ieee80211_hw *hw,
+					     struct rtl_stats *pstats)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 last_evm, tmpval;
+
+	if (pstats->signalquality == 0)
+		return;
+	if (pstats->packet_toself || pstats->packet_beacon) {
+		if (rtlpriv->stats.ui_link_quality.total_num++ >=
+		    PHY_LINKQUALITY_SLID_WIN_MAX) {
+			rtlpriv->stats.ui_link_quality.total_num =
+			    PHY_LINKQUALITY_SLID_WIN_MAX;
+			last_evm = rtlpriv->stats.ui_link_quality.elements[
+				rtlpriv->stats.ui_link_quality.index];
+			rtlpriv->stats.ui_link_quality.total_val -= last_evm;
+		}
+		rtlpriv->stats.ui_link_quality.total_val +=
+						 pstats->signalquality;
+		rtlpriv->stats.ui_link_quality.elements[
+			rtlpriv->stats.ui_link_quality.index++] =
+						 pstats->signalquality;
+		if (rtlpriv->stats.ui_link_quality.index >=
+		    PHY_LINKQUALITY_SLID_WIN_MAX)
+			rtlpriv->stats.ui_link_quality.index = 0;
+		tmpval = rtlpriv->stats.ui_link_quality.total_val /
+		    rtlpriv->stats.ui_link_quality.total_num;
+		rtlpriv->stats.signal_quality = tmpval;
+		rtlpriv->stats.last_sigstrength_inpercent = tmpval;
+		rtl92d_loop_over_streams(hw, pstats);
+	}
+}
+
+static void _rtl92de_process_phyinfo(struct ieee80211_hw *hw,
+				     u8 *buffer,
+				     struct rtl_stats *pcurrent_stats)
+{
+
+	if (!pcurrent_stats->packet_matchbssid &&
+	    !pcurrent_stats->packet_beacon)
+		return;
+
+	_rtl92de_process_ui_rssi(hw, pcurrent_stats);
+	_rtl92de_process_pwdb(hw, pcurrent_stats);
+	_rtl92de_process_ui_link_quality(hw, pcurrent_stats);
+}
+
+static void _rtl92de_translate_rx_signal_stuff(struct ieee80211_hw *hw,
+					       struct sk_buff *skb,
+					       struct rtl_stats *pstats,
+					       struct rx_desc_92d *pdesc,
+					       struct rx_fwinfo_92d *p_drvinfo)
+{
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct ieee80211_hdr *hdr;
+	u8 *tmp_buf;
+	u8 *praddr;
+	u16 type, cfc;
+	__le16 fc;
+	bool packet_matchbssid, packet_toself, packet_beacon;
+
+	tmp_buf = skb->data + pstats->rx_drvinfo_size + pstats->rx_bufshift;
+	hdr = (struct ieee80211_hdr *)tmp_buf;
+	fc = hdr->frame_control;
+	cfc = le16_to_cpu(fc);
+	type = WLAN_FC_GET_TYPE(fc);
+	praddr = hdr->addr1;
+	packet_matchbssid = ((IEEE80211_FTYPE_CTL != type) &&
+	     (!compare_ether_addr(mac->bssid, (cfc & IEEE80211_FCTL_TODS) ?
+		  hdr->addr1 : (cfc & IEEE80211_FCTL_FROMDS) ?
+		  hdr->addr2 : hdr->addr3)) && (!pstats->hwerror) &&
+		  (!pstats->crc) && (!pstats->icv));
+	packet_toself = packet_matchbssid &&
+			(!compare_ether_addr(praddr, rtlefuse->dev_addr));
+	if (ieee80211_is_beacon(fc))
+		packet_beacon = true;
+	_rtl92de_query_rxphystatus(hw, pstats, pdesc, p_drvinfo,
+				   packet_matchbssid, packet_toself,
+				   packet_beacon);
+	_rtl92de_process_phyinfo(hw, tmp_buf, pstats);
+}
+
+bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
+		struct ieee80211_rx_status *rx_status,
+		u8 *p_desc, struct sk_buff *skb)
+{
+	struct rx_fwinfo_92d *p_drvinfo;
+	struct rx_desc_92d *pdesc = (struct rx_desc_92d *)p_desc;
+	u32 phystatus = GET_RX_DESC_PHYST(pdesc);
+
+	stats->length = (u16) GET_RX_DESC_PKT_LEN(pdesc);
+	stats->rx_drvinfo_size = (u8) GET_RX_DESC_DRV_INFO_SIZE(pdesc) *
+				 RX_DRV_INFO_SIZE_UNIT;
+	stats->rx_bufshift = (u8) (GET_RX_DESC_SHIFT(pdesc) & 0x03);
+	stats->icv = (u16) GET_RX_DESC_ICV(pdesc);
+	stats->crc = (u16) GET_RX_DESC_CRC32(pdesc);
+	stats->hwerror = (stats->crc | stats->icv);
+	stats->decrypted = !GET_RX_DESC_SWDEC(pdesc);
+	stats->rate = (u8) GET_RX_DESC_RXMCS(pdesc);
+	stats->shortpreamble = (u16) GET_RX_DESC_SPLCP(pdesc);
+	stats->isampdu = (bool) (GET_RX_DESC_PAGGR(pdesc) == 1);
+	stats->isfirst_ampdu = (bool) ((GET_RX_DESC_PAGGR(pdesc) == 1)
+					 && (GET_RX_DESC_FAGGR(pdesc) == 1));
+	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
+	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
+	rx_status->freq = hw->conf.channel->center_freq;
+	rx_status->band = hw->conf.channel->band;
+	if (GET_RX_DESC_CRC32(pdesc))
+		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+	if (!GET_RX_DESC_SWDEC(pdesc))
+		rx_status->flag |= RX_FLAG_DECRYPTED;
+	if (GET_RX_DESC_BW(pdesc))
+		rx_status->flag |= RX_FLAG_40MHZ;
+	if (GET_RX_DESC_RXHT(pdesc))
+		rx_status->flag |= RX_FLAG_HT;
+	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
+	if (stats->decrypted)
+		rx_status->flag |= RX_FLAG_DECRYPTED;
+	rx_status->rate_idx = _rtl92de_rate_mapping((bool)
+						    GET_RX_DESC_RXHT(pdesc),
+						    (u8)
+						    GET_RX_DESC_RXMCS(pdesc));
+	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
+	if (phystatus == true) {
+		p_drvinfo = (struct rx_fwinfo_92d *)(skb->data +
+						     stats->rx_bufshift);
+		_rtl92de_translate_rx_signal_stuff(hw,
+						   skb, stats, pdesc,
+						   p_drvinfo);
+	}
+	/*rx_status->qual = stats->signal; */
+	rx_status->signal = stats->rssi + 10;
+	/*rx_status->noise = -stats->noise; */
+	return true;
+}
+
+static void _rtl92de_insert_emcontent(struct rtl_tcb_desc *ptcb_desc,
+				      u8 *virtualaddress)
+{
+	memset(virtualaddress, 0, 8);
+
+	SET_EARLYMODE_PKTNUM(virtualaddress, ptcb_desc->empkt_num);
+	SET_EARLYMODE_LEN0(virtualaddress, ptcb_desc->empkt_len[0]);
+	SET_EARLYMODE_LEN1(virtualaddress, ptcb_desc->empkt_len[1]);
+	SET_EARLYMODE_LEN2_1(virtualaddress, ptcb_desc->empkt_len[2] & 0xF);
+	SET_EARLYMODE_LEN2_2(virtualaddress, ptcb_desc->empkt_len[2] >> 4);
+	SET_EARLYMODE_LEN3(virtualaddress, ptcb_desc->empkt_len[3]);
+	SET_EARLYMODE_LEN4(virtualaddress, ptcb_desc->empkt_len[4]);
+}
+
+void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
+			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
+			  struct ieee80211_tx_info *info, struct sk_buff *skb,
+			  u8 hw_queue, struct rtl_tcb_desc *ptcb_desc)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct ieee80211_sta *sta = info->control.sta;
+	u8 *pdesc = (u8 *) pdesc_tx;
+	u16 seq_number;
+	__le16 fc = hdr->frame_control;
+	unsigned int buf_len = 0;
+	unsigned int skb_len = skb->len;
+	u8 fw_qsel = _rtl92de_map_hwqueue_to_fwqueue(skb, hw_queue);
+	bool firstseg = ((hdr->seq_ctrl &
+			cpu_to_le16(IEEE80211_SCTL_FRAG)) == 0);
+	bool lastseg = ((hdr->frame_control &
+			cpu_to_le16(IEEE80211_FCTL_MOREFRAGS)) == 0);
+	dma_addr_t mapping;
+	u8 bw_40 = 0;
+
+	if (mac->opmode == NL80211_IFTYPE_STATION) {
+		bw_40 = mac->bw_40;
+	} else if (mac->opmode == NL80211_IFTYPE_AP ||
+		mac->opmode == NL80211_IFTYPE_ADHOC) {
+		if (sta)
+			bw_40 = sta->ht_cap.cap &
+				IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	}
+	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
+	rtl_get_tcb_desc(hw, info, sta, skb, ptcb_desc);
+	/* reserve 8 byte for AMPDU early mode */
+	if (rtlhal->earlymode_enable) {
+		skb_push(skb, EM_HDR_LEN);
+		memset(skb->data, 0, EM_HDR_LEN);
+	}
+	buf_len = skb->len;
+	mapping = pci_map_single(rtlpci->pdev, skb->data, skb->len,
+				 PCI_DMA_TODEVICE);
+	CLEAR_PCI_TX_DESC_CONTENT(pdesc, sizeof(struct tx_desc_92d));
+	if (ieee80211_is_nullfunc(fc) || ieee80211_is_ctl(fc)) {
+		firstseg = true;
+		lastseg = true;
+	}
+	if (firstseg) {
+		if (rtlhal->earlymode_enable) {
+			SET_TX_DESC_PKT_OFFSET(pdesc, 1);
+			SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN +
+					   EM_HDR_LEN);
+			if (ptcb_desc->empkt_num) {
+				RT_TRACE(rtlpriv, COMP_SEND, DBG_LOUD,
+					 ("Insert 8 byte.pTcb->EMPktNum:%d\n",
+					  ptcb_desc->empkt_num));
+				_rtl92de_insert_emcontent(ptcb_desc,
+							  (u8 *)(skb->data));
+			}
+		} else {
+			SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
+		}
+		/* 5G have no CCK rate */
+		if (rtlhal->current_bandtype == BAND_ON_5G)
+			if (ptcb_desc->hw_rate < DESC92D_RATE6M)
+				ptcb_desc->hw_rate = DESC92D_RATE6M;
+		SET_TX_DESC_TX_RATE(pdesc, ptcb_desc->hw_rate);
+		if (ptcb_desc->use_shortgi || ptcb_desc->use_shortpreamble)
+			SET_TX_DESC_DATA_SHORTGI(pdesc, 1);
+
+		if (rtlhal->macphymode == DUALMAC_DUALPHY &&
+			ptcb_desc->hw_rate == DESC92D_RATEMCS7)
+			SET_TX_DESC_DATA_SHORTGI(pdesc, 1);
+
+		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+			SET_TX_DESC_AGG_ENABLE(pdesc, 1);
+			SET_TX_DESC_MAX_AGG_NUM(pdesc, 0x14);
+		}
+		SET_TX_DESC_SEQ(pdesc, seq_number);
+		SET_TX_DESC_RTS_ENABLE(pdesc, ((ptcb_desc->rts_enable &&
+				       !ptcb_desc->cts_enable) ? 1 : 0));
+		SET_TX_DESC_HW_RTS_ENABLE(pdesc, ((ptcb_desc->rts_enable
+					  || ptcb_desc->cts_enable) ? 1 : 0));
+		SET_TX_DESC_CTS2SELF(pdesc, ((ptcb_desc->cts_enable) ? 1 : 0));
+		SET_TX_DESC_RTS_STBC(pdesc, ((ptcb_desc->rts_stbc) ? 1 : 0));
+		/* 5G have no CCK rate */
+		if (rtlhal->current_bandtype == BAND_ON_5G)
+			if (ptcb_desc->rts_rate < DESC92D_RATE6M)
+				ptcb_desc->rts_rate = DESC92D_RATE6M;
+		SET_TX_DESC_RTS_RATE(pdesc, ptcb_desc->rts_rate);
+		SET_TX_DESC_RTS_BW(pdesc, 0);
+		SET_TX_DESC_RTS_SC(pdesc, ptcb_desc->rts_sc);
+		SET_TX_DESC_RTS_SHORT(pdesc, ((ptcb_desc->rts_rate <=
+			DESC92D_RATE54M) ?
+			(ptcb_desc->rts_use_shortpreamble ? 1 : 0) :
+			(ptcb_desc->rts_use_shortgi ? 1 : 0)));
+		if (bw_40) {
+			if (ptcb_desc->packet_bw) {
+				SET_TX_DESC_DATA_BW(pdesc, 1);
+				SET_TX_DESC_TX_SUB_CARRIER(pdesc, 3);
+			} else {
+				SET_TX_DESC_DATA_BW(pdesc, 0);
+				SET_TX_DESC_TX_SUB_CARRIER(pdesc,
+							mac->cur_40_prime_sc);
+			}
+		} else {
+			SET_TX_DESC_DATA_BW(pdesc, 0);
+			SET_TX_DESC_TX_SUB_CARRIER(pdesc, 0);
+		}
+		SET_TX_DESC_LINIP(pdesc, 0);
+		SET_TX_DESC_PKT_SIZE(pdesc, (u16) skb_len);
+		if (sta) {
+			u8 ampdu_density = sta->ht_cap.ampdu_density;
+			SET_TX_DESC_AMPDU_DENSITY(pdesc, ampdu_density);
+		}
+		if (info->control.hw_key) {
+			struct ieee80211_key_conf *keyconf;
+
+			keyconf = info->control.hw_key;
+			switch (keyconf->cipher) {
+			case WLAN_CIPHER_SUITE_WEP40:
+			case WLAN_CIPHER_SUITE_WEP104:
+			case WLAN_CIPHER_SUITE_TKIP:
+				SET_TX_DESC_SEC_TYPE(pdesc, 0x1);
+				break;
+			case WLAN_CIPHER_SUITE_CCMP:
+				SET_TX_DESC_SEC_TYPE(pdesc, 0x3);
+				break;
+			default:
+				SET_TX_DESC_SEC_TYPE(pdesc, 0x0);
+				break;
+
+			}
+		}
+		SET_TX_DESC_PKT_ID(pdesc, 0);
+		SET_TX_DESC_QUEUE_SEL(pdesc, fw_qsel);
+		SET_TX_DESC_DATA_RATE_FB_LIMIT(pdesc, 0x1F);
+		SET_TX_DESC_RTS_RATE_FB_LIMIT(pdesc, 0xF);
+		SET_TX_DESC_DISABLE_FB(pdesc, ptcb_desc->disable_ratefallback ?
+				       1 : 0);
+		SET_TX_DESC_USE_RATE(pdesc, ptcb_desc->use_driver_rate ? 1 : 0);
+
+		/* Set TxRate and RTSRate in TxDesc  */
+		/* This prevent Tx initial rate of new-coming packets */
+		/* from being overwritten by retried  packet rate.*/
+		if (!ptcb_desc->use_driver_rate) {
+			SET_TX_DESC_RTS_RATE(pdesc, 0x08);
+			/* SET_TX_DESC_TX_RATE(pdesc, 0x0b); */
+		}
+		if (ieee80211_is_data_qos(fc)) {
+			if (mac->rdg_en) {
+				RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
+					("Enable RDG function.\n"));
+				SET_TX_DESC_RDG_ENABLE(pdesc, 1);
+				SET_TX_DESC_HTC(pdesc, 1);
+			}
+		}
+	}
+
+	SET_TX_DESC_FIRST_SEG(pdesc, (firstseg ? 1 : 0));
+	SET_TX_DESC_LAST_SEG(pdesc, (lastseg ? 1 : 0));
+	SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16) buf_len);
+	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, mapping);
+	if (rtlpriv->dm.useramask) {
+		SET_TX_DESC_RATE_ID(pdesc, ptcb_desc->ratr_index);
+		SET_TX_DESC_MACID(pdesc, ptcb_desc->mac_id);
+	} else {
+		SET_TX_DESC_RATE_ID(pdesc, 0xC + ptcb_desc->ratr_index);
+		SET_TX_DESC_MACID(pdesc, ptcb_desc->ratr_index);
+	}
+	if (ieee80211_is_data_qos(fc))
+		SET_TX_DESC_QOS(pdesc, 1);
+
+	if ((!ieee80211_is_data_qos(fc)) && ppsc->fwctrl_lps) {
+		SET_TX_DESC_HWSEQ_EN(pdesc, 1);
+		SET_TX_DESC_PKT_ID(pdesc, 8);
+	}
+	SET_TX_DESC_MORE_FRAG(pdesc, (lastseg ? 0 : 1));
+	RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, ("\n"));
+}
+
+void rtl92de_tx_fill_cmddesc(struct ieee80211_hw *hw,
+			     u8 *pdesc, bool firstseg,
+			     bool lastseg, struct sk_buff *skb)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+	u8 fw_queue = QSLT_BEACON;
+	dma_addr_t mapping = pci_map_single(rtlpci->pdev,
+		    skb->data, skb->len, PCI_DMA_TODEVICE);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
+	__le16 fc = hdr->frame_control;
+
+	CLEAR_PCI_TX_DESC_CONTENT(pdesc, TX_DESC_SIZE);
+	if (firstseg)
+		SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
+	/* 5G have no CCK rate
+	 * Caution: The macros below are multi-line expansions.
+	 * The braces are needed no matter what checkpatch says
+	 */
+	if (rtlhal->current_bandtype == BAND_ON_5G) {
+		SET_TX_DESC_TX_RATE(pdesc, DESC92D_RATE6M);
+	} else {
+		SET_TX_DESC_TX_RATE(pdesc, DESC92D_RATE1M);
+	}
+	SET_TX_DESC_SEQ(pdesc, 0);
+	SET_TX_DESC_LINIP(pdesc, 0);
+	SET_TX_DESC_QUEUE_SEL(pdesc, fw_queue);
+	SET_TX_DESC_FIRST_SEG(pdesc, 1);
+	SET_TX_DESC_LAST_SEG(pdesc, 1);
+	SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16) (skb->len));
+	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, mapping);
+	SET_TX_DESC_RATE_ID(pdesc, 7);
+	SET_TX_DESC_MACID(pdesc, 0);
+	SET_TX_DESC_PKT_SIZE((u8 *) pdesc, (u16) (skb->len));
+	SET_TX_DESC_FIRST_SEG(pdesc, 1);
+	SET_TX_DESC_LAST_SEG(pdesc, 1);
+	SET_TX_DESC_OFFSET(pdesc, 0x20);
+	SET_TX_DESC_USE_RATE(pdesc, 1);
+
+	if (!ieee80211_is_data_qos(fc) && ppsc->fwctrl_lps) {
+		SET_TX_DESC_HWSEQ_EN(pdesc, 1);
+		SET_TX_DESC_PKT_ID(pdesc, 8);
+	}
+
+	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_LOUD,
+		      "H2C Tx Cmd Content\n", pdesc, TX_DESC_SIZE);
+	wmb();
+	SET_TX_DESC_OWN(pdesc, 1);
+}
+
+void rtl92de_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
+{
+	if (istx == true) {
+		switch (desc_name) {
+		case HW_DESC_OWN:
+			wmb();
+			SET_TX_DESC_OWN(pdesc, 1);
+			break;
+		case HW_DESC_TX_NEXTDESC_ADDR:
+			SET_TX_DESC_NEXT_DESC_ADDRESS(pdesc, *(u32 *) val);
+			break;
+		default:
+			RT_ASSERT(false, ("ERR txdesc :%d"
+					  " not process\n", desc_name));
+			break;
+		}
+	} else {
+		switch (desc_name) {
+		case HW_DESC_RXOWN:
+			wmb();
+			SET_RX_DESC_OWN(pdesc, 1);
+			break;
+		case HW_DESC_RXBUFF_ADDR:
+			SET_RX_DESC_BUFF_ADDR(pdesc, *(u32 *) val);
+			break;
+		case HW_DESC_RXPKT_LEN:
+			SET_RX_DESC_PKT_LEN(pdesc, *(u32 *) val);
+			break;
+		case HW_DESC_RXERO:
+			SET_RX_DESC_EOR(pdesc, 1);
+			break;
+		default:
+			RT_ASSERT(false, ("ERR rxdesc :%d "
+					  "not process\n", desc_name));
+			break;
+		}
+	}
+}
+
+u32 rtl92de_get_desc(u8 *p_desc, bool istx, u8 desc_name)
+{
+	u32 ret = 0;
+
+	if (istx == true) {
+		switch (desc_name) {
+		case HW_DESC_OWN:
+			ret = GET_TX_DESC_OWN(p_desc);
+			break;
+		case HW_DESC_TXBUFF_ADDR:
+			ret = GET_TX_DESC_TX_BUFFER_ADDRESS(p_desc);
+			break;
+		default:
+			RT_ASSERT(false, ("ERR txdesc :%d "
+					  "not process\n", desc_name));
+			break;
+		}
+	} else {
+		struct rx_desc_92c *pdesc = (struct rx_desc_92c *)p_desc;
+		switch (desc_name) {
+		case HW_DESC_OWN:
+			ret = GET_RX_DESC_OWN(pdesc);
+			break;
+		case HW_DESC_RXPKT_LEN:
+			ret = GET_RX_DESC_PKT_LEN(pdesc);
+			break;
+		default:
+			RT_ASSERT(false, ("ERR rxdesc :%d "
+					  "not process\n", desc_name));
+			break;
+		}
+	}
+	return ret;
+}
+
+void rtl92de_tx_polling(struct ieee80211_hw *hw, u8 hw_queue)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	if (hw_queue == BEACON_QUEUE)
+		rtl_write_word(rtlpriv, REG_PCIE_CTRL_REG, BIT(4));
+	else
+		rtl_write_word(rtlpriv, REG_PCIE_CTRL_REG,
+			       BIT(0) << (hw_queue));
+}
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
===================================================================
--- /dev/null
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
@@ -0,0 +1,756 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#ifndef __RTL92DE_TRX_H__
+#define __RTL92DE_TRX_H__
+
+#define TX_DESC_SIZE				64
+#define TX_DESC_AGGR_SUBFRAME_SIZE		32
+
+#define RX_DESC_SIZE				32
+#define RX_DRV_INFO_SIZE_UNIT			8
+
+#define	TX_DESC_NEXT_DESC_OFFSET		40
+#define USB_HWDESC_HEADER_LEN			32
+#define CRCLENGTH				4
+
+/* Define a macro that takes a le32 word, converts it to host ordering,
+ * right shifts by a specified count, creates a mask of the specified
+ * bit count, and extracts that number of bits.
+ */
+
+#define SHIFT_AND_MASK_LE(__pdesc, __shift, __mask)		\
+	((le32_to_cpu(*(((__le32 *)(__pdesc)))) >> (__shift)) &	\
+	BIT_LEN_MASK_32(__mask))
+
+/* Define a macro that clears a bit field in an le32 word and
+ * sets the specified value into that bit field. The resulting
+ * value remains in le32 ordering; however, it is properly converted
+ * to host ordering for the clear and set operations before conversion
+ * back to le32.
+ */
+
+#define SET_BITS_OFFSET_LE(__pdesc, __shift, __len, __val)	\
+	(*(__le32 *)(__pdesc) =					\
+	(cpu_to_le32((le32_to_cpu(*((__le32 *)(__pdesc))) &	\
+	(~(BIT_OFFSET_LEN_MASK_32((__shift), __len)))) |		\
+	(((u32)(__val) & BIT_LEN_MASK_32(__len)) << (__shift)))));
+
+/* macros to read/write various fields in RX or TX descriptors */
+
+#define SET_TX_DESC_PKT_SIZE(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc, 0, 16, __val)
+#define SET_TX_DESC_OFFSET(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc, 16, 8, __val)
+#define SET_TX_DESC_BMC(__pdesc, __val)			\
+	SET_BITS_OFFSET_LE(__pdesc, 24, 1, __val)
+#define SET_TX_DESC_HTC(__pdesc, __val)			\
+	SET_BITS_OFFSET_LE(__pdesc, 25, 1, __val)
+#define SET_TX_DESC_LAST_SEG(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc, 26, 1, __val)
+#define SET_TX_DESC_FIRST_SEG(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc, 27, 1, __val)
+#define SET_TX_DESC_LINIP(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc, 28, 1, __val)
+#define SET_TX_DESC_NO_ACM(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc, 29, 1, __val)
+#define SET_TX_DESC_GF(__pdesc, __val)			\
+	SET_BITS_OFFSET_LE(__pdesc, 30, 1, __val)
+#define SET_TX_DESC_OWN(__pdesc, __val)			\
+	SET_BITS_OFFSET_LE(__pdesc, 31, 1, __val)
+
+#define GET_TX_DESC_PKT_SIZE(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 0, 16)
+#define GET_TX_DESC_OFFSET(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 16, 8)
+#define GET_TX_DESC_BMC(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 24, 1)
+#define GET_TX_DESC_HTC(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 25, 1)
+#define GET_TX_DESC_LAST_SEG(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 26, 1)
+#define GET_TX_DESC_FIRST_SEG(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 27, 1)
+#define GET_TX_DESC_LINIP(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 28, 1)
+#define GET_TX_DESC_NO_ACM(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 29, 1)
+#define GET_TX_DESC_GF(__pdesc)				\
+	SHIFT_AND_MASK_LE(__pdesc, 30, 1)
+#define GET_TX_DESC_OWN(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 31, 1)
+
+#define SET_TX_DESC_MACID(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+4, 0, 5, __val)
+#define SET_TX_DESC_AGG_ENABLE(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+4, 5, 1, __val)
+#define SET_TX_DESC_BK(__pdesc, __val)			\
+	SET_BITS_OFFSET_LE(__pdesc+4, 6, 1, __val)
+#define SET_TX_DESC_RDG_ENABLE(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+4, 7, 1, __val)
+#define SET_TX_DESC_QUEUE_SEL(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+4, 8, 5, __val)
+#define SET_TX_DESC_RDG_NAV_EXT(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+4, 13, 1, __val)
+#define SET_TX_DESC_LSIG_TXOP_EN(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+4, 14, 1, __val)
+#define SET_TX_DESC_PIFS(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+4, 15, 1, __val)
+#define SET_TX_DESC_RATE_ID(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+4, 16, 4, __val)
+#define SET_TX_DESC_NAV_USE_HDR(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+4, 20, 1, __val)
+#define SET_TX_DESC_EN_DESC_ID(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+4, 21, 1, __val)
+#define SET_TX_DESC_SEC_TYPE(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+4, 22, 2, __val)
+#define SET_TX_DESC_PKT_OFFSET(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+4, 26, 8, __val)
+
+#define GET_TX_DESC_MACID(__pdesc)					\
+	SHIFT_AND_MASK_LE(__pdesc+4, 0, 5)
+#define GET_TX_DESC_AGG_ENABLE(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 5, 1)
+#define GET_TX_DESC_AGG_BREAK(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 6, 1)
+#define GET_TX_DESC_RDG_ENABLE(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 7, 1)
+#define GET_TX_DESC_QUEUE_SEL(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 8, 5)
+#define GET_TX_DESC_RDG_NAV_EXT(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+4, 13, 1)
+#define GET_TX_DESC_LSIG_TXOP_EN(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+4, 14, 1)
+#define GET_TX_DESC_PIFS(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 15, 1)
+#define GET_TX_DESC_RATE_ID(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 16, 4)
+#define GET_TX_DESC_NAV_USE_HDR(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+4, 20, 1)
+#define GET_TX_DESC_EN_DESC_ID(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 21, 1)
+#define GET_TX_DESC_SEC_TYPE(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 22, 2)
+#define GET_TX_DESC_PKT_OFFSET(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 24, 8)
+
+#define SET_TX_DESC_RTS_RC(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+8, 0, 6, __val)
+#define SET_TX_DESC_DATA_RC(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+8, 6, 6, __val)
+#define SET_TX_DESC_BAR_RTY_TH(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+8, 14, 2, __val)
+#define SET_TX_DESC_MORE_FRAG(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+8, 17, 1, __val)
+#define SET_TX_DESC_RAW(__pdesc, __val)			\
+	SET_BITS_OFFSET_LE(__pdesc+8, 18, 1, __val)
+#define SET_TX_DESC_CCX(__pdesc, __val)			\
+	SET_BITS_OFFSET_LE(__pdesc+8, 19, 1, __val)
+#define SET_TX_DESC_AMPDU_DENSITY(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+8, 20, 3, __val)
+#define SET_TX_DESC_ANTSEL_A(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+8, 24, 1, __val)
+#define SET_TX_DESC_ANTSEL_B(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+8, 25, 1, __val)
+#define SET_TX_DESC_TX_ANT_CCK(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+8, 26, 2, __val)
+#define SET_TX_DESC_TX_ANTL(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+8, 28, 2, __val)
+#define SET_TX_DESC_TX_ANT_HT(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+8, 30, 2, __val)
+
+#define GET_TX_DESC_RTS_RC(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 0, 6)
+#define GET_TX_DESC_DATA_RC(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 6, 6)
+#define GET_TX_DESC_BAR_RTY_TH(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 14, 2)
+#define GET_TX_DESC_MORE_FRAG(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 17, 1)
+#define GET_TX_DESC_RAW(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 18, 1)
+#define GET_TX_DESC_CCX(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 19, 1)
+#define GET_TX_DESC_AMPDU_DENSITY(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+8, 20, 3)
+#define GET_TX_DESC_ANTSEL_A(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 24, 1)
+#define GET_TX_DESC_ANTSEL_B(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 25, 1)
+#define GET_TX_DESC_TX_ANT_CCK(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 26, 2)
+#define GET_TX_DESC_TX_ANTL(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 28, 2)
+#define GET_TX_DESC_TX_ANT_HT(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 30, 2)
+
+#define SET_TX_DESC_NEXT_HEAP_PAGE(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+12, 0, 8, __val)
+#define SET_TX_DESC_TAIL_PAGE(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+12, 8, 8, __val)
+#define SET_TX_DESC_SEQ(__pdesc, __val)			\
+	SET_BITS_OFFSET_LE(__pdesc+12, 16, 12, __val)
+#define SET_TX_DESC_PKT_ID(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+12, 28, 4, __val)
+
+#define GET_TX_DESC_NEXT_HEAP_PAGE(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+12, 0, 8)
+#define GET_TX_DESC_TAIL_PAGE(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+12, 8, 8)
+#define GET_TX_DESC_SEQ(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+12, 16, 12)
+#define GET_TX_DESC_PKT_ID(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+12, 28, 4)
+
+#define SET_TX_DESC_RTS_RATE(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 0, 5, __val)
+#define SET_TX_DESC_AP_DCFE(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 5, 1, __val)
+#define SET_TX_DESC_QOS(__pdesc, __val)			\
+	SET_BITS_OFFSET_LE(__pdesc+16, 6, 1, __val)
+#define SET_TX_DESC_HWSEQ_EN(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 7, 1, __val)
+#define SET_TX_DESC_USE_RATE(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 8, 1, __val)
+#define SET_TX_DESC_DISABLE_RTS_FB(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+16, 9, 1, __val)
+#define SET_TX_DESC_DISABLE_FB(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 10, 1, __val)
+#define SET_TX_DESC_CTS2SELF(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 11, 1, __val)
+#define SET_TX_DESC_RTS_ENABLE(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 12, 1, __val)
+#define SET_TX_DESC_HW_RTS_ENABLE(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+16, 13, 1, __val)
+#define SET_TX_DESC_PORT_ID(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 14, 1, __val)
+#define SET_TX_DESC_WAIT_DCTS(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 18, 1, __val)
+#define SET_TX_DESC_CTS2AP_EN(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 19, 1, __val)
+#define SET_TX_DESC_TX_SUB_CARRIER(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+16, 20, 2, __val)
+#define SET_TX_DESC_TX_STBC(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 22, 2, __val)
+#define SET_TX_DESC_DATA_SHORT(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 24, 1, __val)
+#define SET_TX_DESC_DATA_BW(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 25, 1, __val)
+#define SET_TX_DESC_RTS_SHORT(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 26, 1, __val)
+#define SET_TX_DESC_RTS_BW(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 27, 1, __val)
+#define SET_TX_DESC_RTS_SC(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 28, 2, __val)
+#define SET_TX_DESC_RTS_STBC(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+16, 30, 2, __val)
+
+#define GET_TX_DESC_RTS_RATE(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 0, 5)
+#define GET_TX_DESC_AP_DCFE(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 5, 1)
+#define GET_TX_DESC_QOS(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 6, 1)
+#define GET_TX_DESC_HWSEQ_EN(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 7, 1)
+#define GET_TX_DESC_USE_RATE(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 8, 1)
+#define GET_TX_DESC_DISABLE_RTS_FB(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+16, 9, 1)
+#define GET_TX_DESC_DISABLE_FB(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 10, 1)
+#define GET_TX_DESC_CTS2SELF(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 11, 1)
+#define GET_TX_DESC_RTS_ENABLE(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 12, 1)
+#define GET_TX_DESC_HW_RTS_ENABLE(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+16, 13, 1)
+#define GET_TX_DESC_PORT_ID(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 14, 1)
+#define GET_TX_DESC_WAIT_DCTS(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 18, 1)
+#define GET_TX_DESC_CTS2AP_EN(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 19, 1)
+#define GET_TX_DESC_TX_SUB_CARRIER(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+16, 20, 2)
+#define GET_TX_DESC_TX_STBC(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 22, 2)
+#define GET_TX_DESC_DATA_SHORT(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 24, 1)
+#define GET_TX_DESC_DATA_BW(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 25, 1)
+#define GET_TX_DESC_RTS_SHORT(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 26, 1)
+#define GET_TX_DESC_RTS_BW(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 27, 1)
+#define GET_TX_DESC_RTS_SC(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 28, 2)
+#define GET_TX_DESC_RTS_STBC(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 30, 2)
+
+#define SET_TX_DESC_TX_RATE(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+20, 0, 6, __val)
+#define SET_TX_DESC_DATA_SHORTGI(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+20, 6, 1, __val)
+#define SET_TX_DESC_CCX_TAG(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+20, 7, 1, __val)
+#define SET_TX_DESC_DATA_RATE_FB_LIMIT(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+20, 8, 5, __val)
+#define SET_TX_DESC_RTS_RATE_FB_LIMIT(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+20, 13, 4, __val)
+#define SET_TX_DESC_RETRY_LIMIT_ENABLE(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+20, 17, 1, __val)
+#define SET_TX_DESC_DATA_RETRY_LIMIT(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+20, 18, 6, __val)
+#define SET_TX_DESC_USB_TXAGG_NUM(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+20, 24, 8, __val)
+
+#define GET_TX_DESC_TX_RATE(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+20, 0, 6)
+#define GET_TX_DESC_DATA_SHORTGI(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+20, 6, 1)
+#define GET_TX_DESC_CCX_TAG(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+20, 7, 1)
+#define GET_TX_DESC_DATA_RATE_FB_LIMIT(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+20, 8, 5)
+#define GET_TX_DESC_RTS_RATE_FB_LIMIT(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+20, 13, 4)
+#define GET_TX_DESC_RETRY_LIMIT_ENABLE(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+20, 17, 1)
+#define GET_TX_DESC_DATA_RETRY_LIMIT(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+20, 18, 6)
+#define GET_TX_DESC_USB_TXAGG_NUM(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+20, 24, 8)
+
+#define SET_TX_DESC_TXAGC_A(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+24, 0, 5, __val)
+#define SET_TX_DESC_TXAGC_B(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+24, 5, 5, __val)
+#define SET_TX_DESC_USE_MAX_LEN(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+24, 10, 1, __val)
+#define SET_TX_DESC_MAX_AGG_NUM(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+24, 11, 5, __val)
+#define SET_TX_DESC_MCSG1_MAX_LEN(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+24, 16, 4, __val)
+#define SET_TX_DESC_MCSG2_MAX_LEN(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+24, 20, 4, __val)
+#define SET_TX_DESC_MCSG3_MAX_LEN(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+24, 24, 4, __val)
+#define SET_TX_DESC_MCS7_SGI_MAX_LEN(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+24, 28, 4, __val)
+
+#define GET_TX_DESC_TXAGC_A(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+24, 0, 5)
+#define GET_TX_DESC_TXAGC_B(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+24, 5, 5)
+#define GET_TX_DESC_USE_MAX_LEN(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+24, 10, 1)
+#define GET_TX_DESC_MAX_AGG_NUM(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+24, 11, 5)
+#define GET_TX_DESC_MCSG1_MAX_LEN(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+24, 16, 4)
+#define GET_TX_DESC_MCSG2_MAX_LEN(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+24, 20, 4)
+#define GET_TX_DESC_MCSG3_MAX_LEN(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+24, 24, 4)
+#define GET_TX_DESC_MCS7_SGI_MAX_LEN(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+24, 28, 4)
+
+#define SET_TX_DESC_TX_BUFFER_SIZE(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+28, 0, 16, __val)
+#define SET_TX_DESC_MCSG4_MAX_LEN(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+28, 16, 4, __val)
+#define SET_TX_DESC_MCSG5_MAX_LEN(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+28, 20, 4, __val)
+#define SET_TX_DESC_MCSG6_MAX_LEN(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+28, 24, 4, __val)
+#define SET_TX_DESC_MCS15_SGI_MAX_LEN(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+28, 28, 4, __val)
+
+#define GET_TX_DESC_TX_BUFFER_SIZE(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+28, 0, 16)
+#define GET_TX_DESC_MCSG4_MAX_LEN(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+28, 16, 4)
+#define GET_TX_DESC_MCSG5_MAX_LEN(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+28, 20, 4)
+#define GET_TX_DESC_MCSG6_MAX_LEN(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+28, 24, 4)
+#define GET_TX_DESC_MCS15_SGI_MAX_LEN(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+28, 28, 4)
+
+#define SET_TX_DESC_TX_BUFFER_ADDRESS(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+32, 0, 32, __val)
+#define SET_TX_DESC_TX_BUFFER_ADDRESS64(__pdesc, __val) \
+	SET_BITS_OFFSET_LE(__pdesc+36, 0, 32, __val)
+
+#define GET_TX_DESC_TX_BUFFER_ADDRESS(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+32, 0, 32)
+#define GET_TX_DESC_TX_BUFFER_ADDRESS64(__pdesc)	\
+	SHIFT_AND_MASK_LE(__pdesc+36, 0, 32)
+
+#define SET_TX_DESC_NEXT_DESC_ADDRESS(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+40, 0, 32, __val)
+#define SET_TX_DESC_NEXT_DESC_ADDRESS64(__pdesc, __val) \
+	SET_BITS_OFFSET_LE(__pdesc+44, 0, 32, __val)
+
+#define GET_TX_DESC_NEXT_DESC_ADDRESS(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+40, 0, 32)
+#define GET_TX_DESC_NEXT_DESC_ADDRESS64(__pdesc)	\
+	SHIFT_AND_MASK_LE(__pdesc+44, 0, 32)
+
+#define GET_RX_DESC_PKT_LEN(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 0, 14)
+#define GET_RX_DESC_CRC32(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 14, 1)
+#define GET_RX_DESC_ICV(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 15, 1)
+#define GET_RX_DESC_DRV_INFO_SIZE(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc, 16, 4)
+#define GET_RX_DESC_SECURITY(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 20, 3)
+#define GET_RX_DESC_QOS(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 23, 1)
+#define GET_RX_DESC_SHIFT(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 24, 2)
+#define GET_RX_DESC_PHYST(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 26, 1)
+#define GET_RX_DESC_SWDEC(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 27, 1)
+#define GET_RX_DESC_LS(__pdesc)				\
+	SHIFT_AND_MASK_LE(__pdesc, 28, 1)
+#define GET_RX_DESC_FS(__pdesc)				\
+	SHIFT_AND_MASK_LE(__pdesc, 29, 1)
+#define GET_RX_DESC_EOR(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 30, 1)
+#define GET_RX_DESC_OWN(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc, 31, 1)
+
+#define SET_RX_DESC_PKT_LEN(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc, 0, 14, __val)
+#define SET_RX_DESC_EOR(__pdesc, __val)			\
+	SET_BITS_OFFSET_LE(__pdesc, 30, 1, __val)
+#define SET_RX_DESC_OWN(__pdesc, __val)			\
+	SET_BITS_OFFSET_LE(__pdesc, 31, 1, __val)
+
+#define GET_RX_DESC_MACID(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 0, 5)
+#define GET_RX_DESC_TID(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 5, 4)
+#define GET_RX_DESC_HWRSVD(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 9, 5)
+#define GET_RX_DESC_PAGGR(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 14, 1)
+#define GET_RX_DESC_FAGGR(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 15, 1)
+#define GET_RX_DESC_A1_FIT(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 16, 4)
+#define GET_RX_DESC_A2_FIT(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 20, 4)
+#define GET_RX_DESC_PAM(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 24, 1)
+#define GET_RX_DESC_PWR(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 25, 1)
+#define GET_RX_DESC_MD(__pdesc)				\
+	SHIFT_AND_MASK_LE(__pdesc+4, 26, 1)
+#define GET_RX_DESC_MF(__pdesc)				\
+	SHIFT_AND_MASK_LE(__pdesc+4, 27, 1)
+#define GET_RX_DESC_TYPE(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+4, 28, 2)
+#define GET_RX_DESC_MC(__pdesc)				\
+	SHIFT_AND_MASK_LE(__pdesc+4, 30, 1)
+#define GET_RX_DESC_BC(__pdesc)				\
+	SHIFT_AND_MASK_LE(__pdesc+4, 31, 1)
+#define GET_RX_DESC_SEQ(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 0, 12)
+#define GET_RX_DESC_FRAG(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 12, 4)
+#define GET_RX_DESC_NEXT_PKT_LEN(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+8, 16, 14)
+#define GET_RX_DESC_NEXT_IND(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 30, 1)
+#define GET_RX_DESC_RSVD(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+8, 31, 1)
+
+#define GET_RX_DESC_RXMCS(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+12, 0, 6)
+#define GET_RX_DESC_RXHT(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+12, 6, 1)
+#define GET_RX_DESC_SPLCP(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+12, 8, 1)
+#define GET_RX_DESC_BW(__pdesc)				\
+	SHIFT_AND_MASK_LE(__pdesc+12, 9, 1)
+#define GET_RX_DESC_HTC(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+12, 10, 1)
+#define GET_RX_DESC_HWPC_ERR(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+12, 14, 1)
+#define GET_RX_DESC_HWPC_IND(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+12, 15, 1)
+#define GET_RX_DESC_IV0(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+12, 16, 16)
+
+#define GET_RX_DESC_IV1(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+16, 0, 32)
+#define GET_RX_DESC_TSFL(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+20, 0, 32)
+
+#define GET_RX_DESC_BUFF_ADDR(__pdesc)			\
+	SHIFT_AND_MASK_LE(__pdesc+24, 0, 32)
+#define GET_RX_DESC_BUFF_ADDR64(__pdesc)		\
+	SHIFT_AND_MASK_LE(__pdesc+28, 0, 32)
+
+#define SET_RX_DESC_BUFF_ADDR(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+24, 0, 32, __val)
+#define SET_RX_DESC_BUFF_ADDR64(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+28, 0, 32, __val)
+
+#define CLEAR_PCI_TX_DESC_CONTENT(__pdesc, _size)	\
+do {							\
+	if (_size > TX_DESC_NEXT_DESC_OFFSET)		\
+		memset((void *)__pdesc, 0, TX_DESC_NEXT_DESC_OFFSET);	\
+	else						\
+		memset((void *)__pdesc, 0, _size);	\
+} while (0);
+
+#define RX_HAL_IS_CCK_RATE(_pdesc)\
+	(_pdesc->rxmcs == DESC92D_RATE1M ||		\
+	 _pdesc->rxmcs == DESC92D_RATE2M ||		\
+	 _pdesc->rxmcs == DESC92D_RATE5_5M ||		\
+	 _pdesc->rxmcs == DESC92D_RATE11M)
+
+/* For 92D early mode */
+#define SET_EARLYMODE_PKTNUM(__paddr, __value)		\
+	SET_BITS_OFFSET_LE(__paddr, 0, 3, __value)
+#define SET_EARLYMODE_LEN0(__paddr, __value)		\
+	SET_BITS_OFFSET_LE(__paddr, 4, 12, __value)
+#define SET_EARLYMODE_LEN1(__paddr, __value)		\
+	SET_BITS_OFFSET_LE(__paddr, 16, 12, __value)
+#define SET_EARLYMODE_LEN2_1(__paddr, __value)		\
+	SET_BITS_OFFSET_LE(__paddr, 28, 4, __value)
+#define SET_EARLYMODE_LEN2_2(__paddr, __value)		\
+	SET_BITS_OFFSET_LE(__paddr+4, 0, 8, __value)
+#define SET_EARLYMODE_LEN3(__paddr, __value)		\
+	SET_BITS_OFFSET_LE(__paddr+4, 8, 12, __value)
+#define SET_EARLYMODE_LEN4(__paddr, __value)		\
+	SET_BITS_OFFSET_LE(__paddr+4, 20, 12, __value)
+
+struct rx_fwinfo_92d {
+	u8 gain_trsw[4];
+	u8 pwdb_all;
+	u8 cfosho[4];
+	u8 cfotail[4];
+	char rxevm[2];
+	char rxsnr[4];
+	u8 pdsnr[2];
+	u8 csi_current[2];
+	u8 csi_target[2];
+	u8 sigevm;
+	u8 max_ex_pwr;
+	u8 ex_intf_flag:1;
+	u8 sgi_en:1;
+	u8 rxsc:2;
+	u8 reserve:4;
+} __packed;
+
+struct tx_desc_92d {
+	u32 pktsize:16;
+	u32 offset:8;
+	u32 bmc:1;
+	u32 htc:1;
+	u32 lastseg:1;
+	u32 firstseg:1;
+	u32 linip:1;
+	u32 noacm:1;
+	u32 gf:1;
+	u32 own:1;
+
+	u32 macid:5;
+	u32 agg_en:1;
+	u32 bk:1;
+	u32 rdg_en:1;
+	u32 queuesel:5;
+	u32 rd_nav_ext:1;
+	u32 lsig_txop_en:1;
+	u32 pifs:1;
+	u32 rateid:4;
+	u32 nav_usehdr:1;
+	u32 en_descid:1;
+	u32 sectype:2;
+	u32 pktoffset:8;
+
+	u32 rts_rc:6;
+	u32 data_rc:6;
+	u32 rsvd0:2;
+	u32 bar_retryht:2;
+	u32 rsvd1:1;
+	u32 morefrag:1;
+	u32 raw:1;
+	u32 ccx:1;
+	u32 ampdudensity:3;
+	u32 rsvd2:1;
+	u32 ant_sela:1;
+	u32 ant_selb:1;
+	u32 txant_cck:2;
+	u32 txant_l:2;
+	u32 txant_ht:2;
+
+	u32 nextheadpage:8;
+	u32 tailpage:8;
+	u32 seq:12;
+	u32 pktid:4;
+
+	u32 rtsrate:5;
+	u32 apdcfe:1;
+	u32 qos:1;
+	u32 hwseq_enable:1;
+	u32 userrate:1;
+	u32 dis_rtsfb:1;
+	u32 dis_datafb:1;
+	u32 cts2self:1;
+	u32 rts_en:1;
+	u32 hwrts_en:1;
+	u32 portid:1;
+	u32 rsvd3:3;
+	u32 waitdcts:1;
+	u32 cts2ap_en:1;
+	u32 txsc:2;
+	u32 stbc:2;
+	u32 txshort:1;
+	u32 txbw:1;
+	u32 rtsshort:1;
+	u32 rtsbw:1;
+	u32 rtssc:2;
+	u32 rtsstbc:2;
+
+	u32 txrate:6;
+	u32 shortgi:1;
+	u32 ccxt:1;
+	u32 txrate_fb_lmt:5;
+	u32 rtsrate_fb_lmt:4;
+	u32 retrylmt_en:1;
+	u32 txretrylmt:6;
+	u32 usb_txaggnum:8;
+
+	u32 txagca:5;
+	u32 txagcb:5;
+	u32 usemaxlen:1;
+	u32 maxaggnum:5;
+	u32 mcsg1maxlen:4;
+	u32 mcsg2maxlen:4;
+	u32 mcsg3maxlen:4;
+	u32 mcs7sgimaxlen:4;
+
+	u32 txbuffersize:16;
+	u32 mcsg4maxlen:4;
+	u32 mcsg5maxlen:4;
+	u32 mcsg6maxlen:4;
+	u32 mcsg15sgimaxlen:4;
+
+	u32 txbuffaddr;
+	u32 txbufferaddr64;
+	u32 nextdescaddress;
+	u32 nextdescaddress64;
+
+	u32 reserve_pass_pcie_mm_limit[4];
+} __packed;
+
+struct rx_desc_92d {
+	u32 length:14;
+	u32 crc32:1;
+	u32 icverror:1;
+	u32 drv_infosize:4;
+	u32 security:3;
+	u32 qos:1;
+	u32 shift:2;
+	u32 phystatus:1;
+	u32 swdec:1;
+	u32 lastseg:1;
+	u32 firstseg:1;
+	u32 eor:1;
+	u32 own:1;
+
+	u32 macid:5;
+	u32 tid:4;
+	u32 hwrsvd:5;
+	u32 paggr:1;
+	u32 faggr:1;
+	u32 a1_fit:4;
+	u32 a2_fit:4;
+	u32 pam:1;
+	u32 pwr:1;
+	u32 moredata:1;
+	u32 morefrag:1;
+	u32 type:2;
+	u32 mc:1;
+	u32 bc:1;
+
+	u32 seq:12;
+	u32 frag:4;
+	u32 nextpktlen:14;
+	u32 nextind:1;
+	u32 rsvd:1;
+
+	u32 rxmcs:6;
+	u32 rxht:1;
+	u32 amsdu:1;
+	u32 splcp:1;
+	u32 bandwidth:1;
+	u32 htc:1;
+	u32 tcpchk_rpt:1;
+	u32 ipcchk_rpt:1;
+	u32 tcpchk_valid:1;
+	u32 hwpcerr:1;
+	u32 hwpcind:1;
+	u32 iv0:16;
+
+	u32 iv1;
+
+	u32 tsfl;
+
+	u32 bufferaddress;
+	u32 bufferaddress64;
+
+} __packed;
+
+void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
+			  struct ieee80211_hdr *hdr,
+			  u8 *pdesc, struct ieee80211_tx_info *info,
+			  struct sk_buff *skb, u8 hw_queue,
+			  struct rtl_tcb_desc *ptcb_desc);
+bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,
+			   struct rtl_stats *stats,
+			   struct ieee80211_rx_status *rx_status,
+			   u8 *pdesc, struct sk_buff *skb);
+void rtl92de_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val);
+u32 rtl92de_get_desc(u8 *pdesc, bool istx, u8 desc_name);
+void rtl92de_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
+void rtl92de_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
+			     bool b_firstseg, bool b_lastseg,
+			     struct sk_buff *skb);
+
+#endif
