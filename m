Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92170C282D2
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 05:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37CEB20870
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 05:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfA1Frb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 00:47:31 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:48713 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfA1Fr3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 00:47:29 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0S5ktU2011740, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0S5ktU2011740
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Mon, 28 Jan 2019 13:46:55 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Mon, 28 Jan 2019 13:46:55 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <pkshih@realtek.com>,
        <tehuang@realtek.com>, <briannorris@chromium.org>,
        <sgruszka@redhat.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 01/13] rtw88: main files
Date:   Mon, 28 Jan 2019 13:46:35 +0800
Message-ID: <1548654407-28469-2-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.143]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

main files for Realtek 802.11ac wireless network chips

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c |  480 ++++++++++
 drivers/net/wireless/realtek/rtw88/main.c     | 1190 +++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/main.h     | 1119 +++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/reg.h      |  411 +++++++++
 4 files changed, 3200 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/mac80211.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/main.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/main.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/reg.h

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
new file mode 100644
index 0000000..17b3651
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -0,0 +1,480 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "sec.h"
+#include "tx.h"
+#include "fw.h"
+#include "mac.h"
+#include "ps.h"
+#include "reg.h"
+#include "debug.h"
+
+static void rtw_ops_tx(struct ieee80211_hw *hw,
+		       struct ieee80211_tx_control *control,
+		       struct sk_buff *skb)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+	struct rtw_tx_pkt_info pkt_info = {0};
+
+	if (!rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
+		goto out;
+
+	rtw_tx_pkt_info_update(rtwdev, &pkt_info, control, skb);
+	if (rtw_hci_tx(rtwdev, &pkt_info, skb))
+		goto out;
+
+	return;
+
+out:
+	ieee80211_free_txskb(hw, skb);
+}
+
+static int rtw_ops_start(struct ieee80211_hw *hw)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+	int ret;
+
+	mutex_lock(&rtwdev->mutex);
+	ret = rtw_core_start(rtwdev);
+	mutex_unlock(&rtwdev->mutex);
+
+	return ret;
+}
+
+static void rtw_ops_stop(struct ieee80211_hw *hw)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+
+	mutex_lock(&rtwdev->mutex);
+	rtw_core_stop(rtwdev);
+	mutex_unlock(&rtwdev->mutex);
+}
+
+static int rtw_ops_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+	int ret = 0;
+
+	mutex_lock(&rtwdev->mutex);
+
+	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+		if (hw->conf.flags & IEEE80211_CONF_IDLE) {
+			rtw_enter_ips(rtwdev);
+		} else {
+			ret = rtw_leave_ips(rtwdev);
+			if (ret) {
+				rtw_err(rtwdev, "failed to leave idle state\n");
+				goto out;
+			}
+		}
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
+		rtw_set_channel(rtwdev);
+
+out:
+	mutex_unlock(&rtwdev->mutex);
+	return ret;
+}
+
+static const struct rtw_vif_port rtw_vif_port[] = {
+	[0] = {
+		.mac_addr	= {.addr = 0x0610},
+		.bssid		= {.addr = 0x0618},
+		.net_type	= {.addr = 0x0100, .mask = 0x30000},
+		.aid		= {.addr = 0x06a8, .mask = 0x7ff},
+	},
+	[1] = {
+		.mac_addr	= {.addr = 0x0700},
+		.bssid		= {.addr = 0x0708},
+		.net_type	= {.addr = 0x0100, .mask = 0xc0000},
+		.aid		= {.addr = 0x0710, .mask = 0x7ff},
+	},
+	[2] = {
+		.mac_addr	= {.addr = 0x1620},
+		.bssid		= {.addr = 0x1628},
+		.net_type	= {.addr = 0x1100, .mask = 0x3},
+		.aid		= {.addr = 0x1600, .mask = 0x7ff},
+	},
+	[3] = {
+		.mac_addr	= {.addr = 0x1630},
+		.bssid		= {.addr = 0x1638},
+		.net_type	= {.addr = 0x1100, .mask = 0xc},
+		.aid		= {.addr = 0x1604, .mask = 0x7ff},
+	},
+	[4] = {
+		.mac_addr	= {.addr = 0x1640},
+		.bssid		= {.addr = 0x1648},
+		.net_type	= {.addr = 0x1100, .mask = 0x30},
+		.aid		= {.addr = 0x1608, .mask = 0x7ff},
+	},
+};
+
+static int rtw_ops_add_interface(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
+	enum rtw_net_type net_type;
+	u32 config = 0;
+	u8 port = 0;
+
+	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
+	rtwvif->port = port;
+	rtwvif->vif = vif;
+	rtwvif->stats.tx_unicast = 0;
+	rtwvif->stats.rx_unicast = 0;
+	rtwvif->stats.tx_cnt = 0;
+	rtwvif->stats.rx_cnt = 0;
+	rtwvif->in_lps = false;
+	rtwvif->conf = &rtw_vif_port[port];
+
+	mutex_lock(&rtwdev->mutex);
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
+		net_type = RTW_NET_AP_MODE;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		net_type = RTW_NET_AD_HOC;
+		break;
+	case NL80211_IFTYPE_STATION:
+	default:
+		net_type = RTW_NET_NO_LINK;
+		break;
+	}
+
+	ether_addr_copy(rtwvif->mac_addr, vif->addr);
+	config |= PORT_SET_MAC_ADDR;
+	rtwvif->net_type = net_type;
+	config |= PORT_SET_NET_TYPE;
+	rtw_vif_port_config(rtwdev, rtwvif, config);
+
+	mutex_unlock(&rtwdev->mutex);
+
+	rtw_info(rtwdev, "start vif %pM on port %d\n", vif->addr, rtwvif->port);
+	return 0;
+}
+
+static void rtw_ops_remove_interface(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
+	u32 config = 0;
+
+	rtw_info(rtwdev, "stop vif %pM on port %d\n", vif->addr, rtwvif->port);
+
+	mutex_lock(&rtwdev->mutex);
+
+	eth_zero_addr(rtwvif->mac_addr);
+	config |= PORT_SET_MAC_ADDR;
+	rtwvif->net_type = RTW_NET_NO_LINK;
+	config |= PORT_SET_NET_TYPE;
+	rtw_vif_port_config(rtwdev, rtwvif, config);
+
+	mutex_unlock(&rtwdev->mutex);
+}
+
+static void rtw_ops_configure_filter(struct ieee80211_hw *hw,
+				     unsigned int changed_flags,
+				     unsigned int *new_flags,
+				     u64 multicast)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+
+	*new_flags &= FIF_ALLMULTI | FIF_OTHER_BSS | FIF_FCSFAIL |
+		      FIF_BCN_PRBRESP_PROMISC;
+
+	mutex_lock(&rtwdev->mutex);
+
+	if (changed_flags & FIF_ALLMULTI) {
+		if (*new_flags & FIF_ALLMULTI)
+			rtwdev->hal.rcr |= BIT_AM | BIT_AB;
+		else
+			rtwdev->hal.rcr &= ~(BIT_AM | BIT_AB);
+	}
+	if (changed_flags & FIF_FCSFAIL) {
+		if (*new_flags & FIF_FCSFAIL)
+			rtwdev->hal.rcr |= BIT_ACRC32;
+		else
+			rtwdev->hal.rcr &= ~(BIT_ACRC32);
+	}
+	if (changed_flags & FIF_OTHER_BSS) {
+		if (*new_flags & FIF_OTHER_BSS)
+			rtwdev->hal.rcr |= BIT_AAP;
+		else
+			rtwdev->hal.rcr &= ~(BIT_AAP);
+	}
+	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
+		if (*new_flags & FIF_BCN_PRBRESP_PROMISC)
+			rtwdev->hal.rcr &= ~(BIT_CBSSID_BCN | BIT_CBSSID_DATA);
+		else
+			rtwdev->hal.rcr |= BIT_CBSSID_BCN;
+	}
+
+	rtw_dbg(rtwdev, "config rx filter, changed=0x%08x, new=0x%08x, rcr=0x%08x\n",
+		changed_flags, *new_flags, rtwdev->hal.rcr);
+
+	rtw_write32(rtwdev, REG_RCR, rtwdev->hal.rcr);
+
+	mutex_unlock(&rtwdev->mutex);
+}
+
+static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_bss_conf *conf,
+				     u32 changed)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
+	u32 config = 0;
+
+	mutex_lock(&rtwdev->mutex);
+
+	if (changed & BSS_CHANGED_ASSOC) {
+		struct rtw_chip_info *chip = rtwdev->chip;
+		enum rtw_net_type net_type;
+
+		if (conf->assoc) {
+			net_type = RTW_NET_MGD_LINKED;
+			chip->ops->do_iqk(rtwdev);
+
+			rtwvif->aid = conf->aid;
+			rtw_add_rsvd_page(rtwdev, RSVD_PS_POLL, true);
+			rtw_add_rsvd_page(rtwdev, RSVD_QOS_NULL, true);
+			rtw_add_rsvd_page(rtwdev, RSVD_NULL, true);
+			rtw_fw_download_rsvd_page(rtwdev, vif);
+		} else {
+			net_type = RTW_NET_NO_LINK;
+			rtwvif->aid = 0;
+			rtw_reset_rsvd_page(rtwdev);
+		}
+
+		rtwvif->net_type = net_type;
+		config |= PORT_SET_NET_TYPE;
+		config |= PORT_SET_AID;
+	}
+
+	if (changed & BSS_CHANGED_BSSID) {
+		ether_addr_copy(rtwvif->bssid, conf->bssid);
+		config |= PORT_SET_BSSID;
+	}
+
+	if (changed & BSS_CHANGED_BEACON)
+		rtw_fw_download_rsvd_page(rtwdev, vif);
+
+	rtw_vif_port_config(rtwdev, rtwvif, config);
+
+	mutex_unlock(&rtwdev->mutex);
+}
+
+static u8 rtw_acquire_macid(struct rtw_dev *rtwdev)
+{
+	unsigned long mac_id;
+
+	mac_id = find_first_zero_bit(rtwdev->mac_id_map, RTW_MAX_MAC_ID_NUM);
+	if (mac_id < RTW_MAX_MAC_ID_NUM)
+		set_bit(mac_id, rtwdev->mac_id_map);
+
+	return mac_id;
+}
+
+static void rtw_release_macid(struct rtw_dev *rtwdev, u8 mac_id)
+{
+	clear_bit(mac_id, rtwdev->mac_id_map);
+}
+
+static int rtw_ops_sta_add(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+	struct rtw_sta_info *si = (struct rtw_sta_info *)sta->drv_priv;
+	int ret = 0;
+
+	mutex_lock(&rtwdev->mutex);
+
+	si->mac_id = rtw_acquire_macid(rtwdev);
+	if (si->mac_id >= RTW_MAX_MAC_ID_NUM) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	si->sta = sta;
+	si->vif = vif;
+	si->init_ra_lv = 1;
+	ewma_rssi_init(&si->avg_rssi);
+
+	rtw_update_sta_info(rtwdev, si);
+	rtw_fw_media_status_report(rtwdev, si->mac_id, true);
+
+	rtwdev->sta_cnt++;
+
+	rtw_info(rtwdev, "sta %pM joined with macid %d\n",
+		 sta->addr, si->mac_id);
+
+out:
+	mutex_unlock(&rtwdev->mutex);
+	return ret;
+}
+
+static int rtw_ops_sta_remove(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+	struct rtw_sta_info *si = (struct rtw_sta_info *)sta->drv_priv;
+
+	mutex_lock(&rtwdev->mutex);
+
+	rtw_release_macid(rtwdev, si->mac_id);
+	rtw_fw_media_status_report(rtwdev, si->mac_id, false);
+
+	rtwdev->sta_cnt--;
+
+	rtw_info(rtwdev, "sta %pM with macid %d left\n",
+		 sta->addr, si->mac_id);
+
+	mutex_unlock(&rtwdev->mutex);
+	return 0;
+}
+
+static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+			   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+			   struct ieee80211_key_conf *key)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+	struct rtw_sec_desc *sec = &rtwdev->sec;
+	u8 hw_key_type;
+	u8 hw_key_idx;
+	int ret = 0;
+
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+		hw_key_type = RTW_CAM_WEP40;
+		break;
+	case WLAN_CIPHER_SUITE_WEP104:
+		hw_key_type = RTW_CAM_WEP104;
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		hw_key_type = RTW_CAM_TKIP;
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		hw_key_type = RTW_CAM_AES;
+		key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
+		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		/* suppress error messages */
+		return -EOPNOTSUPP;
+	default:
+		return -ENOTSUPP;
+	}
+
+	mutex_lock(&rtwdev->mutex);
+
+	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
+		hw_key_idx = rtw_sec_get_free_cam(sec);
+	} else {
+		/* multiple interfaces? */
+		hw_key_idx = key->keyidx;
+	}
+
+	if (hw_key_idx > sec->total_cam_num) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	switch (cmd) {
+	case SET_KEY:
+		/* need sw generated IV */
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		key->hw_key_idx = hw_key_idx;
+		rtw_sec_write_cam(rtwdev, sec, sta, key,
+				  hw_key_type, hw_key_idx);
+		break;
+	case DISABLE_KEY:
+		rtw_sec_clear_cam(rtwdev, sec, key->hw_key_idx);
+		break;
+	}
+
+out:
+	mutex_unlock(&rtwdev->mutex);
+
+	return ret;
+}
+
+static int rtw_ops_ampdu_action(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_ampdu_params *params)
+{
+	struct ieee80211_sta *sta = params->sta;
+	u16 tid = params->tid;
+
+	switch (params->action) {
+	case IEEE80211_AMPDU_TX_START:
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+	case IEEE80211_AMPDU_RX_START:
+	case IEEE80211_AMPDU_RX_STOP:
+		break;
+	default:
+		WARN_ON(1);
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static void rtw_ops_sw_scan_start(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  const u8 *mac_addr)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
+
+	rtw_leave_lps(rtwdev, rtwvif);
+
+	rtw_flag_set(rtwdev, RTW_FLAG_DIG_DISABLE);
+	rtw_flag_set(rtwdev, RTW_FLAG_SCANNING);
+}
+
+static void rtw_ops_sw_scan_complete(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+
+	rtw_flag_clear(rtwdev, RTW_FLAG_SCANNING);
+	rtw_flag_clear(rtwdev, RTW_FLAG_DIG_DISABLE);
+}
+
+const struct ieee80211_ops rtw_ops = {
+	.tx			= rtw_ops_tx,
+	.start			= rtw_ops_start,
+	.stop			= rtw_ops_stop,
+	.config			= rtw_ops_config,
+	.add_interface		= rtw_ops_add_interface,
+	.remove_interface	= rtw_ops_remove_interface,
+	.configure_filter	= rtw_ops_configure_filter,
+	.bss_info_changed	= rtw_ops_bss_info_changed,
+	.sta_add		= rtw_ops_sta_add,
+	.sta_remove		= rtw_ops_sta_remove,
+	.set_key		= rtw_ops_set_key,
+	.ampdu_action		= rtw_ops_ampdu_action,
+	.sw_scan_start		= rtw_ops_sw_scan_start,
+	.sw_scan_complete	= rtw_ops_sw_scan_complete,
+};
+EXPORT_SYMBOL(rtw_ops);
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
new file mode 100644
index 0000000..a189c45
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -0,0 +1,1190 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "regd.h"
+#include "fw.h"
+#include "ps.h"
+#include "sec.h"
+#include "mac.h"
+#include "phy.h"
+#include "reg.h"
+#include "efuse.h"
+#include "debug.h"
+
+static struct ieee80211_channel rtw_channeltable_2g[] = {
+	{.center_freq = 2412, .hw_value = 1,},
+	{.center_freq = 2417, .hw_value = 2,},
+	{.center_freq = 2422, .hw_value = 3,},
+	{.center_freq = 2427, .hw_value = 4,},
+	{.center_freq = 2432, .hw_value = 5,},
+	{.center_freq = 2437, .hw_value = 6,},
+	{.center_freq = 2442, .hw_value = 7,},
+	{.center_freq = 2447, .hw_value = 8,},
+	{.center_freq = 2452, .hw_value = 9,},
+	{.center_freq = 2457, .hw_value = 10,},
+	{.center_freq = 2462, .hw_value = 11,},
+	{.center_freq = 2467, .hw_value = 12,},
+	{.center_freq = 2472, .hw_value = 13,},
+	{.center_freq = 2484, .hw_value = 14,},
+};
+
+static struct ieee80211_channel rtw_channeltable_5g[] = {
+	{.center_freq = 5180, .hw_value = 36,},
+	{.center_freq = 5200, .hw_value = 40,},
+	{.center_freq = 5220, .hw_value = 44,},
+	{.center_freq = 5240, .hw_value = 48,},
+	{.center_freq = 5260, .hw_value = 52,},
+	{.center_freq = 5280, .hw_value = 56,},
+	{.center_freq = 5300, .hw_value = 60,},
+	{.center_freq = 5320, .hw_value = 64,},
+	{.center_freq = 5500, .hw_value = 100,},
+	{.center_freq = 5520, .hw_value = 104,},
+	{.center_freq = 5540, .hw_value = 108,},
+	{.center_freq = 5560, .hw_value = 112,},
+	{.center_freq = 5580, .hw_value = 116,},
+	{.center_freq = 5600, .hw_value = 120,},
+	{.center_freq = 5620, .hw_value = 124,},
+	{.center_freq = 5640, .hw_value = 128,},
+	{.center_freq = 5660, .hw_value = 132,},
+	{.center_freq = 5680, .hw_value = 136,},
+	{.center_freq = 5700, .hw_value = 140,},
+	{.center_freq = 5745, .hw_value = 149,},
+	{.center_freq = 5765, .hw_value = 153,},
+	{.center_freq = 5785, .hw_value = 157,},
+	{.center_freq = 5805, .hw_value = 161,},
+	{.center_freq = 5825, .hw_value = 165,
+	 .flags = IEEE80211_CHAN_NO_HT40MINUS},
+};
+
+static struct ieee80211_rate rtw_ratetable[] = {
+	{.bitrate = 10, .hw_value = 0x00,},
+	{.bitrate = 20, .hw_value = 0x01,},
+	{.bitrate = 55, .hw_value = 0x02,},
+	{.bitrate = 110, .hw_value = 0x03,},
+	{.bitrate = 60, .hw_value = 0x04,},
+	{.bitrate = 90, .hw_value = 0x05,},
+	{.bitrate = 120, .hw_value = 0x06,},
+	{.bitrate = 180, .hw_value = 0x07,},
+	{.bitrate = 240, .hw_value = 0x08,},
+	{.bitrate = 360, .hw_value = 0x09,},
+	{.bitrate = 480, .hw_value = 0x0a,},
+	{.bitrate = 540, .hw_value = 0x0b,},
+};
+
+static struct ieee80211_supported_band rtw_band_2ghz = {
+	.band = NL80211_BAND_2GHZ,
+
+	.channels = rtw_channeltable_2g,
+	.n_channels = ARRAY_SIZE(rtw_channeltable_2g),
+
+	.bitrates = rtw_ratetable,
+	.n_bitrates = ARRAY_SIZE(rtw_ratetable),
+
+	.ht_cap = {0},
+	.vht_cap = {0},
+};
+
+static struct ieee80211_supported_band rtw_band_5ghz = {
+	.band = NL80211_BAND_5GHZ,
+
+	.channels = rtw_channeltable_5g,
+	.n_channels = ARRAY_SIZE(rtw_channeltable_5g),
+
+	/* 5G has no CCK rates */
+	.bitrates = rtw_ratetable + 4,
+	.n_bitrates = ARRAY_SIZE(rtw_ratetable) - 4,
+
+	.ht_cap = {0},
+	.vht_cap = {0},
+};
+
+struct rtw_watch_dog_iter_data {
+	struct rtw_vif *rtwvif;
+	bool active;
+	u8 assoc_cnt;
+};
+
+static void rtw_vif_watch_dog_iter(void *data, u8 *mac,
+				   struct ieee80211_vif *vif)
+{
+	struct rtw_watch_dog_iter_data *iter_data = data;
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
+
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		if (vif->bss_conf.assoc) {
+			iter_data->assoc_cnt++;
+			iter_data->rtwvif = rtwvif;
+		}
+		if (rtwvif->stats.tx_cnt > RTW_LPS_THRESHOLD ||
+		    rtwvif->stats.rx_cnt > RTW_LPS_THRESHOLD)
+			iter_data->active = true;
+	} else {
+		/* only STATION mode can enter lps */
+		iter_data->active = true;
+	}
+
+	rtwvif->stats.tx_unicast = 0;
+	rtwvif->stats.rx_unicast = 0;
+	rtwvif->stats.tx_cnt = 0;
+	rtwvif->stats.rx_cnt = 0;
+}
+
+/* process TX/RX statistics periodically for hardware,
+ * the information helps hardware to enhance performance
+ */
+static void rtw_watch_dog_work(struct work_struct *work)
+{
+	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
+					      watch_dog_work.work);
+	struct rtw_watch_dog_iter_data data = {};
+
+	if (!rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
+		return;
+
+	ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->watch_dog_work,
+				     RTW_WATCH_DOG_DELAY_TIME);
+
+	/* reset tx/rx statictics */
+	rtwdev->stats.tx_unicast = 0;
+	rtwdev->stats.rx_unicast = 0;
+	rtwdev->stats.tx_cnt = 0;
+	rtwdev->stats.rx_cnt = 0;
+
+	rtw_iterate_vifs(rtwdev, rtw_vif_watch_dog_iter, &data);
+
+	/* fw supports only one station associated to enter lps, if there are
+	 * more than two stations associated to the AP, then we can not enter
+	 * lps, because fw does not handle the overlapped beacon interval
+	 */
+	if (data.rtwvif && !data.active && data.assoc_cnt == 1)
+		rtw_enter_lps(rtwdev, data.rtwvif);
+
+	if (rtw_flag_check(rtwdev, RTW_FLAG_SCANNING))
+		return;
+
+	rtw_phy_dynamic_mechanism(rtwdev);
+
+	rtwdev->watch_dog_cnt++;
+}
+
+static void rtw_c2h_work(struct work_struct *work)
+{
+	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev, c2h_work);
+	struct sk_buff *skb, *tmp;
+
+	skb_queue_walk_safe(&rtwdev->c2h_queue, skb, tmp) {
+		skb_unlink(skb, &rtwdev->c2h_queue);
+		rtw_fw_c2h_cmd_handle(rtwdev, skb);
+		dev_kfree_skb_any(skb);
+	}
+}
+
+void rtw_get_channel_params(struct cfg80211_chan_def *chandef,
+			    struct rtw_channel_params *chan_params)
+{
+	struct ieee80211_channel *channel = chandef->chan;
+	enum nl80211_chan_width width = chandef->width;
+	u32 primary_freq, center_freq;
+	u8 center_chan;
+	u8 bandwidth = RTW_CHANNEL_WIDTH_20;
+	u8 primary_chan_idx = 0;
+
+	center_chan = channel->hw_value;
+	primary_freq = channel->center_freq;
+	center_freq = chandef->center_freq1;
+
+	switch (width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+		bandwidth = RTW_CHANNEL_WIDTH_20;
+		primary_chan_idx = 0;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		bandwidth = RTW_CHANNEL_WIDTH_40;
+		if (primary_freq > center_freq) {
+			primary_chan_idx = 1;
+			center_chan -= 2;
+		} else {
+			primary_chan_idx = 2;
+			center_chan += 2;
+		}
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		bandwidth = RTW_CHANNEL_WIDTH_80;
+		if (primary_freq > center_freq) {
+			if (primary_freq - center_freq == 10) {
+				primary_chan_idx = 1;
+				center_chan -= 2;
+			} else {
+				primary_chan_idx = 3;
+				center_chan -= 6;
+			}
+		} else {
+			if (center_freq - primary_freq == 10) {
+				primary_chan_idx = 2;
+				center_chan += 2;
+			} else {
+				primary_chan_idx = 4;
+				center_chan += 6;
+			}
+		}
+		break;
+	default:
+		center_chan = 0;
+		break;
+	}
+
+	chan_params->center_chan = center_chan;
+	chan_params->bandwidth = bandwidth;
+	chan_params->primary_chan_idx = primary_chan_idx;
+}
+
+void rtw_set_channel(struct rtw_dev *rtwdev)
+{
+	struct ieee80211_hw *hw = rtwdev->hw;
+	struct rtw_hal *hal = &rtwdev->hal;
+	struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_channel_params ch_param;
+	u8 center_chan, bandwidth, primary_chan_idx;
+
+	rtw_get_channel_params(&hw->conf.chandef, &ch_param);
+	if (WARN(ch_param.center_chan == 0, "Invalid channel\n"))
+		return;
+
+	center_chan = ch_param.center_chan;
+	bandwidth = ch_param.bandwidth;
+	primary_chan_idx = ch_param.primary_chan_idx;
+
+	hal->current_band_width = bandwidth;
+	hal->current_channel = center_chan;
+	hal->current_band_type = center_chan > 14 ? RTW_BAND_5G : RTW_BAND_2G;
+	chip->ops->set_channel(rtwdev, center_chan, bandwidth, primary_chan_idx);
+
+	rtw_phy_set_tx_power_level(rtwdev, center_chan);
+}
+
+static void rtw_vif_write_addr(struct rtw_dev *rtwdev, u32 start, u8 *addr)
+{
+	int i;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		rtw_write8(rtwdev, start + i, addr[i]);
+}
+
+void rtw_vif_port_config(struct rtw_dev *rtwdev,
+			 struct rtw_vif *rtwvif,
+			 u32 config)
+{
+	u32 addr, mask;
+
+	if (config & PORT_SET_MAC_ADDR) {
+		addr = rtwvif->conf->mac_addr.addr;
+		rtw_vif_write_addr(rtwdev, addr, rtwvif->mac_addr);
+	}
+	if (config & PORT_SET_BSSID) {
+		addr = rtwvif->conf->bssid.addr;
+		rtw_vif_write_addr(rtwdev, addr, rtwvif->bssid);
+	}
+	if (config & PORT_SET_NET_TYPE) {
+		addr = rtwvif->conf->net_type.addr;
+		mask = rtwvif->conf->net_type.mask;
+		rtw_write32_mask(rtwdev, addr, mask, rtwvif->net_type);
+	}
+	if (config & PORT_SET_AID) {
+		addr = rtwvif->conf->aid.addr;
+		mask = rtwvif->conf->aid.mask;
+		rtw_write32_mask(rtwdev, addr, mask, rtwvif->aid);
+	}
+}
+
+static u8 hw_bw_cap_to_bitamp(u8 bw_cap)
+{
+	u8 bw = 0;
+
+	switch (bw_cap) {
+	case EFUSE_HW_CAP_IGNORE:
+	case EFUSE_HW_CAP_SUPP_BW80:
+		bw |= BIT(RTW_CHANNEL_WIDTH_80);
+		/* fall through */
+	case EFUSE_HW_CAP_SUPP_BW40:
+		bw |= BIT(RTW_CHANNEL_WIDTH_40);
+		/* fall through */
+	default:
+		bw |= BIT(RTW_CHANNEL_WIDTH_20);
+		break;
+	}
+
+	return bw;
+}
+
+static void rtw_hw_config_rf_ant_num(struct rtw_dev *rtwdev, u8 hw_ant_num)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+
+	if (hw_ant_num == EFUSE_HW_CAP_IGNORE ||
+	    hw_ant_num >= hal->rf_path_num)
+		return;
+
+	switch (hw_ant_num) {
+	case 1:
+		hal->rf_type = RF_1T1R;
+		hal->rf_path_num = 1;
+		hal->antenna_tx = BB_PATH_A;
+		hal->antenna_rx = BB_PATH_A;
+		break;
+	default:
+		WARN(1, "invalid hw configuration from efuse\n");
+		break;
+	}
+}
+
+static u64 get_vht_ra_mask(struct ieee80211_sta *sta)
+{
+	u64 ra_mask = 0;
+	u16 mcs_map = le16_to_cpu(sta->vht_cap.vht_mcs.rx_mcs_map);
+	u8 vht_mcs_cap;
+	int i, nss;
+
+	/* 4SS, every two bits for MCS7/8/9 */
+	for (i = 0, nss = 12; i < 4; i++, mcs_map >>= 2, nss += 10) {
+		vht_mcs_cap = mcs_map & 0x3;
+		switch (vht_mcs_cap) {
+		case 2: /* MCS9 */
+			ra_mask |= 0x3ff << nss;
+			break;
+		case 1: /* MCS8 */
+			ra_mask |= 0x1ff << nss;
+			break;
+		case 0: /* MCS7 */
+			ra_mask |= 0x0ff << nss;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return ra_mask;
+}
+
+static u8 get_rate_id(u8 wireless_set, enum rtw_bandwidth bw_mode, u8 tx_num)
+{
+	u8 rate_id = 0;
+
+	switch (wireless_set) {
+	case WIRELESS_CCK:
+		rate_id = RTW_RATEID_B_20M;
+		break;
+	case WIRELESS_OFDM:
+		rate_id = RTW_RATEID_G;
+		break;
+	case WIRELESS_CCK | WIRELESS_OFDM:
+		rate_id = RTW_RATEID_BG;
+		break;
+	case WIRELESS_OFDM | WIRELESS_HT:
+		if (tx_num == 1)
+			rate_id = RTW_RATEID_GN_N1SS;
+		else if (tx_num == 2)
+			rate_id = RTW_RATEID_GN_N2SS;
+		else if (tx_num == 3)
+			rate_id = RTW_RATEID_ARFR5_N_3SS;
+		break;
+	case WIRELESS_CCK | WIRELESS_OFDM | WIRELESS_HT:
+		if (bw_mode == RTW_CHANNEL_WIDTH_40) {
+			if (tx_num == 1)
+				rate_id = RTW_RATEID_BGN_40M_1SS;
+			else if (tx_num == 2)
+				rate_id = RTW_RATEID_BGN_40M_2SS;
+			else if (tx_num == 3)
+				rate_id = RTW_RATEID_ARFR5_N_3SS;
+			else if (tx_num == 4)
+				rate_id = RTW_RATEID_ARFR7_N_4SS;
+		} else {
+			if (tx_num == 1)
+				rate_id = RTW_RATEID_BGN_20M_1SS;
+			else if (tx_num == 2)
+				rate_id = RTW_RATEID_BGN_20M_2SS;
+			else if (tx_num == 3)
+				rate_id = RTW_RATEID_ARFR5_N_3SS;
+			else if (tx_num == 4)
+				rate_id = RTW_RATEID_ARFR7_N_4SS;
+		}
+		break;
+	case WIRELESS_OFDM | WIRELESS_VHT:
+		if (tx_num == 1)
+			rate_id = RTW_RATEID_ARFR1_AC_1SS;
+		else if (tx_num == 2)
+			rate_id = RTW_RATEID_ARFR0_AC_2SS;
+		else if (tx_num == 3)
+			rate_id = RTW_RATEID_ARFR4_AC_3SS;
+		else if (tx_num == 4)
+			rate_id = RTW_RATEID_ARFR6_AC_4SS;
+		break;
+	case WIRELESS_CCK | WIRELESS_OFDM | WIRELESS_VHT:
+		if (bw_mode >= RTW_CHANNEL_WIDTH_80) {
+			if (tx_num == 1)
+				rate_id = RTW_RATEID_ARFR1_AC_1SS;
+			else if (tx_num == 2)
+				rate_id = RTW_RATEID_ARFR0_AC_2SS;
+			else if (tx_num == 3)
+				rate_id = RTW_RATEID_ARFR4_AC_3SS;
+			else if (tx_num == 4)
+				rate_id = RTW_RATEID_ARFR6_AC_4SS;
+		} else {
+			if (tx_num == 1)
+				rate_id = RTW_RATEID_ARFR2_AC_2G_1SS;
+			else if (tx_num == 2)
+				rate_id = RTW_RATEID_ARFR3_AC_2G_2SS;
+			else if (tx_num == 3)
+				rate_id = RTW_RATEID_ARFR4_AC_3SS;
+			else if (tx_num == 4)
+				rate_id = RTW_RATEID_ARFR6_AC_4SS;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return rate_id;
+}
+
+#define RA_MASK_CCK_RATES	0x0000f
+#define RA_MASK_OFDM_RATES	0x00ff0
+#define RA_MASK_HT_RATES_1SS	(0xff000 << 0)
+#define RA_MASK_HT_RATES_2SS	(0xff000 << 8)
+#define RA_MASK_HT_RATES_3SS	(0xff000 << 16)
+#define RA_MASK_HT_RATES	(RA_MASK_HT_RATES_1SS | \
+				 RA_MASK_HT_RATES_2SS | \
+				 RA_MASK_HT_RATES_3SS)
+#define RA_MASK_VHT_RATES_1SS	(0x3ff000 << 0)
+#define RA_MASK_VHT_RATES_2SS	(0x3ff000 << 10)
+#define RA_MASK_VHT_RATES_3SS	(0x3ff000 << 20)
+#define RA_MASK_VHT_RATES	(RA_MASK_VHT_RATES_1SS | \
+				 RA_MASK_VHT_RATES_2SS | \
+				 RA_MASK_VHT_RATES_3SS)
+#define RA_MASK_CCK_IN_HT	0x00005
+#define RA_MASK_CCK_IN_VHT	0x00005
+#define RA_MASK_OFDM_IN_VHT	0x00010
+#define RA_MASK_OFDM_IN_HT_2G	0x00010
+#define RA_MASK_OFDM_IN_HT_5G	0x00030
+
+void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
+{
+	struct ieee80211_sta *sta = si->sta;
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	struct rtw_hal *hal = &rtwdev->hal;
+	u8 rssi_level;
+	u8 wireless_set;
+	u8 bw_mode;
+	u8 rate_id;
+	u8 rf_type = RF_1T1R;
+	u8 stbc_en = 0;
+	u8 ldpc_en = 0;
+	u8 tx_num = 1;
+	u64 ra_mask = 0;
+	bool is_vht_enable = false;
+	bool is_support_sgi = false;
+
+	if (sta->vht_cap.vht_supported) {
+		is_vht_enable = true;
+		ra_mask |= get_vht_ra_mask(sta);
+		if (sta->vht_cap.cap & IEEE80211_VHT_CAP_RXSTBC_MASK)
+			stbc_en = VHT_STBC_EN;
+		if (sta->vht_cap.cap & IEEE80211_VHT_CAP_RXLDPC)
+			ldpc_en = VHT_LDPC_EN;
+		if (sta->vht_cap.cap & IEEE80211_VHT_CAP_SHORT_GI_80)
+			is_support_sgi = true;
+	} else if (sta->ht_cap.ht_supported) {
+		ra_mask |= (sta->ht_cap.mcs.rx_mask[NL80211_BAND_5GHZ] << 20) |
+			   (sta->ht_cap.mcs.rx_mask[NL80211_BAND_2GHZ] << 12);
+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_RX_STBC)
+			stbc_en = HT_STBC_EN;
+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING)
+			ldpc_en = HT_LDPC_EN;
+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20 ||
+		    sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)
+			is_support_sgi = true;
+	}
+
+	if (hal->current_band_type == RTW_BAND_5G) {
+		ra_mask |= (u64)sta->supp_rates[NL80211_BAND_5GHZ] << 4;
+		if (sta->vht_cap.vht_supported) {
+			ra_mask &= RA_MASK_VHT_RATES | RA_MASK_OFDM_IN_VHT;
+			wireless_set = WIRELESS_OFDM | WIRELESS_VHT;
+		} else if (sta->ht_cap.ht_supported) {
+			ra_mask &= RA_MASK_HT_RATES | RA_MASK_OFDM_IN_HT_5G;
+			wireless_set = WIRELESS_OFDM | WIRELESS_HT;
+		} else {
+			wireless_set = WIRELESS_OFDM;
+		}
+	} else if (hal->current_band_type == RTW_BAND_2G) {
+		ra_mask |= sta->supp_rates[NL80211_BAND_2GHZ];
+		if (sta->vht_cap.vht_supported) {
+			ra_mask &= RA_MASK_VHT_RATES | RA_MASK_CCK_IN_VHT |
+				   RA_MASK_OFDM_IN_VHT;
+			wireless_set = WIRELESS_CCK | WIRELESS_OFDM |
+				       WIRELESS_HT | WIRELESS_VHT;
+		} else if (sta->ht_cap.ht_supported) {
+			ra_mask &= RA_MASK_HT_RATES | RA_MASK_CCK_IN_HT |
+				   RA_MASK_OFDM_IN_HT_2G;
+			wireless_set = WIRELESS_CCK | WIRELESS_OFDM |
+				       WIRELESS_HT;
+		} else if (sta->supp_rates[0] <= 0xf) {
+			wireless_set = WIRELESS_CCK;
+		} else {
+			wireless_set = WIRELESS_CCK | WIRELESS_OFDM;
+		}
+	} else {
+		rtw_err(rtwdev, "Unknown band type\n");
+		wireless_set = 0;
+	}
+
+	if (efuse->hw_cap.nss == 1) {
+		ra_mask &= RA_MASK_VHT_RATES_1SS;
+		ra_mask &= RA_MASK_HT_RATES_1SS;
+	}
+
+	switch (sta->bandwidth) {
+	case IEEE80211_STA_RX_BW_80:
+		bw_mode = RTW_CHANNEL_WIDTH_80;
+		break;
+	case IEEE80211_STA_RX_BW_40:
+		bw_mode = RTW_CHANNEL_WIDTH_40;
+		break;
+	default:
+		bw_mode = RTW_CHANNEL_WIDTH_20;
+		break;
+	}
+
+	if (sta->vht_cap.vht_supported && ra_mask & 0xffc00000) {
+		tx_num = 2;
+		rf_type = RF_2T2R;
+	} else if (sta->ht_cap.ht_supported && ra_mask & 0xfff00000) {
+		tx_num = 2;
+		rf_type = RF_2T2R;
+	}
+
+	rate_id = get_rate_id(wireless_set, bw_mode, tx_num);
+
+	if (wireless_set != WIRELESS_CCK) {
+		rssi_level = si->rssi_level;
+		if (rssi_level == 0)
+			ra_mask &= 0xffffffffffffffffULL;
+		else if (rssi_level == 1)
+			ra_mask &= 0xfffffffffffffff0ULL;
+		else if (rssi_level == 2)
+			ra_mask &= 0xffffffffffffefe0ULL;
+		else if (rssi_level == 3)
+			ra_mask &= 0xffffffffffffcfc0ULL;
+		else if (rssi_level == 4)
+			ra_mask &= 0xffffffffffff8f80ULL;
+		else if (rssi_level >= 5)
+			ra_mask &= 0xffffffffffff0f00ULL;
+	}
+
+	si->bw_mode = bw_mode;
+	si->stbc_en = stbc_en;
+	si->ldpc_en = ldpc_en;
+	si->rf_type = rf_type;
+	si->wireless_set = wireless_set;
+	si->sgi_enable = is_support_sgi;
+	si->vht_enable = is_vht_enable;
+	si->ra_mask = ra_mask;
+	si->rate_id = rate_id;
+
+	rtw_fw_send_ra_info(rtwdev, si);
+}
+
+static int rtw_power_on(struct rtw_dev *rtwdev)
+{
+	struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_fw_state *fw = &rtwdev->fw;
+	int ret;
+
+	ret = rtw_hci_setup(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to setup hci\n");
+		goto err;
+	}
+
+	/* power on MAC before firmware downloaded */
+	ret = rtw_mac_power_on(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to power on mac\n");
+		goto err;
+	}
+
+	wait_for_completion(&fw->completion);
+	if (!fw->firmware) {
+		ret = -EINVAL;
+		rtw_err(rtwdev, "failed to load firmware\n");
+		goto err;
+	}
+
+	ret = rtw_download_firmware(rtwdev, fw->firmware->data,
+				    fw->firmware->size);
+	if (ret) {
+		rtw_err(rtwdev, "failed to download firmware\n");
+		goto err_off;
+	}
+
+	/* config mac after firmware downloaded */
+	ret = rtw_mac_init(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to configure mac\n");
+		goto err_off;
+	}
+
+	chip->ops->phy_set_param(rtwdev);
+
+	ret = rtw_hci_start(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to start hci\n");
+		goto err_off;
+	}
+
+	return 0;
+
+err_off:
+	rtw_mac_power_off(rtwdev);
+
+err:
+	return ret;
+}
+
+int rtw_core_start(struct rtw_dev *rtwdev)
+{
+	int ret;
+
+	ret = rtw_power_on(rtwdev);
+	if (ret)
+		return ret;
+
+	rtwdev->h2c.last_box_num = 0;
+
+	rtw_sec_enable_sec_engine(rtwdev);
+
+	/* rcr reset after powered on */
+	rtw_write32(rtwdev, REG_RCR, rtwdev->hal.rcr);
+
+	ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->watch_dog_work,
+				     RTW_WATCH_DOG_DELAY_TIME);
+
+	rtw_flag_set(rtwdev, RTW_FLAG_RUNNING);
+
+	return 0;
+}
+
+static void rtw_power_off(struct rtw_dev *rtwdev)
+{
+	rtwdev->hci.ops->stop(rtwdev);
+	rtw_mac_power_off(rtwdev);
+}
+
+void rtw_core_stop(struct rtw_dev *rtwdev)
+{
+	rtw_flag_clear(rtwdev, RTW_FLAG_RUNNING);
+	rtw_flag_clear(rtwdev, RTW_FLAG_FW_RUNNING);
+
+	cancel_delayed_work_sync(&rtwdev->watch_dog_work);
+
+	rtw_power_off(rtwdev);
+}
+
+static void rtw_init_ht_cap(struct rtw_dev *rtwdev,
+			    struct ieee80211_sta_ht_cap *ht_cap)
+{
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+
+	ht_cap->ht_supported = true;
+	ht_cap->cap = 0;
+	ht_cap->cap |= IEEE80211_HT_CAP_SGI_20 |
+			IEEE80211_HT_CAP_MAX_AMSDU |
+			IEEE80211_HT_CAP_LDPC_CODING |
+			(1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
+	if (efuse->hw_cap.bw & BIT(RTW_CHANNEL_WIDTH_40))
+		ht_cap->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+				IEEE80211_HT_CAP_DSSSCCK40 |
+				IEEE80211_HT_CAP_SGI_40;
+	ht_cap->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+	ht_cap->ampdu_density = IEEE80211_HT_MPDU_DENSITY_16;
+	ht_cap->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+	if (efuse->hw_cap.nss > 1) {
+		ht_cap->mcs.rx_mask[0] = 0xFF;
+		ht_cap->mcs.rx_mask[1] = 0xFF;
+		ht_cap->mcs.rx_mask[4] = 0x01;
+		ht_cap->mcs.rx_highest = cpu_to_le16(300);
+	} else {
+		ht_cap->mcs.rx_mask[0] = 0xFF;
+		ht_cap->mcs.rx_mask[1] = 0x00;
+		ht_cap->mcs.rx_mask[4] = 0x01;
+		ht_cap->mcs.rx_highest = cpu_to_le16(150);
+	}
+}
+
+static void rtw_init_vht_cap(struct rtw_dev *rtwdev,
+			     struct ieee80211_sta_vht_cap *vht_cap)
+{
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	u16 mcs_map;
+	__le16 highest;
+
+	if (efuse->hw_cap.ptcl != EFUSE_HW_CAP_IGNORE &&
+	    efuse->hw_cap.ptcl != EFUSE_HW_CAP_PTCL_VHT)
+		return;
+
+	vht_cap->vht_supported = true;
+	vht_cap->cap = IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
+		       IEEE80211_VHT_CAP_RXLDPC |
+		       IEEE80211_VHT_CAP_SHORT_GI_80 |
+		       IEEE80211_VHT_CAP_TXSTBC |
+		       IEEE80211_VHT_CAP_RXSTBC_1 |
+		       IEEE80211_VHT_CAP_HTC_VHT |
+		       IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK |
+		       0;
+	mcs_map = IEEE80211_VHT_MCS_SUPPORT_0_9 << 0 |
+		  IEEE80211_VHT_MCS_NOT_SUPPORTED << 4 |
+		  IEEE80211_VHT_MCS_NOT_SUPPORTED << 6 |
+		  IEEE80211_VHT_MCS_NOT_SUPPORTED << 8 |
+		  IEEE80211_VHT_MCS_NOT_SUPPORTED << 10 |
+		  IEEE80211_VHT_MCS_NOT_SUPPORTED << 12 |
+		  IEEE80211_VHT_MCS_NOT_SUPPORTED << 14;
+	if (efuse->hw_cap.nss > 1) {
+		highest = cpu_to_le16(780);
+		mcs_map |= IEEE80211_VHT_MCS_SUPPORT_0_9 << 2;
+	} else {
+		highest = cpu_to_le16(390);
+		mcs_map |= IEEE80211_VHT_MCS_NOT_SUPPORTED << 2;
+	}
+
+	vht_cap->vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
+	vht_cap->vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
+	vht_cap->vht_mcs.rx_highest = highest;
+	vht_cap->vht_mcs.tx_highest = highest;
+}
+
+static void rtw_set_supported_band(struct ieee80211_hw *hw,
+				   struct rtw_chip_info *chip)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+	struct ieee80211_supported_band *sband;
+
+	if (chip->band & RTW_BAND_2G) {
+		sband = kmemdup(&rtw_band_2ghz, sizeof(*sband), GFP_KERNEL);
+		if (!sband)
+			goto err_out;
+		if (chip->ht_supported)
+			rtw_init_ht_cap(rtwdev, &sband->ht_cap);
+		hw->wiphy->bands[NL80211_BAND_2GHZ] = sband;
+	}
+
+	if (chip->band & RTW_BAND_5G) {
+		sband = kmemdup(&rtw_band_5ghz, sizeof(*sband), GFP_KERNEL);
+		if (!sband)
+			goto err_out;
+		if (chip->ht_supported)
+			rtw_init_ht_cap(rtwdev, &sband->ht_cap);
+		if (chip->vht_supported)
+			rtw_init_vht_cap(rtwdev, &sband->vht_cap);
+		hw->wiphy->bands[NL80211_BAND_5GHZ] = sband;
+	}
+
+	return;
+
+err_out:
+	rtw_err(rtwdev, "failed to set supported band\n");
+	kfree(sband);
+	return;
+}
+
+static void rtw_unset_supported_band(struct ieee80211_hw *hw,
+				     struct rtw_chip_info *chip)
+{
+	kfree(hw->wiphy->bands[NL80211_BAND_2GHZ]);
+	kfree(hw->wiphy->bands[NL80211_BAND_5GHZ]);
+}
+
+static void rtw_load_firmware_cb(const struct firmware *firmware, void *context)
+{
+	struct rtw_dev *rtwdev = context;
+	struct rtw_fw_state *fw = &rtwdev->fw;
+
+	if (!firmware)
+		rtw_err(rtwdev, "failed to request firmware\n");
+
+	fw->firmware = firmware;
+	complete_all(&fw->completion);
+}
+
+static int rtw_load_firmware(struct rtw_dev *rtwdev, const char *fw_name)
+{
+	struct rtw_fw_state *fw = &rtwdev->fw;
+	int ret;
+
+	init_completion(&fw->completion);
+
+	ret = request_firmware_nowait(THIS_MODULE, true, fw_name, rtwdev->dev,
+				      GFP_KERNEL, rtwdev, rtw_load_firmware_cb);
+	if (ret) {
+		rtw_err(rtwdev, "async firmware request failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int rtw_chip_parameter_setup(struct rtw_dev *rtwdev)
+{
+	struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_hal *hal = &rtwdev->hal;
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	u32 wl_bt_pwr_ctrl;
+	int ret = 0;
+
+	switch (rtw_hci_type(rtwdev)) {
+	case RTW_HCI_TYPE_PCIE:
+		rtwdev->hci.rpwm_addr = 0x03d9;
+		break;
+	default:
+		rtw_err(rtwdev, "unsupported hci type\n");
+		return -EINVAL;
+	}
+
+	wl_bt_pwr_ctrl = rtw_read32(rtwdev, REG_WL_BT_PWR_CTRL);
+	if (wl_bt_pwr_ctrl & BIT_BT_FUNC_EN)
+		rtwdev->efuse.btcoex = true;
+	hal->chip_version = rtw_read32(rtwdev, REG_SYS_CFG1);
+	hal->fab_version = BIT_GET_VENDOR_ID(hal->chip_version) >> 2;
+	hal->cut_version = BIT_GET_CHIP_VER(hal->chip_version);
+	hal->mp_chip = (hal->chip_version & BIT_RTL_ID) ? 0 : 1;
+	if (hal->chip_version & BIT_RF_TYPE_ID) {
+		hal->rf_type = RF_2T2R;
+		hal->rf_path_num = 2;
+		hal->antenna_tx = BB_PATH_AB;
+		hal->antenna_rx = BB_PATH_AB;
+	} else {
+		hal->rf_type = RF_1T1R;
+		hal->rf_path_num = 1;
+		hal->antenna_tx = BB_PATH_A;
+		hal->antenna_rx = BB_PATH_A;
+	}
+
+	if (hal->fab_version == 2)
+		hal->fab_version = 1;
+	else if (hal->fab_version == 1)
+		hal->fab_version = 2;
+
+	efuse->physical_size = chip->phy_efuse_size;
+	efuse->logical_size = chip->log_efuse_size;
+	efuse->protect_size = chip->ptct_efuse_size;
+
+	/* default use ack */
+	rtwdev->hal.rcr |= BIT_VHT_DACK;
+
+	return ret;
+}
+
+static int rtw_chip_efuse_enable(struct rtw_dev *rtwdev)
+{
+	struct rtw_fw_state *fw = &rtwdev->fw;
+	int ret;
+
+	ret = rtw_hci_setup(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to setup hci\n");
+		goto err;
+	}
+
+	ret = rtw_mac_power_on(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to power on mac\n");
+		goto err;
+	}
+
+	rtw_write8(rtwdev, REG_C2HEVT, C2H_HW_FEATURE_DUMP);
+	ret = rtw_download_firmware(rtwdev, fw->firmware->data,
+				    fw->firmware->size);
+	if (ret) {
+		rtw_err(rtwdev, "failed to download firmware\n");
+		goto err_off;
+	}
+
+	return 0;
+
+err_off:
+	rtw_mac_power_off(rtwdev);
+
+err:
+	return ret;
+}
+
+static int rtw_dump_hw_feature(struct rtw_dev *rtwdev)
+{
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	struct efuse_hw_cap *hw_cap;
+	u8 hw_feature[HW_FEATURE_LEN];
+	u8 id;
+	int i;
+
+	BUILD_BUG_ON(sizeof(*hw_cap) != HW_FEATURE_LEN);
+
+	id = rtw_read8(rtwdev, REG_C2HEVT);
+	if (id != C2H_HW_FEATURE_REPORT) {
+		rtw_err(rtwdev, "failed to read hw feature report\n");
+		return -EBUSY;
+	}
+
+	for (i = 0; i < HW_FEATURE_LEN; i++)
+		hw_feature[i] = rtw_read8(rtwdev, REG_C2HEVT + 2 + i);
+
+	rtw_write8(rtwdev, REG_C2HEVT, 0);
+
+	hw_cap = (struct efuse_hw_cap *)hw_feature;
+
+	efuse->hw_cap.bw = hw_bw_cap_to_bitamp(hw_cap->bw);
+	efuse->hw_cap.hci = hw_cap->hci;
+	efuse->hw_cap.nss = hw_cap->nss;
+	efuse->hw_cap.ptcl = hw_cap->ptcl;
+	efuse->hw_cap.ant_num = hw_cap->ant_num;
+
+	rtw_hw_config_rf_ant_num(rtwdev, efuse->hw_cap.ant_num);
+
+	if (efuse->hw_cap.nss == EFUSE_HW_CAP_IGNORE)
+		efuse->hw_cap.nss = rtwdev->hal.rf_path_num;
+
+	rtw_dbg(rtwdev, "hw cap: hci=0x%02x, bw=0x%02x, ptcl=0x%02x, ant_num=%d, nss=%d\n",
+		efuse->hw_cap.hci, efuse->hw_cap.bw, efuse->hw_cap.ptcl,
+		efuse->hw_cap.ant_num, efuse->hw_cap.nss);
+
+	return 0;
+}
+
+static void rtw_chip_efuse_disable(struct rtw_dev *rtwdev)
+{
+	rtw_hci_stop(rtwdev);
+	rtw_mac_power_off(rtwdev);
+}
+
+static int rtw_chip_efuse_info_setup(struct rtw_dev *rtwdev)
+{
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	int ret;
+
+	mutex_lock(&rtwdev->mutex);
+
+	/* power on mac to read efuse */
+	ret = rtw_chip_efuse_enable(rtwdev);
+	if (ret)
+		goto out;
+
+	ret = rtw_parse_efuse_map(rtwdev);
+	if (ret)
+		goto out;
+
+	ret = rtw_dump_hw_feature(rtwdev);
+	if (ret)
+		goto out;
+
+	ret = rtw_check_supported_rfe(rtwdev);
+	if (ret)
+		goto out;
+
+	if (efuse->crystal_cap == 0xff)
+		efuse->crystal_cap = 0;
+	if (efuse->pa_type_2g == 0xff)
+		efuse->pa_type_2g = 0;
+	if (efuse->pa_type_5g == 0xff)
+		efuse->pa_type_5g = 0;
+	if (efuse->lna_type_2g == 0xff)
+		efuse->lna_type_2g = 0;
+	if (efuse->lna_type_5g == 0xff)
+		efuse->lna_type_5g = 0;
+	if (efuse->channel_plan == 0xff)
+		efuse->channel_plan = 0x7f;
+	if (efuse->bt_setting & BIT(0))
+		efuse->share_ant = true;
+	if (efuse->regd == 0xff)
+		efuse->regd = 0;
+
+	efuse->ext_pa_2g = efuse->pa_type_2g & BIT(4) ? 1 : 0;
+	efuse->ext_lna_2g = efuse->lna_type_2g & BIT(3) ? 1 : 0;
+	efuse->ext_pa_5g = efuse->pa_type_5g & BIT(0) ? 1 : 0;
+	efuse->ext_lna_2g = efuse->lna_type_5g & BIT(3) ? 1 : 0;
+
+	rtw_chip_efuse_disable(rtwdev);
+
+out:
+	mutex_unlock(&rtwdev->mutex);
+	return ret;
+}
+
+static int rtw_chip_board_info_setup(struct rtw_dev *rtwdev)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	const struct rtw_rfe_def *rfe_def = rtw_get_rfe_def(rtwdev);
+
+	if (!rfe_def)
+		return -ENODEV;
+
+	rtw_phy_setup_phy_cond(rtwdev, 0);
+
+	rtw_hw_init_tx_power(hal);
+	if (rtwdev->chip->id != RTW_CHIP_TYPE_8822C)
+		rtw_load_table(rtwdev, rfe_def->phy_pg_tbl);
+	rtw_load_table(rtwdev, rfe_def->txpwr_lmt_tbl);
+	rtw_phy_tx_power_by_rate_config(hal);
+	rtw_phy_tx_power_limit_config(hal);
+
+	return 0;
+}
+
+int rtw_chip_info_setup(struct rtw_dev *rtwdev)
+{
+	int ret;
+
+	ret = rtw_chip_parameter_setup(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to setup chip parameters\n");
+		goto err_out;
+	}
+
+	ret = rtw_chip_efuse_info_setup(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to setup chip efuse info\n");
+		goto err_out;
+	}
+
+	ret = rtw_chip_board_info_setup(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to setup chip board info\n");
+		goto err_out;
+	}
+
+	return 0;
+
+err_out:
+	return ret;
+}
+EXPORT_SYMBOL(rtw_chip_info_setup);
+
+int rtw_core_init(struct rtw_dev *rtwdev)
+{
+	int ret;
+
+	INIT_LIST_HEAD(&rtwdev->rsvd_page_list);
+
+	INIT_DELAYED_WORK(&rtwdev->watch_dog_work, rtw_watch_dog_work);
+	INIT_DELAYED_WORK(&rtwdev->lps_work, rtw_lps_work);
+	INIT_WORK(&rtwdev->c2h_work, rtw_c2h_work);
+	skb_queue_head_init(&rtwdev->c2h_queue);
+
+	spin_lock_init(&rtwdev->dm_lock);
+	spin_lock_init(&rtwdev->rf_lock);
+	spin_lock_init(&rtwdev->h2c.lock);
+
+	mutex_init(&rtwdev->mutex);
+	mutex_init(&rtwdev->hal.tx_power_mutex);
+
+	rtwdev->sec.total_cam_num = 32;
+	rtwdev->hal.current_channel = 1;
+	set_bit(RTW_BC_MC_MACID, rtwdev->mac_id_map);
+
+	mutex_lock(&rtwdev->mutex);
+	rtw_add_rsvd_page(rtwdev, RSVD_BEACON, false);
+	mutex_unlock(&rtwdev->mutex);
+
+	/* default rx filter setting */
+	rtwdev->hal.rcr = BIT_APP_FCS | BIT_APP_MIC | BIT_APP_ICV |
+			  BIT_HTC_LOC_CTRL | BIT_APP_PHYSTS |
+			  BIT_AB | BIT_AM | BIT_APM;
+
+	ret = rtw_load_firmware(rtwdev, rtwdev->chip->fw_name);
+	if (ret) {
+		rtw_warn(rtwdev, "no firmware loaded\n");
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(rtw_core_init);
+
+void rtw_core_deinit(struct rtw_dev *rtwdev)
+{
+	struct rtw_fw_state *fw = &rtwdev->fw;
+	struct rtw_rsvd_page *rsvd_pkt, *tmp;
+
+	if (fw->firmware)
+		release_firmware(fw->firmware);
+
+	list_for_each_entry_safe(rsvd_pkt, tmp, &rtwdev->rsvd_page_list, list) {
+		list_del(&rsvd_pkt->list);
+		kfree(rsvd_pkt);
+	}
+
+	mutex_destroy(&rtwdev->mutex);
+	mutex_destroy(&rtwdev->hal.tx_power_mutex);
+}
+EXPORT_SYMBOL(rtw_core_deinit);
+
+int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
+{
+	int max_tx_headroom = 0;
+	int ret;
+
+	/* TODO: USB & SDIO may need extra room? */
+	max_tx_headroom = rtwdev->chip->tx_pkt_desc_sz;
+
+	hw->extra_tx_headroom = max_tx_headroom;
+	hw->queues = IEEE80211_NUM_ACS;
+	hw->sta_data_size = sizeof(struct rtw_sta_info);
+	hw->vif_data_size = sizeof(struct rtw_vif);
+
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, SUPPORTS_PS);
+	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
+
+	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				     BIT(NL80211_IFTYPE_AP) |
+				     BIT(NL80211_IFTYPE_ADHOC) |
+				     BIT(NL80211_IFTYPE_MESH_POINT);
+
+	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
+			    WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
+
+	rtw_set_supported_band(hw, rtwdev->chip);
+	SET_IEEE80211_PERM_ADDR(hw, rtwdev->efuse.addr);
+
+	rtw_regd_init(rtwdev, rtw_regd_notifier);
+
+	ret = ieee80211_register_hw(hw);
+	if (ret) {
+		rtw_err(rtwdev, "failed to register hw\n");
+		return ret;
+	}
+
+	if (regulatory_hint(hw->wiphy, rtwdev->regd.alpha2))
+		rtw_err(rtwdev, "regulatory_hint fail\n");
+
+	rtw_debugfs_init(rtwdev);
+
+	return 0;
+}
+EXPORT_SYMBOL(rtw_register_hw);
+
+void rtw_unregister_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
+{
+	struct rtw_chip_info *chip = rtwdev->chip;
+
+	ieee80211_unregister_hw(hw);
+	rtw_unset_supported_band(hw, chip);
+}
+EXPORT_SYMBOL(rtw_unregister_hw);
+
+MODULE_AUTHOR("Realtek Corporation");
+MODULE_DESCRIPTION("Realtek 802.11ac wireless core module");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
new file mode 100644
index 0000000..b345fe0
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -0,0 +1,1119 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTK_MAIN_H_
+#define __RTK_MAIN_H_
+
+#include <net/mac80211.h>
+#include <linux/vmalloc.h>
+#include <linux/firmware.h>
+#include <linux/average.h>
+#include <linux/bitops.h>
+#include <linux/bitfield.h>
+
+#define RTW_MAX_MAC_ID_NUM		32
+#define RTW_MAX_SEC_CAM_NUM		32
+
+#define RTW_WATCH_DOG_DELAY_TIME	round_jiffies_relative(HZ * 2)
+
+#define RFREG_MASK			0xfffff
+#define INV_RF_DATA			0xffffffff
+#define TX_PAGE_SIZE_SHIFT		7
+
+#define RTW_CHANNEL_WIDTH_MAX		3
+#define RTW_RF_PATH_MAX			4
+#define HW_FEATURE_LEN			13
+
+extern const struct ieee80211_ops rtw_ops;
+extern struct rtw_chip_info rtw8822b_hw_spec;
+extern struct rtw_chip_info rtw8822c_hw_spec;
+
+#define RTW_MAX_CHANNEL_NUM_2G 14
+#define RTW_MAX_CHANNEL_NUM_5G 49
+
+struct rtw_dev;
+
+enum rtw_hci_type {
+	RTW_HCI_TYPE_PCIE,
+	RTW_HCI_TYPE_USB,
+	RTW_HCI_TYPE_SDIO,
+
+	RTW_HCI_TYPE_UNDEFINE,
+};
+
+struct rtw_hci {
+	struct rtw_hci_ops *ops;
+	enum rtw_hci_type type;
+
+	u32 rpwm_addr;
+
+	u8 bulkout_num;
+};
+
+enum rtw_supported_band {
+	RTW_BAND_2G = 1 << 0,
+	RTW_BAND_5G = 1 << 1,
+	RTW_BAND_60G = 1 << 2,
+
+	RTW_BAND_MAX,
+};
+
+enum rtw_bandwidth {
+	RTW_CHANNEL_WIDTH_20	= 0,
+	RTW_CHANNEL_WIDTH_40	= 1,
+	RTW_CHANNEL_WIDTH_80	= 2,
+	RTW_CHANNEL_WIDTH_160	= 3,
+	RTW_CHANNEL_WIDTH_80_80	= 4,
+	RTW_CHANNEL_WIDTH_5	= 5,
+	RTW_CHANNEL_WIDTH_10	= 6,
+};
+
+enum rtw_net_type {
+	RTW_NET_NO_LINK		= 0,
+	RTW_NET_AD_HOC		= 1,
+	RTW_NET_MGD_LINKED	= 2,
+	RTW_NET_AP_MODE		= 3,
+};
+
+enum rtw_rf_type {
+	RF_1T1R			= 0,
+	RF_1T2R			= 1,
+	RF_2T2R			= 2,
+	RF_2T3R			= 3,
+	RF_2T4R			= 4,
+	RF_3T3R			= 5,
+	RF_3T4R			= 6,
+	RF_4T4R			= 7,
+	RF_TYPE_MAX,
+};
+
+enum rtw_rf_path {
+	RF_PATH_A = 0,
+	RF_PATH_B = 1,
+	RF_PATH_C = 2,
+	RF_PATH_D = 3,
+};
+
+enum rtw_bb_path {
+	BB_PATH_A = BIT(0),
+	BB_PATH_B = BIT(1),
+	BB_PATH_C = BIT(2),
+	BB_PATH_D = BIT(3),
+
+	BB_PATH_AB = (BB_PATH_A | BB_PATH_B),
+	BB_PATH_AC = (BB_PATH_A | BB_PATH_C),
+	BB_PATH_AD = (BB_PATH_A | BB_PATH_D),
+	BB_PATH_BC = (BB_PATH_B | BB_PATH_C),
+	BB_PATH_BD = (BB_PATH_B | BB_PATH_D),
+	BB_PATH_CD = (BB_PATH_C | BB_PATH_D),
+
+	BB_PATH_ABC = (BB_PATH_A | BB_PATH_B | BB_PATH_C),
+	BB_PATH_ABD = (BB_PATH_A | BB_PATH_B | BB_PATH_D),
+	BB_PATH_ACD = (BB_PATH_A | BB_PATH_C | BB_PATH_D),
+	BB_PATH_BCD = (BB_PATH_B | BB_PATH_C | BB_PATH_D),
+
+	BB_PATH_ABCD = (BB_PATH_A | BB_PATH_B | BB_PATH_C | BB_PATH_D),
+};
+
+enum rtw_rate_section {
+	RTW_RATE_SECTION_CCK = 0,
+	RTW_RATE_SECTION_OFDM,
+	RTW_RATE_SECTION_HT_1S,
+	RTW_RATE_SECTION_HT_2S,
+	RTW_RATE_SECTION_VHT_1S,
+	RTW_RATE_SECTION_VHT_2S,
+
+	/* keep last */
+	RTW_RATE_SECTION_MAX,
+};
+
+enum rtw_wireless_set {
+	WIRELESS_CCK	= 0x00000001,
+	WIRELESS_OFDM	= 0x00000002,
+	WIRELESS_HT	= 0x00000004,
+	WIRELESS_VHT	= 0x00000008,
+};
+
+#define HT_STBC_EN	BIT(0)
+#define VHT_STBC_EN	BIT(1)
+#define HT_LDPC_EN	BIT(0)
+#define VHT_LDPC_EN	BIT(1)
+
+enum rtw_chip_type {
+	RTW_CHIP_TYPE_8822B,
+	RTW_CHIP_TYPE_8822C,
+};
+
+enum rtw_tx_queue_type {
+	/* the order of AC queues matters */
+	RTW_TX_QUEUE_BK = 0x0,
+	RTW_TX_QUEUE_BE = 0x1,
+	RTW_TX_QUEUE_VI = 0x2,
+	RTW_TX_QUEUE_VO = 0x3,
+
+	RTW_TX_QUEUE_BCN = 0x4,
+	RTW_TX_QUEUE_MGMT = 0x5,
+	RTW_TX_QUEUE_HI0 = 0x6,
+	RTW_TX_QUEUE_H2C = 0x7,
+	/* keep it last */
+	RTK_MAX_TX_QUEUE_NUM
+};
+
+enum rtw_rx_queue_type {
+	RTW_RX_QUEUE_MPDU = 0x0,
+	RTW_RX_QUEUE_C2H = 0x1,
+	/* keep it last */
+	RTK_MAX_RX_QUEUE_NUM
+};
+
+enum rtw_rate_index {
+	RTW_RATEID_BGN_40M_2SS	= 0,
+	RTW_RATEID_BGN_40M_1SS	= 1,
+	RTW_RATEID_BGN_20M_2SS	= 2,
+	RTW_RATEID_BGN_20M_1SS	= 3,
+	RTW_RATEID_GN_N2SS	= 4,
+	RTW_RATEID_GN_N1SS	= 5,
+	RTW_RATEID_BG		= 6,
+	RTW_RATEID_G		= 7,
+	RTW_RATEID_B_20M	= 8,
+	RTW_RATEID_ARFR0_AC_2SS	= 9,
+	RTW_RATEID_ARFR1_AC_1SS	= 10,
+	RTW_RATEID_ARFR2_AC_2G_1SS = 11,
+	RTW_RATEID_ARFR3_AC_2G_2SS = 12,
+	RTW_RATEID_ARFR4_AC_3SS	= 13,
+	RTW_RATEID_ARFR5_N_3SS	= 14,
+	RTW_RATEID_ARFR7_N_4SS	= 15,
+	RTW_RATEID_ARFR6_AC_4SS	= 16
+};
+
+enum rtw_trx_desc_rate {
+	DESC_RATE1M	= 0x00,
+	DESC_RATE2M	= 0x01,
+	DESC_RATE5_5M	= 0x02,
+	DESC_RATE11M	= 0x03,
+
+	DESC_RATE6M	= 0x04,
+	DESC_RATE9M	= 0x05,
+	DESC_RATE12M	= 0x06,
+	DESC_RATE18M	= 0x07,
+	DESC_RATE24M	= 0x08,
+	DESC_RATE36M	= 0x09,
+	DESC_RATE48M	= 0x0a,
+	DESC_RATE54M	= 0x0b,
+
+	DESC_RATEMCS0	= 0x0c,
+	DESC_RATEMCS1	= 0x0d,
+	DESC_RATEMCS2	= 0x0e,
+	DESC_RATEMCS3	= 0x0f,
+	DESC_RATEMCS4	= 0x10,
+	DESC_RATEMCS5	= 0x11,
+	DESC_RATEMCS6	= 0x12,
+	DESC_RATEMCS7	= 0x13,
+	DESC_RATEMCS8	= 0x14,
+	DESC_RATEMCS9	= 0x15,
+	DESC_RATEMCS10	= 0x16,
+	DESC_RATEMCS11	= 0x17,
+	DESC_RATEMCS12	= 0x18,
+	DESC_RATEMCS13	= 0x19,
+	DESC_RATEMCS14	= 0x1a,
+	DESC_RATEMCS15	= 0x1b,
+	DESC_RATEMCS16	= 0x1c,
+	DESC_RATEMCS17	= 0x1d,
+	DESC_RATEMCS18	= 0x1e,
+	DESC_RATEMCS19	= 0x1f,
+	DESC_RATEMCS20	= 0x20,
+	DESC_RATEMCS21	= 0x21,
+	DESC_RATEMCS22	= 0x22,
+	DESC_RATEMCS23	= 0x23,
+	DESC_RATEMCS24	= 0x24,
+	DESC_RATEMCS25	= 0x25,
+	DESC_RATEMCS26	= 0x26,
+	DESC_RATEMCS27	= 0x27,
+	DESC_RATEMCS28	= 0x28,
+	DESC_RATEMCS29	= 0x29,
+	DESC_RATEMCS30	= 0x2a,
+	DESC_RATEMCS31	= 0x2b,
+
+	DESC_RATEVHT1SS_MCS0	= 0x2c,
+	DESC_RATEVHT1SS_MCS1	= 0x2d,
+	DESC_RATEVHT1SS_MCS2	= 0x2e,
+	DESC_RATEVHT1SS_MCS3	= 0x2f,
+	DESC_RATEVHT1SS_MCS4	= 0x30,
+	DESC_RATEVHT1SS_MCS5	= 0x31,
+	DESC_RATEVHT1SS_MCS6	= 0x32,
+	DESC_RATEVHT1SS_MCS7	= 0x33,
+	DESC_RATEVHT1SS_MCS8	= 0x34,
+	DESC_RATEVHT1SS_MCS9	= 0x35,
+
+	DESC_RATEVHT2SS_MCS0	= 0x36,
+	DESC_RATEVHT2SS_MCS1	= 0x37,
+	DESC_RATEVHT2SS_MCS2	= 0x38,
+	DESC_RATEVHT2SS_MCS3	= 0x39,
+	DESC_RATEVHT2SS_MCS4	= 0x3a,
+	DESC_RATEVHT2SS_MCS5	= 0x3b,
+	DESC_RATEVHT2SS_MCS6	= 0x3c,
+	DESC_RATEVHT2SS_MCS7	= 0x3d,
+	DESC_RATEVHT2SS_MCS8	= 0x3e,
+	DESC_RATEVHT2SS_MCS9	= 0x3f,
+
+	DESC_RATEVHT3SS_MCS0	= 0x40,
+	DESC_RATEVHT3SS_MCS1	= 0x41,
+	DESC_RATEVHT3SS_MCS2	= 0x42,
+	DESC_RATEVHT3SS_MCS3	= 0x43,
+	DESC_RATEVHT3SS_MCS4	= 0x44,
+	DESC_RATEVHT3SS_MCS5	= 0x45,
+	DESC_RATEVHT3SS_MCS6	= 0x46,
+	DESC_RATEVHT3SS_MCS7	= 0x47,
+	DESC_RATEVHT3SS_MCS8	= 0x48,
+	DESC_RATEVHT3SS_MCS9	= 0x49,
+
+	DESC_RATEVHT4SS_MCS0	= 0x4a,
+	DESC_RATEVHT4SS_MCS1	= 0x4b,
+	DESC_RATEVHT4SS_MCS2	= 0x4c,
+	DESC_RATEVHT4SS_MCS3	= 0x4d,
+	DESC_RATEVHT4SS_MCS4	= 0x4e,
+	DESC_RATEVHT4SS_MCS5	= 0x4f,
+	DESC_RATEVHT4SS_MCS6	= 0x50,
+	DESC_RATEVHT4SS_MCS7	= 0x51,
+	DESC_RATEVHT4SS_MCS8	= 0x52,
+	DESC_RATEVHT4SS_MCS9	= 0x53,
+
+	DESC_RATE_MAX,
+};
+
+enum rtw_regulatory_domains {
+	RTW_REGD_FCC	= 0,
+	RTW_REGD_MKK	= 1,
+	RTW_REGD_ETSI	= 2,
+	RTW_REGD_WW	= 3,
+
+	RTW_REGD_MAX
+};
+
+enum rtw_flags {
+	RTW_FLAG_RUNNING,
+	RTW_FLAG_FW_RUNNING,
+	RTW_FLAG_SCANNING,
+	RTW_FLAG_INACTIVE_PS,
+	RTW_FLAG_LEISURE_PS,
+	RTW_FLAG_DIG_DISABLE,
+
+	NUM_OF_RTW_FLAGS,
+};
+
+/* the power index is represented by differences, which cck-1s & ht40-1s are
+ * the base values, so for 1s's differences, there are only ht20 & ofdm
+ */
+struct rtw_2g_1s_pwr_idx_diff {
+#ifdef __LITTLE_ENDIAN
+	s8 ofdm:4;
+	s8 bw20:4;
+#else
+	s8 bw20:4;
+	s8 ofdm:4;
+#endif
+} __packed;
+
+struct rtw_2g_ns_pwr_idx_diff {
+#ifdef __LITTLE_ENDIAN
+	s8 bw20:4;
+	s8 bw40:4;
+	s8 cck:4;
+	s8 ofdm:4;
+#else
+	s8 ofdm:4;
+	s8 cck:4;
+	s8 bw40:4;
+	s8 bw20:4;
+#endif
+} __packed;
+
+struct rtw_2g_txpwr_idx {
+	u8 cck_base[6];
+	u8 bw40_base[5];
+	struct rtw_2g_1s_pwr_idx_diff ht_1s_diff;
+	struct rtw_2g_ns_pwr_idx_diff ht_2s_diff;
+	struct rtw_2g_ns_pwr_idx_diff ht_3s_diff;
+	struct rtw_2g_ns_pwr_idx_diff ht_4s_diff;
+};
+
+struct rtw_5g_ht_1s_pwr_idx_diff {
+#ifdef __LITTLE_ENDIAN
+	s8 ofdm:4;
+	s8 bw20:4;
+#else
+	s8 bw20:4;
+	s8 ofdm:4;
+#endif
+} __packed;
+
+struct rtw_5g_ht_ns_pwr_idx_diff {
+#ifdef __LITTLE_ENDIAN
+	s8 bw20:4;
+	s8 bw40:4;
+#else
+	s8 bw40:4;
+	s8 bw20:4;
+#endif
+} __packed;
+
+struct rtw_5g_ofdm_ns_pwr_idx_diff {
+#ifdef __LITTLE_ENDIAN
+	s8 ofdm_3s:4;
+	s8 ofdm_2s:4;
+	s8 ofdm_4s:4;
+	s8 res:4;
+#else
+	s8 res:4;
+	s8 ofdm_4s:4;
+	s8 ofdm_2s:4;
+	s8 ofdm_3s:4;
+#endif
+} __packed;
+
+struct rtw_5g_vht_ns_pwr_idx_diff {
+#ifdef __LITTLE_ENDIAN
+	s8 bw160:4;
+	s8 bw80:4;
+#else
+	s8 bw80:4;
+	s8 bw160:4;
+#endif
+} __packed;
+
+struct rtw_5g_txpwr_idx {
+	u8 bw40_base[14];
+	struct rtw_5g_ht_1s_pwr_idx_diff ht_1s_diff;
+	struct rtw_5g_ht_ns_pwr_idx_diff ht_2s_diff;
+	struct rtw_5g_ht_ns_pwr_idx_diff ht_3s_diff;
+	struct rtw_5g_ht_ns_pwr_idx_diff ht_4s_diff;
+	struct rtw_5g_ofdm_ns_pwr_idx_diff ofdm_diff;
+	struct rtw_5g_vht_ns_pwr_idx_diff vht_1s_diff;
+	struct rtw_5g_vht_ns_pwr_idx_diff vht_2s_diff;
+	struct rtw_5g_vht_ns_pwr_idx_diff vht_3s_diff;
+	struct rtw_5g_vht_ns_pwr_idx_diff vht_4s_diff;
+};
+
+struct rtw_txpwr_idx {
+	struct rtw_2g_txpwr_idx pwr_idx_2g;
+	struct rtw_5g_txpwr_idx pwr_idx_5g;
+};
+
+struct rtw_timer_list {
+	struct timer_list timer;
+	void (*function)(void *data);
+	void *args;
+};
+
+struct rtw_channel_params {
+	u8 center_chan;
+	u8 bandwidth;
+	u8 primary_chan_idx;
+};
+
+struct rtw_hw_reg {
+	u32 addr;
+	u32 mask;
+};
+
+struct rtw_backup_info {
+	u8 len;
+	u32 reg;
+	u32 val;
+};
+
+enum rtw_vif_port_set {
+	PORT_SET_MAC_ADDR	= BIT(0),
+	PORT_SET_BSSID		= BIT(1),
+	PORT_SET_NET_TYPE	= BIT(2),
+	PORT_SET_AID		= BIT(3),
+};
+
+struct rtw_vif_port {
+	struct rtw_hw_reg mac_addr;
+	struct rtw_hw_reg bssid;
+	struct rtw_hw_reg net_type;
+	struct rtw_hw_reg aid;
+};
+
+struct rtw_tx_pkt_info {
+	u32 tx_pkt_size;
+	u8 offset;
+	u8 pkt_offset;
+	u8 mac_id;
+	u8 rate_id;
+	u8 rate;
+	u8 qsel;
+	u8 bw;
+	u8 sec_type;
+	bool ampdu_en;
+	u8 ampdu_factor;
+	u8 ampdu_density;
+	u16 seq;
+	bool stbc;
+	bool ldpc;
+	bool dis_rate_fallback;
+	bool bmc;
+	bool use_rate;
+	bool ls;
+	bool fs;
+	bool short_gi;
+};
+
+struct rtw_rx_pkt_stat {
+	bool phy_status;
+	bool icv_err;
+	bool crc_err;
+	bool decrypted;
+	bool is_c2h;
+
+	s32 signal_power;
+	u16 pkt_len;
+	u8 bw;
+	u8 drv_info_sz;
+	u8 shift;
+	u8 rate;
+	u8 mac_id;
+	u8 cam_id;
+	u8 ppdu_cnt;
+	u32 tsf_low;
+	s8 rx_power[RTW_RF_PATH_MAX];
+	u8 rssi;
+	u8 rxsc;
+	struct rtw_sta_info *si;
+	struct ieee80211_vif *vif;
+};
+
+struct rtw_traffic_stats {
+	/* units in bytes */
+	u64 tx_unicast;
+	u64 rx_unicast;
+
+	/* count for packets */
+	u64 tx_cnt;
+	u64 rx_cnt;
+
+	/* units in Mbps */
+	u32 tx_throughput;
+	u32 rx_throughput;
+};
+
+enum rtw_lps_mode {
+	RTW_MODE_ACTIVE	= 0,
+	RTW_MODE_LPS	= 1,
+	RTW_MODE_WMM_PS	= 2,
+};
+
+enum rtw_pwr_state {
+	RTW_RF_OFF	= 0x0,
+	RTW_RF_ON	= 0x4,
+	RTW_ALL_ON	= 0xc,
+};
+
+struct rtw_lps_conf {
+	/* the interface to enter lps */
+	struct rtw_vif *rtwvif;
+	enum rtw_lps_mode mode;
+	enum rtw_pwr_state state;
+	u8 awake_interval;
+	u8 rlbm;
+	u8 smart_ps;
+	u8 port_id;
+};
+
+enum rtw_hw_key_type {
+	RTW_CAM_NONE	= 0,
+	RTW_CAM_WEP40	= 1,
+	RTW_CAM_TKIP	= 2,
+	RTW_CAM_AES	= 4,
+	RTW_CAM_WEP104	= 5,
+};
+
+struct rtw_cam_entry {
+	bool valid;
+	bool group;
+	u8 addr[ETH_ALEN];
+	u8 hw_key_type;
+	struct ieee80211_key_conf *key;
+};
+
+struct rtw_sec_desc {
+	/* search strategy */
+	bool default_key_search;
+
+	u32 total_cam_num;
+	struct rtw_cam_entry cam_table[RTW_MAX_SEC_CAM_NUM];
+	DECLARE_BITMAP(cam_map, RTW_MAX_SEC_CAM_NUM);
+};
+
+#define RTW_BC_MC_MACID 1
+DECLARE_EWMA(rssi, 10, 16);
+
+struct rtw_sta_info {
+	struct ieee80211_sta *sta;
+	struct ieee80211_vif *vif;
+
+	struct ewma_rssi avg_rssi;
+	u8 rssi_level;
+
+	u8 mac_id;
+	u8 rate_id;
+	enum rtw_bandwidth bw_mode;
+	enum rtw_rf_type rf_type;
+	enum rtw_wireless_set wireless_set;
+	u8 stbc_en:2;
+	u8 ldpc_en:2;
+	bool sgi_enable;
+	bool vht_enable;
+	bool updated;
+	u8 init_ra_lv;
+	u64 ra_mask;
+};
+
+struct rtw_vif {
+	struct ieee80211_vif *vif;
+	enum rtw_net_type net_type;
+	u16 aid;
+	u8 mac_addr[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
+	u8 port;
+	const struct rtw_vif_port *conf;
+
+	struct rtw_traffic_stats stats;
+	bool in_lps;
+};
+
+struct rtw_regulatory {
+	char alpha2[2];
+	u8 chplan;
+	u8 txpwr_regd;
+};
+
+struct rtw_chip_ops {
+	int (*mac_init)(struct rtw_dev *rtwdev);
+	int (*read_efuse)(struct rtw_dev *rtwdev, u8 *map);
+	void (*phy_set_param)(struct rtw_dev *rtwdev);
+	void (*set_channel)(struct rtw_dev *rtwdev, u8 channel,
+			    u8 bandwidth, u8 primary_chan_idx);
+	void (*query_rx_desc)(struct rtw_dev *rtwdev, u8 *rx_desc,
+			      struct rtw_rx_pkt_stat *pkt_stat,
+			      struct ieee80211_rx_status *rx_status);
+	u32 (*read_rf)(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
+		       u32 addr, u32 mask);
+	bool (*write_rf)(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
+			 u32 addr, u32 mask, u32 data);
+	void (*set_tx_power_index)(struct rtw_dev *rtwdev, u8 power_index,
+				   u8 rf_path, u8 rate);
+	int (*rsvd_page_dump)(struct rtw_dev *rtwdev, u8 *buf, u32 offset,
+			      u32 size);
+	void (*set_antenna)(struct rtw_dev *rtwdev, u8 antenna_tx,
+			    u8 antenna_rx);
+	void (*cfg_ldo25)(struct rtw_dev *rtwdev, bool enable);
+	void (*false_alarm_statistics)(struct rtw_dev *rtwdev);
+	void (*do_iqk)(struct rtw_dev *rtwdev);
+};
+
+#define RTW_PWR_POLLING_CNT	20000
+
+#define RTW_PWR_CMD_READ	0x00
+#define RTW_PWR_CMD_WRITE	0x01
+#define RTW_PWR_CMD_POLLING	0x02
+#define RTW_PWR_CMD_DELAY	0x03
+#define RTW_PWR_CMD_END		0x04
+
+/* define the base address of each block */
+#define RTW_PWR_ADDR_MAC	0x00
+#define RTW_PWR_ADDR_USB	0x01
+#define RTW_PWR_ADDR_PCIE	0x02
+#define RTW_PWR_ADDR_SDIO	0x03
+
+#define RTW_PWR_INTF_SDIO_MSK	BIT(0)
+#define RTW_PWR_INTF_USB_MSK	BIT(1)
+#define RTW_PWR_INTF_PCI_MSK	BIT(2)
+#define RTW_PWR_INTF_ALL_MSK	(BIT(0) | BIT(1) | BIT(2) | BIT(3))
+
+#define RTW_PWR_CUT_A_MSK	BIT(1)
+#define RTW_PWR_CUT_B_MSK	BIT(2)
+#define RTW_PWR_CUT_C_MSK	BIT(3)
+#define RTW_PWR_CUT_D_MSK	BIT(4)
+#define RTW_PWR_CUT_E_MSK	BIT(5)
+#define RTW_PWR_CUT_F_MSK	BIT(6)
+#define RTW_PWR_CUT_G_MSK	BIT(7)
+#define RTW_PWR_CUT_ALL_MSK	0xFF
+
+enum rtw_pwr_seq_cmd_delay_unit {
+	RTW_PWR_DELAY_US,
+	RTW_PWR_DELAY_MS,
+};
+
+struct rtw_pwr_seq_cmd {
+	u16 offset;
+	u8 cut_mask;
+	u8 intf_mask;
+	u8 base:4;
+	u8 cmd:4;
+	u8 mask;
+	u8 value;
+};
+
+enum rtw_chip_ver {
+	RTW_CHIP_VER_CUT_A = 0x00,
+	RTW_CHIP_VER_CUT_B = 0x01,
+	RTW_CHIP_VER_CUT_C = 0x02,
+	RTW_CHIP_VER_CUT_D = 0x03,
+	RTW_CHIP_VER_CUT_E = 0x04,
+	RTW_CHIP_VER_CUT_F = 0x05,
+	RTW_CHIP_VER_CUT_G = 0x06,
+};
+
+#define RTW_INTF_PHY_PLATFORM_ALL 0
+
+enum rtw_intf_phy_cut {
+	RTW_INTF_PHY_CUT_A = BIT(0),
+	RTW_INTF_PHY_CUT_B = BIT(1),
+	RTW_INTF_PHY_CUT_C = BIT(2),
+	RTW_INTF_PHY_CUT_D = BIT(3),
+	RTW_INTF_PHY_CUT_E = BIT(4),
+	RTW_INTF_PHY_CUT_F = BIT(5),
+	RTW_INTF_PHY_CUT_G = BIT(6),
+	RTW_INTF_PHY_CUT_ALL = 0xFFFF,
+};
+
+enum rtw_ip_sel {
+	RTW_IP_SEL_PHY = 0,
+	RTW_IP_SEL_MAC = 1,
+	RTW_IP_SEL_DBI = 2,
+
+	RTW_IP_SEL_UNDEF = 0xFFFF
+};
+
+enum rtw_pq_map_id {
+	RTW_PQ_MAP_VO = 0x0,
+	RTW_PQ_MAP_VI = 0x1,
+	RTW_PQ_MAP_BE = 0x2,
+	RTW_PQ_MAP_BK = 0x3,
+	RTW_PQ_MAP_MG = 0x4,
+	RTW_PQ_MAP_HI = 0x5,
+	RTW_PQ_MAP_NUM = 0x6,
+
+	RTW_PQ_MAP_UNDEF,
+};
+
+enum rtw_dma_mapping {
+	RTW_DMA_MAPPING_EXTRA	= 0,
+	RTW_DMA_MAPPING_LOW	= 1,
+	RTW_DMA_MAPPING_NORMAL	= 2,
+	RTW_DMA_MAPPING_HIGH	= 3,
+
+	RTW_DMA_MAPPING_UNDEF,
+};
+
+struct rtw_rqpn {
+	enum rtw_dma_mapping dma_map_vo;
+	enum rtw_dma_mapping dma_map_vi;
+	enum rtw_dma_mapping dma_map_be;
+	enum rtw_dma_mapping dma_map_bk;
+	enum rtw_dma_mapping dma_map_mg;
+	enum rtw_dma_mapping dma_map_hi;
+};
+
+struct rtw_page_table {
+	u16 hq_num;
+	u16 nq_num;
+	u16 lq_num;
+	u16 exq_num;
+	u16 gapq_num;
+};
+
+struct rtw_intf_phy_para {
+	u16 offset;
+	u16 value;
+	u16 ip_sel;
+	u16 cut_mask;
+	u16 platform;
+};
+
+struct rtw_intf_phy_para_table {
+	struct rtw_intf_phy_para *usb2_para;
+	struct rtw_intf_phy_para *usb3_para;
+	struct rtw_intf_phy_para *gen1_para;
+	struct rtw_intf_phy_para *gen2_para;
+	u8 n_usb2_para;
+	u8 n_usb3_para;
+	u8 n_gen1_para;
+	u8 n_gen2_para;
+};
+
+struct rtw_table {
+	const void *data;
+	const u32 size;
+	void (*parse)(struct rtw_dev *rtwdev, const struct rtw_table *tbl);
+	void (*do_cfg)(struct rtw_dev *rtwdev, const struct rtw_table *tbl,
+		       u32 addr, u32 data);
+	enum rtw_rf_path rf_path;
+};
+
+static inline void rtw_load_table(struct rtw_dev *rtwdev,
+				  const struct rtw_table *tbl)
+{
+	(*tbl->parse)(rtwdev, tbl);
+}
+
+enum rtw_rfe_fem {
+	RTW_RFE_IFEM,
+	RTW_RFE_EFEM,
+	RTW_RFE_IFEM2G_EFEM5G,
+	RTW_RFE_NUM,
+};
+
+struct rtw_rfe_def {
+	const struct rtw_table *phy_pg_tbl;
+	const struct rtw_table *txpwr_lmt_tbl;
+};
+
+#define RTW_DEF_RFE(chip, bb_pg, pwrlmt) {				  \
+	.phy_pg_tbl = &rtw ## chip ## _bb_pg_type ## bb_pg ## _tbl,	  \
+	.txpwr_lmt_tbl = &rtw ## chip ## _txpwr_lmt_type ## pwrlmt ## _tbl, \
+	}
+
+/* hardware configuration for each IC */
+struct rtw_chip_info {
+	struct rtw_chip_ops *ops;
+	u8 id;
+
+	const char *fw_name;
+	u8 tx_pkt_desc_sz;
+	u8 tx_buf_desc_sz;
+	u8 rx_pkt_desc_sz;
+	u8 rx_buf_desc_sz;
+	u32 phy_efuse_size;
+	u32 log_efuse_size;
+	u32 ptct_efuse_size;
+	u32 txff_size;
+	u32 rxff_size;
+	u8 band;
+	u8 page_size;
+	u8 csi_buf_pg_num;
+	u8 dig_max;
+	u8 dig_min;
+
+	bool ht_supported;
+	bool vht_supported;
+
+	/* init values */
+	u8 sys_func_en;
+	struct rtw_pwr_seq_cmd **pwr_on_seq;
+	struct rtw_pwr_seq_cmd **pwr_off_seq;
+	struct rtw_rqpn *rqpn_table;
+	struct rtw_page_table *page_table;
+	struct rtw_intf_phy_para_table *intf_table;
+
+	struct rtw_hw_reg *dig;
+	u32 rf_base_addr[2];
+	u32 rf_sipi_addr[2];
+
+	const struct rtw_table *mac_tbl;
+	const struct rtw_table *agc_tbl;
+	const struct rtw_table *bb_tbl;
+	const struct rtw_table *rf_tbl[RTW_RF_PATH_MAX];
+
+	const struct rtw_rfe_def *rfe_defs;
+	u32 rfe_defs_size;
+};
+
+struct rtw_dm_info {
+	u32 cck_fa_cnt;
+	u32 ofdm_fa_cnt;
+	u32 total_fa_cnt;
+	u8 min_rssi;
+	u8 pre_min_rssi;
+	u16 fa_history[4];
+	u8 igi_history[4];
+	u8 igi_bitmap;
+	bool damping;
+	u8 damping_cnt;
+	u8 damping_rssi;
+
+	u8 cck_gi_u_bnd;
+	u8 cck_gi_l_bnd;
+};
+
+struct rtw_efuse {
+	u32 size;
+	u32 physical_size;
+	u32 logical_size;
+	u32 protect_size;
+
+	u8 addr[ETH_ALEN];
+	u8 channel_plan;
+	u8 country_code[2];
+	u8 rfe_option;
+	u8 thermal_meter;
+	u8 crystal_cap;
+	u8 ant_div_cfg;
+	u8 ant_div_type;
+	u8 regd;
+
+	u8 lna_type_2g;
+	u8 lna_type_5g;
+	u8 glna_type;
+	u8 alna_type;
+	bool ext_lna_2g;
+	bool ext_lna_5g;
+	u8 pa_type_2g;
+	u8 pa_type_5g;
+	u8 gpa_type;
+	u8 apa_type;
+	bool ext_pa_2g;
+	bool ext_pa_5g;
+	u8 x3d7;
+	u8 x3d8;
+
+	bool btcoex;
+	/* bt share antenna with wifi */
+	bool share_ant;
+	u8 bt_setting;
+
+	struct {
+		u8 hci;
+		u8 bw;
+		u8 ptcl;
+		u8 nss;
+		u8 ant_num;
+	} hw_cap;
+
+	struct rtw_txpwr_idx txpwr_idx_table[4];
+};
+
+struct rtw_phy_cond {
+#ifdef __LITTLE_ENDIAN
+	u32 rfe:8;
+	u32 intf:4;
+	u32 pkg:4;
+	u32 plat:4;
+	u32 intf_rsvd:4;
+	u32 cut:4;
+	u32 branch:2;
+	u32 neg:1;
+	u32 pos:1;
+#else
+	u32 pos:1;
+	u32 neg:1;
+	u32 branch:2;
+	u32 cut:4;
+	u32 intf_rsvd:4;
+	u32 plat:4;
+	u32 pkg:4;
+	u32 intf:4;
+	u32 rfe:8;
+#endif
+	/* for intf:4 */
+	#define INTF_PCIE	BIT(0)
+	#define INTF_USB	BIT(1)
+	#define INTF_SDIO	BIT(2)
+	/* for branch:2 */
+	#define BRANCH_IF	0
+	#define BRANCH_ELIF	1
+	#define BRANCH_ELSE	2
+	#define BRANCH_ENDIF	3
+};
+
+struct rtw_fifo_conf {
+	/* tx fifo information */
+	u16 rsvd_boundary;
+	u16 rsvd_pg_num;
+	u16 rsvd_drv_pg_num;
+	u16 txff_pg_num;
+	u16 acq_pg_num;
+	u16 rsvd_drv_addr;
+	u16 rsvd_h2c_info_addr;
+	u16 rsvd_h2c_sta_info_addr;
+	u16 rsvd_h2cq_addr;
+	u16 rsvd_cpu_instr_addr;
+	u16 rsvd_fw_txbuf_addr;
+	u16 rsvd_csibuf_addr;
+	enum rtw_dma_mapping pq_map[RTW_PQ_MAP_NUM];
+};
+
+struct rtw_fw_state {
+	const struct firmware *firmware;
+	struct completion completion;
+	u16 version;
+	u8 sub_version;
+	u8 sub_index;
+	u16 h2c_version;
+};
+
+struct rtw_hal {
+	u32 rcr;
+
+	u32 chip_version;
+	u8 fab_version;
+	u8 cut_version;
+	u8 mp_chip;
+	u8 oem_id;
+	struct rtw_phy_cond phy_cond;
+
+	u8 ps_mode;
+	u8 current_channel;
+	u8 current_band_width;
+	u8 current_band_type;
+	u8 sec_ch_offset;
+	u8 rf_type;
+	u8 rf_path_num;
+	u8 antenna_tx;
+	u8 antenna_rx;
+
+	/* protect tx power section */
+	struct mutex tx_power_mutex;
+	s8 tx_pwr_by_rate_offset_2g[RTW_RF_PATH_MAX]
+				   [DESC_RATE_MAX];
+	s8 tx_pwr_by_rate_offset_5g[RTW_RF_PATH_MAX]
+				   [DESC_RATE_MAX];
+	s8 tx_pwr_by_rate_base_2g[RTW_RF_PATH_MAX]
+				 [RTW_RATE_SECTION_MAX];
+	s8 tx_pwr_by_rate_base_5g[RTW_RF_PATH_MAX]
+				 [RTW_RATE_SECTION_MAX];
+	s8 tx_pwr_limit_2g[RTW_REGD_MAX]
+			  [RTW_CHANNEL_WIDTH_MAX]
+			  [RTW_RATE_SECTION_MAX]
+			  [RTW_MAX_CHANNEL_NUM_2G];
+	s8 tx_pwr_limit_5g[RTW_REGD_MAX]
+			  [RTW_CHANNEL_WIDTH_MAX]
+			  [RTW_RATE_SECTION_MAX]
+			  [RTW_MAX_CHANNEL_NUM_5G];
+};
+
+struct rtw_dev {
+	struct ieee80211_hw *hw;
+	struct device *dev;
+
+	struct rtw_hci hci;
+
+	struct rtw_chip_info *chip;
+	struct rtw_hal hal;
+	struct rtw_fifo_conf fifo;
+	struct rtw_fw_state fw;
+	struct rtw_efuse efuse;
+	struct rtw_sec_desc sec;
+	struct rtw_traffic_stats stats;
+	struct rtw_regulatory regd;
+
+	struct rtw_dm_info dm_info;
+
+	/* ensures exclusive access from mac80211 callbacks */
+	struct mutex mutex;
+
+	/* lock for dm to use */
+	spinlock_t dm_lock;
+
+	/* read/write rf register */
+	spinlock_t rf_lock;
+
+	/* watch dog every 2 sec */
+	struct delayed_work watch_dog_work;
+	u32 watch_dog_cnt;
+
+	struct list_head rsvd_page_list;
+
+	/* c2h cmd queue & handler work */
+	struct sk_buff_head c2h_queue;
+	struct work_struct c2h_work;
+
+	struct {
+		/* incicate the mail box to use with fw */
+		u8 last_box_num;
+		/* protect to send h2c to fw */
+		spinlock_t lock;
+		u32 seq;
+	} h2c;
+
+	/* lps power state & handler work */
+	struct rtw_lps_conf lps_conf;
+	struct delayed_work lps_work;
+
+	struct dentry *debugfs;
+
+	u8 sta_cnt;
+
+	DECLARE_BITMAP(mac_id_map, RTW_MAX_MAC_ID_NUM);
+	DECLARE_BITMAP(flags, NUM_OF_RTW_FLAGS);
+
+	u8 mp_mode;
+
+	/* hci related data, must be last */
+	u8 priv[0] __aligned(sizeof(void *));
+};
+
+#include "hci.h"
+
+static inline bool rtw_flag_check(struct rtw_dev *rtwdev, enum rtw_flags flag)
+{
+	return test_bit(flag, rtwdev->flags);
+}
+
+static inline void rtw_flag_clear(struct rtw_dev *rtwdev, enum rtw_flags flag)
+{
+	clear_bit(flag, rtwdev->flags);
+}
+
+static inline void rtw_flag_set(struct rtw_dev *rtwdev, enum rtw_flags flag)
+{
+	set_bit(flag, rtwdev->flags);
+}
+
+static inline u8 *get_hdr_bssid(struct ieee80211_hdr *hdr)
+{
+	__le16 fc = hdr->frame_control;
+	u8 *bssid;
+
+	if (ieee80211_has_tods(fc))
+		bssid = hdr->addr1;
+	else if (ieee80211_has_fromds(fc))
+		bssid = hdr->addr2;
+	else
+		bssid = hdr->addr3;
+
+	return bssid;
+}
+
+static inline bool check_hw_ready(struct rtw_dev *rtwdev,
+				  u32 addr, u32 mask, u32 target)
+{
+	u32 cnt;
+
+	for (cnt = 0; cnt < 1000; cnt++) {
+		if (rtw_read32_mask(rtwdev, addr, mask) == target)
+			return true;
+
+		udelay(10);
+	}
+
+	return false;
+}
+
+#define rtw_iterate_vifs(rtwdev, iterator, data)                               \
+	ieee80211_iterate_active_interfaces(rtwdev->hw,                        \
+			IEEE80211_IFACE_ITER_NORMAL, iterator, data)
+#define rtw_iterate_vifs_atomic(rtwdev, iterator, data)                        \
+	ieee80211_iterate_active_interfaces_atomic(rtwdev->hw,                 \
+			IEEE80211_IFACE_ITER_NORMAL, iterator, data)
+#define rtw_iterate_stas_atomic(rtwdev, iterator, data)                        \
+	ieee80211_iterate_stations_atomic(rtwdev->hw, iterator, data)
+
+void rtw_get_channel_params(struct cfg80211_chan_def *chandef,
+			    struct rtw_channel_params *ch_param);
+void rtw_set_channel(struct rtw_dev *rtwdev);
+void rtw_vif_port_config(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif,
+			 u32 config);
+void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si);
+int rtw_core_start(struct rtw_dev *rtwdev);
+void rtw_core_stop(struct rtw_dev *rtwdev);
+int rtw_chip_info_setup(struct rtw_dev *rtwdev);
+int rtw_core_init(struct rtw_dev *rtwdev);
+void rtw_core_deinit(struct rtw_dev *rtwdev);
+int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw);
+void rtw_unregister_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw);
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
new file mode 100644
index 0000000..6e81829
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -0,0 +1,411 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_REG_DEF_H__
+#define __RTW_REG_DEF_H__
+
+#define REG_SYS_FUNC_EN		0x0002
+#define BIT_FEN_CPUEN		BIT(2)
+#define BIT_FEN_BB_GLB_RST	BIT(1)
+#define BIT_FEN_BB_RSTB		BIT(0)
+#define REG_SYS_PW_CTRL		0x0004
+#define REG_SYS_CLK_CTRL	0x0008
+#define BIT_CPU_CLK_EN		BIT(14)
+
+#define REG_RSV_CTRL		0x001C
+#define BIT_WLMCU_IOIF		BIT(0)
+#define REG_RF_CTRL		0x001F
+#define BIT_RF_SDM_RSTB		BIT(2)
+#define BIT_RF_RSTB		BIT(1)
+#define BIT_RF_EN		BIT(0)
+
+#define REG_AFE_CTRL1		0x0024
+#define BIT_MAC_CLK_SEL		(BIT(20) | BIT(21))
+#define REG_EFUSE_CTRL		0x0030
+#define BIT_EF_FLAG		BIT(31)
+#define BIT_SHIFT_EF_ADDR	8
+#define BIT_MASK_EF_ADDR	0x3ff
+#define BIT_MASK_EF_DATA	0xff
+#define BITS_EF_ADDR		(BIT_MASK_EF_ADDR << BIT_SHIFT_EF_ADDR)
+
+#define REG_LDO_EFUSE_CTRL	0x0034
+#define BIT_MASK_EFUSE_BANK_SEL	(BIT(8) | BIT(9))
+
+#define REG_GPIO_MUXCFG		0x0040
+#define BIT_FSPI_EN		BIT(19)
+#define BIT_WLRFE_4_5_EN	BIT(2)
+
+#define REG_LED_CFG		0x004C
+#define BIT_LNAON_SEL_EN	BIT(26)
+#define BIT_PAPE_SEL_EN		BIT(25)
+#define REG_PAD_CTRL1		0x0064
+#define BIT_PAPE_WLBT_SEL	BIT(29)
+#define BIT_LNAON_WLBT_SEL	BIT(28)
+#define REG_WL_BT_PWR_CTRL	0x0068
+#define BIT_BT_FUNC_EN		BIT(18)
+#define BIT_BT_DIG_CLK_EN	BIT(8)
+#define REG_HCI_OPT_CTRL	0x0074
+
+#define REG_MCUFW_CTRL		0x0080
+#define BIT_ANA_PORT_EN		BIT(22)
+#define BIT_MAC_PORT_EN		BIT(21)
+#define BIT_BOOT_FSPI_EN	BIT(20)
+#define BIT_FW_INIT_RDY		BIT(15)
+#define BIT_FW_DW_RDY		BIT(14)
+#define BIT_RPWM_TOGGLE		BIT(7)
+#define BIT_DMEM_CHKSUM_OK	BIT(6)
+#define BIT_DMEM_DW_OK		BIT(5)
+#define BIT_IMEM_CHKSUM_OK	BIT(4)
+#define BIT_IMEM_DW_OK		BIT(3)
+#define BIT_IMEM_BOOT_LOAD_CHECKSUM_OK BIT(2)
+#define BIT_MCUFWDL_EN		BIT(0)
+#define BIT_CHECK_SUM_OK	(BIT(4) | BIT(6))
+#define FW_READY		(BIT_FW_INIT_RDY | BIT_FW_DW_RDY |             \
+				 BIT_IMEM_DW_OK | BIT_DMEM_DW_OK |             \
+				 BIT_CHECK_SUM_OK)
+#define FW_READY_MASK		0xffff
+
+#define REG_SYS_CFG1		0x00F0
+#define	BIT_RTL_ID		BIT(23)
+#define BIT_RF_TYPE_ID		BIT(27)
+#define BIT_SHIFT_VENDOR_ID	16
+#define BIT_MASK_VENDOR_ID	0xf
+#define BIT_VENDOR_ID(x) (((x) & BIT_MASK_VENDOR_ID) << BIT_SHIFT_VENDOR_ID)
+#define BITS_VENDOR_ID		(BIT_MASK_VENDOR_ID << BIT_SHIFT_VENDOR_ID)
+#define BIT_CLEAR_VENDOR_ID(x)	((x) & (~BITS_VENDOR_ID))
+#define BIT_GET_VENDOR_ID(x) (((x) >> BIT_SHIFT_VENDOR_ID) & BIT_MASK_VENDOR_ID)
+#define BIT_SHIFT_CHIP_VER	12
+#define BIT_MASK_CHIP_VER	0xf
+#define BIT_CHIP_VER(x)	 (((x) & BIT_MASK_CHIP_VER) << BIT_SHIFT_CHIP_VER)
+#define BITS_CHIP_VER		(BIT_MASK_CHIP_VER << BIT_SHIFT_CHIP_VER)
+#define BIT_CLEAR_CHIP_VER(x)	((x) & (~BITS_CHIP_VER))
+#define BIT_GET_CHIP_VER(x) (((x) >> BIT_SHIFT_CHIP_VER) & BIT_MASK_CHIP_VER)
+#define REG_SYS_STATUS1		0x00F4
+#define REG_SYS_STATUS2		0x00F8
+#define REG_SYS_CFG2		0x00FC
+#define REG_WLRF1		0x00EC
+#define BIT_WLRF1_BBRF_EN	(BIT(24) | BIT(25) | BIT(26))
+#define REG_CR			0x0100
+#define BIT_32K_CAL_TMR_EN	BIT(10)
+#define BIT_MAC_SEC_EN		BIT(9)
+#define BIT_ENSWBCN		BIT(8)
+#define BIT_MACRXEN		BIT(7)
+#define BIT_MACTXEN		BIT(6)
+#define BIT_SCHEDULE_EN		BIT(5)
+#define BIT_PROTOCOL_EN		BIT(4)
+#define BIT_RXDMA_EN		BIT(3)
+#define BIT_TXDMA_EN		BIT(2)
+#define BIT_HCI_RXDMA_EN	BIT(1)
+#define BIT_HCI_TXDMA_EN	BIT(0)
+#define MAC_TRX_ENABLE	(BIT_HCI_TXDMA_EN | BIT_HCI_RXDMA_EN | BIT_TXDMA_EN | \
+			BIT_RXDMA_EN | BIT_PROTOCOL_EN | BIT_SCHEDULE_EN | \
+			BIT_MACTXEN | BIT_MACRXEN)
+#define BIT_SHIFT_TXDMA_VOQ_MAP	4
+#define BIT_MASK_TXDMA_VOQ_MAP	0x3
+#define BIT_TXDMA_VOQ_MAP(x)                                                   \
+	(((x) & BIT_MASK_TXDMA_VOQ_MAP) << BIT_SHIFT_TXDMA_VOQ_MAP)
+#define BIT_SHIFT_TXDMA_VIQ_MAP	6
+#define BIT_MASK_TXDMA_VIQ_MAP	0x3
+#define BIT_TXDMA_VIQ_MAP(x)                                                   \
+	(((x) & BIT_MASK_TXDMA_VIQ_MAP) << BIT_SHIFT_TXDMA_VIQ_MAP)
+#define REG_TXDMA_PQ_MAP	0x010C
+#define BIT_SHIFT_TXDMA_BEQ_MAP	8
+#define BIT_MASK_TXDMA_BEQ_MAP	0x3
+#define BIT_TXDMA_BEQ_MAP(x)                                                   \
+	(((x) & BIT_MASK_TXDMA_BEQ_MAP) << BIT_SHIFT_TXDMA_BEQ_MAP)
+#define BIT_SHIFT_TXDMA_BKQ_MAP	10
+#define BIT_MASK_TXDMA_BKQ_MAP	0x3
+#define BIT_TXDMA_BKQ_MAP(x)                                                   \
+	(((x) & BIT_MASK_TXDMA_BKQ_MAP) << BIT_SHIFT_TXDMA_BKQ_MAP)
+#define BIT_SHIFT_TXDMA_MGQ_MAP	12
+#define BIT_MASK_TXDMA_MGQ_MAP	0x3
+#define BIT_TXDMA_MGQ_MAP(x)                                                   \
+	(((x) & BIT_MASK_TXDMA_MGQ_MAP) << BIT_SHIFT_TXDMA_MGQ_MAP)
+#define BIT_SHIFT_TXDMA_HIQ_MAP	14
+#define BIT_MASK_TXDMA_HIQ_MAP	0x3
+#define BIT_TXDMA_HIQ_MAP(x)                                                   \
+	(((x) & BIT_MASK_TXDMA_HIQ_MAP) << BIT_SHIFT_TXDMA_HIQ_MAP)
+#define BIT_SHIFT_TXSC_40M	4
+#define BIT_MASK_TXSC_40M	0xf
+#define BIT_TXSC_40M(x)							       \
+	(((x) & BIT_MASK_TXSC_40M) << BIT_SHIFT_TXSC_40M)
+#define BIT_SHIFT_TXSC_20M	0
+#define BIT_MASK_TXSC_20M	0xf
+#define BIT_TXSC_20M(x)							       \
+	(((x) & BIT_MASK_TXSC_20M) << BIT_SHIFT_TXSC_20M)
+#define BIT_SHIFT_MAC_CLK_SEL	20
+#define MAC_CLK_HW_DEF_80M	0
+#define MAC_CLK_HW_DEF_40M	1
+#define MAC_CLK_HW_DEF_20M	2
+#define MAC_CLK_SPEED		80
+
+#define REG_CR			0x0100
+#define REG_TRXFF_BNDY		0x0114
+#define REG_RXFF_BNDY		0x011C
+#define REG_PKTBUF_DBG_CTRL	0x0140
+#define REG_C2HEVT		0x01A0
+#define REG_HMETFR		0x01CC
+#define REG_HMEBOX0		0x01D0
+#define REG_HMEBOX1		0x01D4
+#define REG_HMEBOX2		0x01D8
+#define REG_HMEBOX3		0x01DC
+#define REG_HMEBOX0_EX		0x01F0
+#define REG_HMEBOX1_EX		0x01F4
+#define REG_HMEBOX2_EX		0x01F8
+#define REG_HMEBOX3_EX		0x01FC
+
+#define REG_FIFOPAGE_CTRL_2	0x0204
+#define BIT_BCN_VALID_V1	BIT(15)
+#define BIT_MASK_BCN_HEAD_1_V1	0xfff
+#define REG_AUTO_LLT_V1		0x0208
+#define BIT_AUTO_INIT_LLT_V1	BIT(0)
+#define REG_TXDMA_OFFSET_CHK	0x020C
+#define REG_TXDMA_STATUS	0x0210
+#define BTI_PAGE_OVF		BIT(2)
+#define REG_RQPN_CTRL_1		0x0228
+#define REG_RQPN_CTRL_2		0x022C
+#define BIT_LD_RQPN		BIT(31)
+#define REG_FIFOPAGE_INFO_1	0x0230
+#define REG_FIFOPAGE_INFO_2	0x0234
+#define REG_FIFOPAGE_INFO_3	0x0238
+#define REG_FIFOPAGE_INFO_4	0x023C
+#define REG_FIFOPAGE_INFO_5	0x0240
+#define REG_H2C_HEAD		0x0244
+#define REG_H2C_TAIL		0x0248
+#define REG_H2C_READ_ADDR	0x024C
+#define REG_H2C_INFO		0x0254
+
+#define REG_FWHW_TXQ_CTRL	0x0420
+#define BIT_EN_WR_FREE_TAIL	BIT(20)
+#define REG_BCNQ_BDNY_V1	0x0424
+#define REG_LIFETIME_EN		0x0426
+#define BIT_BA_PARSER_EN	BIT(5)
+#define REG_SPEC_SIFS		0x0428
+#define REG_DARFRC		0x0430
+#define REG_DARFRCH		0x0434
+#define REG_RARFRCH		0x043C
+#define REG_ARFR0		0x0444
+#define REG_ARFRH0		0x0448
+#define REG_ARFR1_V1		0x044C
+#define REG_ARFRH1_V1		0x0450
+#define REG_CCK_CHECK		0x0454
+#define BIT_CHECK_CCK_EN	BIT(7)
+#define REG_AMPDU_MAX_TIME_V1	0x0455
+#define REG_BCNQ1_BDNY_V1	0x0456
+#define REG_TX_HANG_CTRL	0x045E
+#define BIT_EN_EOF_V1		BIT(2)
+#define REG_DATA_SC		0x0483
+#define REG_ARFR4		0x049C
+#define REG_ARFRH4		0x04A0
+#define REG_ARFR5		0x04A4
+#define REG_ARFRH5		0x04A8
+#define REG_SW_AMPDU_BURST_MODE_CTRL 0x04BC
+#define BIT_PRE_TX_CMD		BIT(6)
+#define REG_PROT_MODE_CTRL	0x04C8
+#define REG_BAR_MODE_CTRL	0x04CC
+#define REG_PRECNT_CTRL		0x04E5
+#define BIT_EN_PRECNT		BIT(11)
+
+#define REG_EDCA_VO_PARAM	0x0500
+#define REG_EDCA_VI_PARAM	0x0504
+#define REG_EDCA_BE_PARAM	0x0508
+#define REG_EDCA_BK_PARAM	0x050C
+#define REG_PIFS		0x0512
+#define REG_SIFS		0x0514
+#define BIT_SHIFT_SIFS_OFDM_CTX	8
+#define BIT_SHIFT_SIFS_CCK_TRX	16
+#define BIT_SHIFT_SIFS_OFDM_TRX	24
+#define REG_SLOT		0x051B
+#define REG_TX_PTCL_CTRL	0x0520
+#define BIT_SIFS_BK_EN		BIT(12)
+#define REG_TXPAUSE		0x0522
+#define REG_RD_CTRL		0x0524
+#define BIT_DIS_TXOP_CFE	BIT(10)
+#define BIT_DIS_LSIG_CFE	BIT(9)
+#define BIT_DIS_STBC_CFE	BIT(8)
+#define REG_TBTT_PROHIBIT	0x0540
+#define BIT_SHIFT_TBTT_HOLD_TIME_AP 8
+#define REG_RD_NAV_NXT		0x0544
+#define REG_BCN_CTRL		0x0550
+#define BIT_DIS_TSF_UDT		BIT(4)
+#define BIT_EN_BCN_FUNCTION	BIT(3)
+#define REG_BCN_CTRL_CLINT0	0x0551
+#define REG_DRVERLYINT		0x0558
+#define REG_BCNDMATIM		0x0559
+#define REG_USTIME_TSF		0x055C
+#define REG_BCN_MAX_ERR		0x055D
+#define REG_RXTSF_OFFSET_CCK	0x055E
+#define REG_MISC_CTRL		0x0577
+#define BIT_EN_FREE_CNT		BIT(3)
+#define BIT_DIS_SECOND_CCA	(BIT(0) | BIT(1))
+#define REG_TIMER0_SRC_SEL	0x05B4
+#define BIT_TSFT_SEL_TIMER0	(BIT(4) | BIT(5) | BIT(6))
+
+#define REG_TCR			0x0604
+#define REG_RCR			0x0608
+#define BIT_APP_FCS		BIT(31)
+#define BIT_APP_MIC		BIT(30)
+#define BIT_APP_ICV		BIT(29)
+#define BIT_APP_PHYSTS		BIT(28)
+#define BIT_APP_BASSN		BIT(27)
+#define BIT_VHT_DACK		BIT(26)
+#define BIT_TCPOFLD_EN		BIT(25)
+#define BIT_ENMBID		BIT(24)
+#define BIT_LSIGEN		BIT(23)
+#define BIT_MFBEN		BIT(22)
+#define BIT_DISCHKPPDLLEN	BIT(21)
+#define BIT_PKTCTL_DLEN		BIT(20)
+#define BIT_TIM_PARSER_EN	BIT(18)
+#define BIT_BC_MD_EN		BIT(17)
+#define BIT_UC_MD_EN		BIT(16)
+#define BIT_RXSK_PERPKT		BIT(15)
+#define BIT_HTC_LOC_CTRL	BIT(14)
+#define BIT_RPFM_CAM_ENABLE	BIT(12)
+#define BIT_TA_BCN		BIT(11)
+#define BIT_DISDECMYPKT		BIT(10)
+#define BIT_AICV		BIT(9)
+#define BIT_ACRC32		BIT(8)
+#define BIT_CBSSID_BCN		BIT(7)
+#define BIT_CBSSID_DATA		BIT(6)
+#define BIT_APWRMGT		BIT(5)
+#define BIT_ADD3		BIT(4)
+#define BIT_AB			BIT(3)
+#define BIT_AM			BIT(2)
+#define BIT_APM			BIT(1)
+#define BIT_AAP			BIT(0)
+#define REG_RX_PKT_LIMIT	0x060C
+#define REG_RX_DRVINFO_SZ	0x060F
+#define BIT_APP_PHYSTS		BIT(28)
+#define REG_USTIME_EDCA		0x0638
+#define REG_RESP_SIFS_CCK	0x063C
+#define REG_RESP_SIFS_OFDM	0x063E
+#define REG_ACKTO		0x0640
+#define REG_EIFS		0x0642
+#define REG_NAV_CTRL		0x0650
+#define REG_WMAC_TRXPTCL_CTL	0x0668
+#define BIT_RFMOD		(BIT(7) | BIT(8))
+#define BIT_RFMOD_80M		BIT(7)
+#define BIT_RFMOD_40M		BIT(8)
+#define REG_WMAC_TRXPTCL_CTL_H	0x066C
+#define REG_RXFLTMAP0		0x06A0
+#define REG_RXFLTMAP1		0x06A2
+#define REG_RXFLTMAP2		0x06A4
+#define REG_BBPSF_CTRL		0x06DC
+
+#define REG_WMAC_OPTION_FUNCTION 0x07D0
+#define REG_WMAC_OPTION_FUNCTION_1 0x07D4
+
+#define REG_CPU_DMEM_CON	0x1080
+#define BIT_WL_PLATFORM_RST	BIT(16)
+#define BIT_WL_SECURITY_CLK	BIT(15)
+#define BIT_DDMA_EN		BIT(8)
+
+#define REG_H2C_PKT_READADDR	0x10D0
+#define REG_H2C_PKT_WRITEADDR	0x10D4
+#define REG_FW_DBG7		0x10FC
+#define FW_KEY_MASK		0xffffff00
+
+#define REG_CR_EXT		0x1100
+
+#define REG_DDMA_CH0SA		0x1200
+#define REG_DDMA_CH0DA		0x1204
+#define REG_DDMA_CH0CTRL	0x1208
+#define BIT_DDMACH0_OWN		BIT(31)
+#define BIT_DDMACH0_CHKSUM_EN	BIT(29)
+#define BIT_DDMACH0_CHKSUM_STS	BIT(27)
+#define BIT_DDMACH0_RESET_CHKSUM_STS BIT(25)
+#define BIT_DDMACH0_CHKSUM_CONT	BIT(24)
+#define BIT_MASK_DDMACH0_DLEN	0x3ffff
+
+#define REG_H2CQ_CSR		0x1330
+#define BIT_H2CQ_FULL		BIT(31)
+#define REG_FAST_EDCA_VOVI_SETTING 0x1448
+#define REG_FAST_EDCA_BEBK_SETTING 0x144C
+
+#define REG_RXPSF_CTRL		0x1610
+#define BIT_RXGCK_FIFOTHR_EN	BIT(28)
+
+#define BIT_SHIFT_RXGCK_VHT_FIFOTHR 26
+#define BIT_MASK_RXGCK_VHT_FIFOTHR 0x3
+#define BIT_RXGCK_VHT_FIFOTHR(x)                                               \
+	(((x) & BIT_MASK_RXGCK_VHT_FIFOTHR) << BIT_SHIFT_RXGCK_VHT_FIFOTHR)
+#define BITS_RXGCK_VHT_FIFOTHR                                                 \
+	(BIT_MASK_RXGCK_VHT_FIFOTHR << BIT_SHIFT_RXGCK_VHT_FIFOTHR)
+
+#define BIT_SHIFT_RXGCK_HT_FIFOTHR 24
+#define BIT_MASK_RXGCK_HT_FIFOTHR 0x3
+#define BIT_RXGCK_HT_FIFOTHR(x)                                                \
+	(((x) & BIT_MASK_RXGCK_HT_FIFOTHR) << BIT_SHIFT_RXGCK_HT_FIFOTHR)
+#define BITS_RXGCK_HT_FIFOTHR                                                  \
+	(BIT_MASK_RXGCK_HT_FIFOTHR << BIT_SHIFT_RXGCK_HT_FIFOTHR)
+
+#define BIT_SHIFT_RXGCK_OFDM_FIFOTHR 22
+#define BIT_MASK_RXGCK_OFDM_FIFOTHR 0x3
+#define BIT_RXGCK_OFDM_FIFOTHR(x)                                              \
+	(((x) & BIT_MASK_RXGCK_OFDM_FIFOTHR) << BIT_SHIFT_RXGCK_OFDM_FIFOTHR)
+#define BITS_RXGCK_OFDM_FIFOTHR                                                \
+	(BIT_MASK_RXGCK_OFDM_FIFOTHR << BIT_SHIFT_RXGCK_OFDM_FIFOTHR)
+
+#define BIT_SHIFT_RXGCK_CCK_FIFOTHR 20
+#define BIT_MASK_RXGCK_CCK_FIFOTHR 0x3
+#define BIT_RXGCK_CCK_FIFOTHR(x)                                               \
+	(((x) & BIT_MASK_RXGCK_CCK_FIFOTHR) << BIT_SHIFT_RXGCK_CCK_FIFOTHR)
+#define BITS_RXGCK_CCK_FIFOTHR                                                 \
+	(BIT_MASK_RXGCK_CCK_FIFOTHR << BIT_SHIFT_RXGCK_CCK_FIFOTHR)
+
+#define BIT_RXGCK_OFDMCCA_EN BIT(16)
+
+#define BIT_SHIFT_RXPSF_PKTLENTHR 13
+#define BIT_MASK_RXPSF_PKTLENTHR 0x7
+#define BIT_RXPSF_PKTLENTHR(x)                                                 \
+	(((x) & BIT_MASK_RXPSF_PKTLENTHR) << BIT_SHIFT_RXPSF_PKTLENTHR)
+#define BITS_RXPSF_PKTLENTHR                                                   \
+	(BIT_MASK_RXPSF_PKTLENTHR << BIT_SHIFT_RXPSF_PKTLENTHR)
+#define BIT_CLEAR_RXPSF_PKTLENTHR(x) ((x) & (~BITS_RXPSF_PKTLENTHR))
+#define BIT_SET_RXPSF_PKTLENTHR(x, v)                                          \
+	(BIT_CLEAR_RXPSF_PKTLENTHR(x) | BIT_RXPSF_PKTLENTHR(v))
+
+#define BIT_RXPSF_CTRLEN	BIT(12)
+#define BIT_RXPSF_VHTCHKEN	BIT(11)
+#define BIT_RXPSF_HTCHKEN	BIT(10)
+#define BIT_RXPSF_OFDMCHKEN	BIT(9)
+#define BIT_RXPSF_CCKCHKEN	BIT(8)
+#define BIT_RXPSF_OFDMRST	BIT(7)
+#define BIT_RXPSF_CCKRST	BIT(6)
+#define BIT_RXPSF_MHCHKEN	BIT(5)
+#define BIT_RXPSF_CONT_ERRCHKEN	BIT(4)
+#define BIT_RXPSF_ALL_ERRCHKEN	BIT(3)
+
+#define BIT_SHIFT_RXPSF_ERRTHR 0
+#define BIT_MASK_RXPSF_ERRTHR 0x7
+#define BIT_RXPSF_ERRTHR(x)                                                    \
+	(((x) & BIT_MASK_RXPSF_ERRTHR) << BIT_SHIFT_RXPSF_ERRTHR)
+#define BITS_RXPSF_ERRTHR (BIT_MASK_RXPSF_ERRTHR << BIT_SHIFT_RXPSF_ERRTHR)
+#define BIT_CLEAR_RXPSF_ERRTHR(x) ((x) & (~BITS_RXPSF_ERRTHR))
+#define BIT_GET_RXPSF_ERRTHR(x)                                                \
+	(((x) >> BIT_SHIFT_RXPSF_ERRTHR) & BIT_MASK_RXPSF_ERRTHR)
+#define BIT_SET_RXPSF_ERRTHR(x, v)                                             \
+	(BIT_CLEAR_RXPSF_ERRTHR(x) | BIT_RXPSF_ERRTHR(v))
+
+#define REG_RXPSF_TYPE_CTRL	0x1614
+
+#define REG_WL2LTECOEX_INDIRECT_ACCESS_CTRL_V1		0x1700
+#define REG_WL2LTECOEX_INDIRECT_ACCESS_WRITE_DATA_V1	0x1704
+#define REG_WL2LTECOEX_INDIRECT_ACCESS_READ_DATA_V1	0x1708
+#define LTECOEX_READY		BIT(29)
+#define LTECOEX_ACCESS_CTRL REG_WL2LTECOEX_INDIRECT_ACCESS_CTRL_V1
+#define LTECOEX_WRITE_DATA REG_WL2LTECOEX_INDIRECT_ACCESS_WRITE_DATA_V1
+#define LTECOEX_READ_DATA REG_WL2LTECOEX_INDIRECT_ACCESS_READ_DATA_V1
+
+#define RF_DTXLOK	0x08
+#define RF_CFGCH	0x18
+#define RF_LUTWA	0x33
+#define RF_LUTWD1	0x3e
+#define RF_LUTWD0	0x3f
+#define RF_XTALX2	0xb8
+#define RF_MALSEL	0xbe
+#define RF_LUTDBG	0xdf
+#define RF_LUTWE	0xef
+
+#endif
-- 
2.7.4

