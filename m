Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52762 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1JYKKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:10:33 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 02/34] ath6kl: Keep wiphy reference in ath6kl structure
Date: Tue, 25 Oct 2011 15:39:58 +0530
Message-ID: <1319537430-12459-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121036_353496_EBFC35C6)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to avoid using ar->wdev to get wiphy pointer, this
may need further cleanup for multi vif support.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   50 ++++++++++++++--------------
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 drivers/net/wireless/ath/ath6kl/debug.c    |    2 +-
 drivers/net/wireless/ath/ath6kl/init.c     |    6 ++--
 drivers/net/wireless/ath/ath6kl/main.c     |    8 ++--
 drivers/net/wireless/ath/ath6kl/wmi.c      |   10 +++---
 6 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0680d2b..16c21a4 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -481,7 +481,7 @@ static int ath6kl_add_bss_if_needed(struct ath6kl *ar, const u8 *bssid,
 	struct cfg80211_bss *bss;
 	u8 *ie;
 
-	bss = cfg80211_get_bss(ar->wdev->wiphy, chan, bssid,
+	bss = cfg80211_get_bss(ar->wiphy, chan, bssid,
 			       ar->ssid, ar->ssid_len, WLAN_CAPABILITY_ESS,
 			       WLAN_CAPABILITY_ESS);
 	if (bss == NULL) {
@@ -500,7 +500,7 @@ static int ath6kl_add_bss_if_needed(struct ath6kl *ar, const u8 *bssid,
 		ie[1] = ar->ssid_len;
 		memcpy(ie + 2, ar->ssid, ar->ssid_len);
 		memcpy(ie + 2 + ar->ssid_len, beacon_ie, beacon_ie_len);
-		bss = cfg80211_inform_bss(ar->wdev->wiphy, chan,
+		bss = cfg80211_inform_bss(ar->wiphy, chan,
 					  bssid, 0, WLAN_CAPABILITY_ESS, 100,
 					  ie, 2 + ar->ssid_len + beacon_ie_len,
 					  0, GFP_KERNEL);
@@ -567,7 +567,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 		}
 	}
 
-	chan = ieee80211_get_channel(ar->wdev->wiphy, (int) channel);
+	chan = ieee80211_get_channel(ar->wiphy, (int) channel);
 
 
 	if (nw_type & ADHOC_NETWORK) {
@@ -1923,6 +1923,7 @@ struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
 	int ret = 0;
 	struct wireless_dev *wdev;
 	struct ath6kl *ar;
+	struct wiphy *wiphy;
 
 	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
 	if (!wdev) {
@@ -1931,43 +1932,45 @@ struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
 	}
 
 	/* create a new wiphy for use with cfg80211 */
-	wdev->wiphy = wiphy_new(&ath6kl_cfg80211_ops, sizeof(struct ath6kl));
-	if (!wdev->wiphy) {
+	wiphy = wiphy_new(&ath6kl_cfg80211_ops, sizeof(struct ath6kl));
+	if (!wiphy) {
 		ath6kl_err("couldn't allocate wiphy device\n");
 		kfree(wdev);
 		return NULL;
 	}
 
-	ar = wiphy_priv(wdev->wiphy);
+	ar = wiphy_priv(wiphy);
 	ar->p2p = !!ath6kl_p2p;
+	ar->wiphy = wiphy;
+	wdev->wiphy = wiphy;
 
-	wdev->wiphy->mgmt_stypes = ath6kl_mgmt_stypes;
+	wiphy->mgmt_stypes = ath6kl_mgmt_stypes;
 
-	wdev->wiphy->max_remain_on_channel_duration = 5000;
+	wiphy->max_remain_on_channel_duration = 5000;
 
 	/* set device pointer for wiphy */
-	set_wiphy_dev(wdev->wiphy, dev);
+	set_wiphy_dev(wiphy, dev);
 
-	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
 	if (ar->p2p) {
-		wdev->wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_GO) |
+		wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_GO) |
 			BIT(NL80211_IFTYPE_P2P_CLIENT);
 	}
 	/* max num of ssids that can be probed during scanning */
-	wdev->wiphy->max_scan_ssids = MAX_PROBED_SSID_INDEX;
-	wdev->wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
-	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &ath6kl_band_2ghz;
-	wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = &ath6kl_band_5ghz;
-	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	wiphy->max_scan_ssids = MAX_PROBED_SSID_INDEX;
+	wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
+	wiphy->bands[IEEE80211_BAND_2GHZ] = &ath6kl_band_2ghz;
+	wiphy->bands[IEEE80211_BAND_5GHZ] = &ath6kl_band_5ghz;
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
-	wdev->wiphy->cipher_suites = cipher_suites;
-	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
+	wiphy->cipher_suites = cipher_suites;
+	wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
-	ret = wiphy_register(wdev->wiphy);
+	ret = wiphy_register(wiphy);
 	if (ret < 0) {
 		ath6kl_err("couldn't register wiphy device\n");
-		wiphy_free(wdev->wiphy);
+		wiphy_free(wiphy);
 		kfree(wdev);
 		return NULL;
 	}
@@ -1984,10 +1987,7 @@ void ath6kl_cfg80211_deinit(struct ath6kl *ar)
 		ar->scan_req = NULL;
 	}
 
-	if (!wdev)
-		return;
-
-	wiphy_unregister(wdev->wiphy);
-	wiphy_free(wdev->wiphy);
+	wiphy_unregister(ar->wiphy);
+	wiphy_free(ar->wiphy);
 	kfree(wdev);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index ae731e0..5b76d97 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -402,6 +402,7 @@ struct ath6kl_req_key {
 struct ath6kl {
 	struct device *dev;
 	struct net_device *net_dev;
+	struct wiphy *wiphy;
 	struct ath6kl_bmi bmi;
 	const struct ath6kl_hif_ops *hif_ops;
 	struct wmi *wmi;
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 8b1ed2d..ff02b00 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1566,7 +1566,7 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	ar->debug.fwlog_mask = 0;
 
 	ar->debugfs_phy = debugfs_create_dir("ath6kl",
-					     ar->wdev->wiphy->debugfsdir);
+					     ar->wiphy->debugfsdir);
 	if (!ar->debugfs_phy) {
 		vfree(ar->debug.fwlog_buf.buf);
 		kfree(ar->debug.fwlog_tmp);
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 34f8b78..d22e796 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -584,7 +584,7 @@ struct ath6kl *ath6kl_core_alloc(struct device *sdev)
 	}
 
 	dev->ieee80211_ptr = wdev;
-	SET_NETDEV_DEV(dev, wiphy_dev(wdev->wiphy));
+	SET_NETDEV_DEV(dev, wiphy_dev(ar->wiphy));
 	wdev->netdev = dev;
 	ar->sme_state = SME_DISCONNECTED;
 
@@ -1557,7 +1557,7 @@ static int ath6kl_init(struct ath6kl *ar)
 	ar->conf_flags = ATH6KL_CONF_IGNORE_ERP_BARKER |
 			 ATH6KL_CONF_ENABLE_11N | ATH6KL_CONF_ENABLE_TX_BURST;
 
-	ar->wdev->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
+	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
 
 	status = ath6kl_target_config_wlan_params(ar);
 	if (!status)
@@ -1598,7 +1598,7 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 	ar->version.target_ver = le32_to_cpu(targ_info.version);
 	ar->target_type = le32_to_cpu(targ_info.type);
-	ar->wdev->wiphy->hw_version = le32_to_cpu(targ_info.version);
+	ar->wiphy->hw_version = le32_to_cpu(targ_info.version);
 
 	ret = ath6kl_init_hw_params(ar);
 	if (ret)
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 9db86e3..1eca4e8 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -715,8 +715,8 @@ void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
 	ar->version.wlan_ver = sw_ver;
 	ar->version.abi_ver = abi_ver;
 
-	snprintf(ar->wdev->wiphy->fw_version,
-		 sizeof(ar->wdev->wiphy->fw_version),
+	snprintf(ar->wiphy->fw_version,
+		 sizeof(ar->wiphy->fw_version),
 		 "%u.%u.%u.%u",
 		 (ar->version.wlan_ver & 0xf0000000) >> 28,
 		 (ar->version.wlan_ver & 0x0f000000) >> 24,
@@ -728,8 +728,8 @@ void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
 	wake_up(&ar->event_wq);
 
 	ath6kl_info("hw %s fw %s%s\n",
-		    get_hw_id_string(ar->wdev->wiphy->hw_version),
-		    ar->wdev->wiphy->fw_version,
+		    get_hw_id_string(ar->wiphy->hw_version),
+		    ar->wiphy->fw_version,
 		    test_bit(TESTMODE, &ar->flag) ? " testmode" : "");
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 7b6bfdd..7f4c2c2 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -431,7 +431,7 @@ static int ath6kl_wmi_remain_on_chnl_event_rx(struct wmi *wmi, u8 *datap,
 	dur = le32_to_cpu(ev->duration);
 	ath6kl_dbg(ATH6KL_DBG_WMI, "remain_on_chnl: freq=%u dur=%u\n",
 		   freq, dur);
-	chan = ieee80211_get_channel(ar->wdev->wiphy, freq);
+	chan = ieee80211_get_channel(ar->wiphy, freq);
 	if (!chan) {
 		ath6kl_dbg(ATH6KL_DBG_WMI, "remain_on_chnl: Unknown channel "
 			   "(freq=%u)\n", freq);
@@ -460,7 +460,7 @@ static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(struct wmi *wmi,
 	dur = le32_to_cpu(ev->duration);
 	ath6kl_dbg(ATH6KL_DBG_WMI, "cancel_remain_on_chnl: freq=%u dur=%u "
 		   "status=%u\n", freq, dur, ev->status);
-	chan = ieee80211_get_channel(ar->wdev->wiphy, freq);
+	chan = ieee80211_get_channel(ar->wiphy, freq);
 	if (!chan) {
 		ath6kl_dbg(ATH6KL_DBG_WMI, "cancel_remain_on_chnl: Unknown "
 			   "channel (freq=%u)\n", freq);
@@ -878,7 +878,7 @@ static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
 		alpha2[0] = country->isoName[0];
 		alpha2[1] = country->isoName[1];
 
-		regulatory_hint(wmi->parent_dev->wdev->wiphy, alpha2);
+		regulatory_hint(wmi->parent_dev->wiphy, alpha2);
 
 		ath6kl_dbg(ATH6KL_DBG_WMI, "Country alpha2 being used: %c%c\n",
 				alpha2[0], alpha2[1]);
@@ -974,7 +974,7 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 		ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
 	}
 
-	channel = ieee80211_get_channel(ar->wdev->wiphy, le16_to_cpu(bih->ch));
+	channel = ieee80211_get_channel(ar->wiphy, le16_to_cpu(bih->ch));
 	if (channel == NULL)
 		return -EINVAL;
 
@@ -1021,7 +1021,7 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 
 	memcpy(&mgmt->u.beacon, buf, len);
 
-	bss = cfg80211_inform_bss_frame(ar->wdev->wiphy, channel, mgmt,
+	bss = cfg80211_inform_bss_frame(ar->wiphy, channel, mgmt,
 					24 + len, (bih->snr - 95) * 100,
 					GFP_ATOMIC);
 	kfree(mgmt);
-- 
1.7.0.4

