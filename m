Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E18C65BA7
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 11:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56907213A2
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 11:21:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56907213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbeJCSJd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 14:09:33 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:58131 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbeJCSJc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 14:09:32 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w93BLH8j012979, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w93BLH8j012979
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Wed, 3 Oct 2018 19:21:17 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Wed, 3 Oct 2018 19:21:17 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <pkshih@realtek.com>,
        <tehuang@realtek.com>, <sgruszka@redhat.com>,
        <linux-wireless@vger.kernel.org>
Subject: [RFC v3 04/12] rtw88: trx files
Date:   Wed, 3 Oct 2018 19:20:51 +0800
Message-ID: <1538565659-29530-5-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.143]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

trx files for Realtek 802.11ac wireless network chips

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/rx.c | 144 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rx.h |  30 ++++
 drivers/net/wireless/realtek/rtw88/tx.c | 271 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/tx.h |  81 ++++++++++
 4 files changed, 526 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rx.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rx.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/tx.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/tx.h

diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
new file mode 100644
index 0000000..83214db
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "rx.h"
+#include "ps.h"
+
+void rtw_rx_stats(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
+		  struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+	struct rtw_vif *rtwvif;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return;
+
+	if (!is_broadcast_ether_addr(hdr->addr1) &&
+	    !is_multicast_ether_addr(hdr->addr1)) {
+		rtwdev->stats.rx_unicast += skb->len;
+		rtwdev->stats.rx_cnt++;
+		if (vif) {
+			rtwvif = (struct rtw_vif *)vif->drv_priv;
+			rtwvif->stats.rx_unicast += skb->len;
+			rtwvif->stats.rx_cnt++;
+			if (rtwvif->stats.rx_cnt > RTW_LPS_THRESHOLD)
+				rtw_leave_lps_irqsafe(rtwdev, rtwvif);
+		}
+	}
+}
+EXPORT_SYMBOL(rtw_rx_stats);
+
+static void rtw_rx_rssi_add(struct rtw_dev *rtwdev,
+			    struct rtw_rx_pkt_stat *pkt_stat,
+			    struct ieee80211_hdr *hdr)
+{
+	struct ieee80211_vif *vif;
+	struct rtw_vif *rtwvif;
+	struct rtw_sta_info *si;
+	__le16 fc = hdr->frame_control;
+	u8 *bssid;
+	u8 macid = RTW_BC_MC_MACID;
+	bool match_bssid = false;
+	bool is_packet_match_bssid;
+	bool if_addr_match;
+	bool hw_err;
+	bool ctl;
+
+	rcu_read_lock();
+
+	bssid = get_hdr_bssid(hdr);
+	rtwvif = get_hdr_vif(rtwdev, hdr);
+	vif = rtwvif ? rtwvif->vif : NULL;
+	pkt_stat->vif = vif;
+	if (unlikely(is_broadcast_ether_addr(hdr->addr1) ||
+		     is_multicast_ether_addr(hdr->addr1)))
+		match_bssid = get_hdr_match_bssid(rtwdev, hdr, bssid);
+	else if (vif)
+		match_bssid = ether_addr_equal(vif->bss_conf.bssid, bssid);
+	si = get_hdr_sta(rtwdev, vif, hdr);
+	macid = si ? si->mac_id : RTW_BC_MC_MACID;
+	pkt_stat->mac_id = macid;
+	pkt_stat->si = si;
+
+	if_addr_match = !!vif;
+	hw_err = pkt_stat->crc_err || pkt_stat->icv_err;
+	ctl = ieee80211_is_ctl(fc);
+	is_packet_match_bssid = !hw_err && !ctl && match_bssid;
+
+	if (((match_bssid && if_addr_match) || ieee80211_is_beacon(fc)) &&
+	    (!hw_err && !ctl) && (pkt_stat->phy_status && pkt_stat->si))
+		ewma_rssi_add(&pkt_stat->si->avg_rssi, pkt_stat->rssi);
+
+	rcu_read_unlock();
+}
+
+void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
+			   struct rtw_rx_pkt_stat *pkt_stat,
+			   struct ieee80211_hdr *hdr,
+			   struct ieee80211_rx_status *rx_status,
+			   u8 *phy_status)
+{
+	struct ieee80211_hw *hw = rtwdev->hw;
+
+	memset(rx_status, 0, sizeof(*rx_status));
+	rx_status->freq = hw->conf.chandef.chan->center_freq;
+	rx_status->band = hw->conf.chandef.chan->band;
+	if (pkt_stat->crc_err)
+		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+	if (pkt_stat->decrypted)
+		rx_status->flag |= RX_FLAG_DECRYPTED;
+
+	if (pkt_stat->rate >= DESC_RATEVHT1SS_MCS0)
+		rx_status->encoding = RX_ENC_VHT;
+	else if (pkt_stat->rate >= DESC_RATEMCS0)
+		rx_status->encoding = RX_ENC_HT;
+
+	if (pkt_stat->rate >= DESC_RATEVHT1SS_MCS0 &&
+	    pkt_stat->rate <= DESC_RATEVHT1SS_MCS9) {
+		rx_status->nss = 1;
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATEVHT1SS_MCS0;
+	} else if (pkt_stat->rate >= DESC_RATEVHT2SS_MCS0 &&
+		   pkt_stat->rate <= DESC_RATEVHT2SS_MCS9) {
+		rx_status->nss = 2;
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATEVHT2SS_MCS0;
+	} else if (pkt_stat->rate >= DESC_RATEVHT3SS_MCS0 &&
+		   pkt_stat->rate <= DESC_RATEVHT3SS_MCS9) {
+		rx_status->nss = 3;
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATEVHT3SS_MCS0;
+	} else if (pkt_stat->rate >= DESC_RATEVHT4SS_MCS0 &&
+		   pkt_stat->rate <= DESC_RATEVHT4SS_MCS9) {
+		rx_status->nss = 4;
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATEVHT4SS_MCS0;
+	} else if (pkt_stat->rate >= DESC_RATEMCS0 &&
+		   pkt_stat->rate <= DESC_RATEMCS15) {
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATEMCS0;
+	} else if (rx_status->band == NL80211_BAND_5GHZ &&
+		   pkt_stat->rate >= DESC_RATE6M &&
+		   pkt_stat->rate <= DESC_RATE54M) {
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATE6M;
+	} else if (rx_status->band == NL80211_BAND_2GHZ &&
+		   pkt_stat->rate >= DESC_RATE1M &&
+		   pkt_stat->rate <= DESC_RATE54M) {
+		rx_status->rate_idx = pkt_stat->rate - DESC_RATE1M;
+	} else {
+		rx_status->rate_idx = 0;
+	}
+
+	rx_status->flag |= RX_FLAG_MACTIME_START;
+	rx_status->mactime = pkt_stat->tsf_low;
+
+	if (pkt_stat->bw == RTW_CHANNEL_WIDTH_80)
+		rx_status->bw = RATE_INFO_BW_80;
+	else if (pkt_stat->bw == RTW_CHANNEL_WIDTH_40)
+		rx_status->bw = RATE_INFO_BW_40;
+	else
+		rx_status->bw = RATE_INFO_BW_20;
+
+	rx_status->signal = pkt_stat->signal_power;
+
+	rtw_rx_rssi_add(rtwdev, pkt_stat, hdr);
+}
diff --git a/drivers/net/wireless/realtek/rtw88/rx.h b/drivers/net/wireless/realtek/rtw88/rx.h
new file mode 100644
index 0000000..9a71ffb
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rx.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_RX_H_
+#define __RTW_RX_H_
+
+#define GET_RX_DESC_PHYST(rxdesc) LE_BITS_TO_4BYTE((rxdesc) + 0x00, 26, 1)
+#define GET_RX_DESC_ICV_ERR(rxdesc) LE_BITS_TO_4BYTE((rxdesc) + 0x00, 15, 1)
+#define GET_RX_DESC_CRC32(rxdesc) LE_BITS_TO_4BYTE((rxdesc) + 0x00, 14, 1)
+#define GET_RX_DESC_SWDEC(rxdesc) LE_BITS_TO_4BYTE((rxdesc) + 0x00, 27, 1)
+#define GET_RX_DESC_C2H(rxdesc) LE_BITS_TO_4BYTE((rxdesc) + 0x08, 28, 1)
+#define GET_RX_DESC_PKT_LEN(rxdesc) LE_BITS_TO_4BYTE((rxdesc) + 0x00, 0, 14)
+#define GET_RX_DESC_DRV_INFO_SIZE(rxdesc) \
+	LE_BITS_TO_4BYTE((rxdesc) + 0x00, 16, 4)
+#define GET_RX_DESC_SHIFT(rxdesc) LE_BITS_TO_4BYTE((rxdesc) + 0x00, 24, 2)
+#define GET_RX_DESC_RX_RATE(rxdesc) LE_BITS_TO_4BYTE((rxdesc) + 0x0C, 0, 7)
+#define GET_RX_DESC_MACID(rxdesc) LE_BITS_TO_4BYTE((rxdesc) + 0x04, 0, 7)
+#define GET_RX_DESC_PPDU_CNT(rxdesc) LE_BITS_TO_4BYTE((rxdesc) + 0x08, 29, 2)
+#define GET_RX_DESC_TSFL(rxdesc) LE_BITS_TO_4BYTE((rxdesc) + 0x14, 0, 32)
+
+void rtw_rx_stats(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
+		  struct sk_buff *skb);
+void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
+			   struct rtw_rx_pkt_stat *pkt_stat,
+			   struct ieee80211_hdr *hdr,
+			   struct ieee80211_rx_status *rx_status,
+			   u8 *phy_status);
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
new file mode 100644
index 0000000..eb70123
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "tx.h"
+#include "ps.h"
+
+static
+void rtw_tx_stats(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
+		  struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+	struct rtw_vif *rtwvif;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return;
+
+	if (!is_broadcast_ether_addr(hdr->addr1) &&
+	    !is_multicast_ether_addr(hdr->addr1)) {
+		rtwdev->stats.tx_unicast += skb->len;
+		rtwdev->stats.tx_cnt++;
+		if (vif) {
+			rtwvif = (struct rtw_vif *)vif->drv_priv;
+			rtwvif->stats.tx_unicast += skb->len;
+			rtwvif->stats.tx_cnt++;
+			if (rtwvif->stats.tx_cnt > RTW_LPS_THRESHOLD)
+				rtw_leave_lps_irqsafe(rtwdev, rtwvif);
+		}
+	}
+}
+
+void rtw_tx_fill_tx_desc(struct rtw_tx_pkt_info *pkt_info, struct sk_buff *skb)
+{
+	u8 *buf = skb->data;
+
+	SET_TX_DESC_TXPKTSIZE(buf, pkt_info->tx_pkt_size);
+	SET_TX_DESC_OFFSET(buf, pkt_info->offset);
+	SET_TX_DESC_PKT_OFFSET(buf, pkt_info->pkt_offset);
+	SET_TX_DESC_QSEL(buf, pkt_info->qsel);
+	SET_TX_DESC_BMC(buf, pkt_info->bmc);
+	SET_TX_DESC_RATE_ID(buf, pkt_info->rate_id);
+	SET_TX_DESC_DATARATE(buf, pkt_info->rate);
+	SET_TX_DESC_DISDATAFB(buf, pkt_info->dis_rate_fallback);
+	SET_TX_DESC_USE_RATE(buf, pkt_info->use_rate);
+	SET_TX_DESC_SEC_TYPE(buf, pkt_info->sec_type);
+	SET_TX_DESC_DATA_BW(buf, pkt_info->bw);
+	SET_TX_DESC_SW_SEQ(buf, pkt_info->seq);
+	SET_TX_DESC_MAX_AGG_NUM(buf, pkt_info->ampdu_factor);
+	SET_TX_DESC_AMPDU_DENSITY(buf, pkt_info->ampdu_density);
+	SET_TX_DESC_DATA_STBC(buf, pkt_info->stbc);
+	SET_TX_DESC_DATA_LDPC(buf, pkt_info->ldpc);
+	SET_TX_DESC_AGG_EN(buf, pkt_info->ampdu_en);
+	SET_TX_DESC_LS(buf, 1);
+	SET_TX_DESC_DATA_SHORT(buf, pkt_info->short_gi);
+}
+EXPORT_SYMBOL(rtw_tx_fill_tx_desc);
+
+static u8 get_tx_ampdu_factor(struct ieee80211_sta *sta)
+{
+	u8 exp = sta->ht_cap.ampdu_factor;
+
+	/* the least ampdu factor is 8K, and the value in the tx desc is the
+	 * max aggregation num, which represents val * 2 packets can be
+	 * aggregated in an AMPDU, so here we should use 8/2=4 as the base
+	 */
+	return (BIT(2) << exp) - 1;
+}
+
+static u8 get_tx_ampdu_density(struct ieee80211_sta *sta)
+{
+	return sta->ht_cap.ampdu_density;
+}
+
+static u8 get_highest_ht_tx_rate(struct rtw_dev *rtwdev,
+				 struct ieee80211_sta *sta)
+{
+	u8 rate;
+
+	if (rtwdev->hal.rf_type == RF_2T2R && sta->ht_cap.mcs.rx_mask[1] != 0)
+		rate = DESC_RATEMCS15;
+	else
+		rate = DESC_RATEMCS7;
+
+	return rate;
+}
+
+static u8 get_highest_vht_tx_rate(struct rtw_dev *rtwdev,
+				  struct ieee80211_sta *sta)
+{
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	u8 rate;
+	u16 tx_mcs_map;
+
+	tx_mcs_map = le16_to_cpu(sta->vht_cap.vht_mcs.tx_mcs_map);
+	if (efuse->hw_cap.nss == 1) {
+		switch (tx_mcs_map & 0x3) {
+		case IEEE80211_VHT_MCS_SUPPORT_0_7:
+			rate = DESC_RATEVHT1SS_MCS7;
+			break;
+		case IEEE80211_VHT_MCS_SUPPORT_0_8:
+			rate = DESC_RATEVHT1SS_MCS8;
+			break;
+		default:
+		case IEEE80211_VHT_MCS_SUPPORT_0_9:
+			rate = DESC_RATEVHT1SS_MCS9;
+			break;
+		}
+	} else if (efuse->hw_cap.nss >= 2) {
+		switch ((tx_mcs_map & 0xc) >> 2) {
+		case IEEE80211_VHT_MCS_SUPPORT_0_7:
+			rate = DESC_RATEVHT2SS_MCS7;
+			break;
+		case IEEE80211_VHT_MCS_SUPPORT_0_8:
+			rate = DESC_RATEVHT2SS_MCS8;
+			break;
+		default:
+		case IEEE80211_VHT_MCS_SUPPORT_0_9:
+			rate = DESC_RATEVHT2SS_MCS9;
+			break;
+		}
+	} else {
+		rate = DESC_RATEVHT1SS_MCS9;
+	}
+
+	return rate;
+}
+
+static void rtw_tx_mgmt_pkt_info_update(struct rtw_dev *rtwdev,
+					struct rtw_tx_pkt_info *pkt_info,
+					struct ieee80211_tx_control *control,
+					struct sk_buff *skb)
+{
+	pkt_info->use_rate = true;
+	pkt_info->rate_id = 6;
+	pkt_info->dis_rate_fallback = true;
+}
+
+static void rtw_tx_data_pkt_info_update(struct rtw_dev *rtwdev,
+					struct rtw_tx_pkt_info *pkt_info,
+					struct ieee80211_tx_control *control,
+					struct sk_buff *skb)
+{
+	struct ieee80211_sta *sta = control->sta;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct rtw_sta_info *si;
+	u16 seq;
+	u8 ampdu_factor = 0;
+	u8 ampdu_density = 0;
+	bool ampdu_en = false;
+	u8 rate = DESC_RATE6M;
+	u8 rate_id = 6;
+	u8 bw = RTW_CHANNEL_WIDTH_20;
+	bool stbc = false;
+	bool ldpc = false;
+
+	seq = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
+
+	/* for broadcast/multicast, use default values */
+	if (!sta)
+		goto out;
+
+	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+		ampdu_en = true;
+		ampdu_factor = get_tx_ampdu_factor(sta);
+		ampdu_density = get_tx_ampdu_density(sta);
+	}
+
+	if (sta->vht_cap.vht_supported)
+		rate = get_highest_vht_tx_rate(rtwdev, sta);
+	else if (sta->ht_cap.ht_supported)
+		rate = get_highest_ht_tx_rate(rtwdev, sta);
+	else if (sta->supp_rates[0] <= 0xf)
+		rate = DESC_RATE11M;
+	else
+		rate = DESC_RATE54M;
+
+	si = (struct rtw_sta_info *)sta->drv_priv;
+
+	bw = si->bw_mode;
+	rate_id = si->rate_id;
+	stbc = si->stbc_en;
+	ldpc = si->ldpc_en;
+
+out:
+	pkt_info->seq = seq;
+	pkt_info->ampdu_factor = ampdu_factor;
+	pkt_info->ampdu_density = ampdu_density;
+	pkt_info->ampdu_en = ampdu_en;
+	pkt_info->rate = rate;
+	pkt_info->rate_id = rate_id;
+	pkt_info->bw = bw;
+	pkt_info->stbc = stbc;
+	pkt_info->ldpc = ldpc;
+}
+
+void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
+			    struct rtw_tx_pkt_info *pkt_info,
+			    struct ieee80211_tx_control *control,
+			    struct sk_buff *skb)
+{
+	struct rtw_chip_info *chip = rtwdev->chip;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct rtw_sta_info *si;
+	struct ieee80211_vif *vif = NULL;
+	__le16 fc = hdr->frame_control;
+	u8 sec_type = 0;
+	bool bmc;
+
+	if (control->sta) {
+		si = (struct rtw_sta_info *)control->sta->drv_priv;
+		vif = si->vif;
+	}
+
+	if (ieee80211_is_mgmt(fc) || ieee80211_is_nullfunc(fc))
+		rtw_tx_mgmt_pkt_info_update(rtwdev, pkt_info, control, skb);
+	else if (ieee80211_is_data(fc))
+		rtw_tx_data_pkt_info_update(rtwdev, pkt_info, control, skb);
+
+	if (info->control.hw_key) {
+		struct ieee80211_key_conf *key = info->control.hw_key;
+
+		switch (key->cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+		case WLAN_CIPHER_SUITE_TKIP:
+			sec_type = 0x01;
+			break;
+		case WLAN_CIPHER_SUITE_CCMP:
+			sec_type = 0x03;
+			break;
+		default:
+			break;
+		}
+	}
+
+	bmc = is_broadcast_ether_addr(hdr->addr1) ||
+	      is_multicast_ether_addr(hdr->addr1);
+
+	pkt_info->bmc = bmc;
+	pkt_info->sec_type = sec_type;
+	pkt_info->tx_pkt_size = skb->len;
+	pkt_info->offset = chip->tx_pkt_desc_sz;
+	pkt_info->qsel = skb->priority;
+
+	/* maybe merge with tx status ? */
+	rtw_tx_stats(rtwdev, vif, skb);
+}
+
+void rtw_rsvd_page_pkt_info_update(struct rtw_dev *rtwdev,
+				   struct rtw_tx_pkt_info *pkt_info,
+				   struct sk_buff *skb)
+{
+	struct rtw_chip_info *chip = rtwdev->chip;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	bool bmc;
+
+	bmc = is_broadcast_ether_addr(hdr->addr1) ||
+	      is_multicast_ether_addr(hdr->addr1);
+	pkt_info->use_rate = true;
+	pkt_info->rate_id = 6;
+	pkt_info->dis_rate_fallback = true;
+	pkt_info->bmc = bmc;
+	pkt_info->tx_pkt_size = skb->len;
+	pkt_info->offset = chip->tx_pkt_desc_sz;
+	pkt_info->qsel = skb->priority;
+}
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
new file mode 100644
index 0000000..f1b6686
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_TX_H_
+#define __RTW_TX_H_
+
+#define RTK_TX_MAX_AGG_NUM_MASK		0x1f
+
+#define SET_TX_DESC_TXPKTSIZE(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x00, 0, 16, value)
+#define SET_TX_DESC_OFFSET(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x00, 16, 8, value)
+#define SET_TX_DESC_PKT_OFFSET(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x04, 24, 5, value)
+#define SET_TX_DESC_QSEL(txdesc, value)                                        \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x04, 8, 5, value)
+#define SET_TX_DESC_BMC(txdesc, value)                                         \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x00, 24, 1, value)
+#define SET_TX_DESC_RATE_ID(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x04, 16, 5, value)
+#define SET_TX_DESC_DATARATE(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x10, 0, 7, value)
+#define SET_TX_DESC_DISDATAFB(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x0C, 10, 1, value)
+#define SET_TX_DESC_USE_RATE(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x0C, 8, 1, value)
+#define SET_TX_DESC_SEC_TYPE(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x04, 22, 2, value)
+#define SET_TX_DESC_DATA_BW(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x14, 5, 2, value)
+#define SET_TX_DESC_SW_SEQ(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x24, 12, 12, value)
+#define SET_TX_DESC_MAX_AGG_NUM(txdesc, value)                                 \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x0C, 17, 5, value)
+#define SET_TX_DESC_AMPDU_DENSITY(txdesc, value)                               \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x08, 20, 3, value)
+#define SET_TX_DESC_DATA_STBC(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x14, 8, 2, value)
+#define SET_TX_DESC_DATA_LDPC(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x14, 7, 1, value)
+#define SET_TX_DESC_AGG_EN(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x08, 12, 1, value)
+#define SET_TX_DESC_LS(txdesc, value)                                          \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x00, 26, 1, value)
+#define SET_TX_DESC_DATA_SHORT(txdesc, value)				       \
+	SET_BITS_TO_LE_4BYTE((txdesc) + 0x14, 4, 1, value)
+
+enum rtw_tx_desc_queue_select {
+	TX_DESC_QSEL_TID0	= 0,
+	TX_DESC_QSEL_TID1	= 1,
+	TX_DESC_QSEL_TID2	= 2,
+	TX_DESC_QSEL_TID3	= 3,
+	TX_DESC_QSEL_TID4	= 4,
+	TX_DESC_QSEL_TID5	= 5,
+	TX_DESC_QSEL_TID6	= 6,
+	TX_DESC_QSEL_TID7	= 7,
+	TX_DESC_QSEL_TID8	= 8,
+	TX_DESC_QSEL_TID9	= 9,
+	TX_DESC_QSEL_TID10	= 10,
+	TX_DESC_QSEL_TID11	= 11,
+	TX_DESC_QSEL_TID12	= 12,
+	TX_DESC_QSEL_TID13	= 13,
+	TX_DESC_QSEL_TID14	= 14,
+	TX_DESC_QSEL_TID15	= 15,
+	TX_DESC_QSEL_BEACON	= 16,
+	TX_DESC_QSEL_HIGH	= 17,
+	TX_DESC_QSEL_MGMT	= 18,
+	TX_DESC_QSEL_H2C	= 19,
+};
+
+void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
+			    struct rtw_tx_pkt_info *pkt_info,
+			    struct ieee80211_tx_control *control,
+			    struct sk_buff *skb);
+void rtw_tx_fill_tx_desc(struct rtw_tx_pkt_info *pkt_info, struct sk_buff *skb);
+void rtw_rsvd_page_pkt_info_update(struct rtw_dev *rtwdev,
+				   struct rtw_tx_pkt_info *pkt_info,
+				   struct sk_buff *skb);
+
+#endif
-- 
2.7.4

