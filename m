Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14737 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970Ab2EJJ6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:58:12 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Add support for setting tx rateset.
Date: Thu, 10 May 2012 15:28:04 +0530
Message-ID: <1336643884-5947-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120510_115815_927138_D5EC7AF1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tx legacy and mcs rateset can configured using iw for
2.4 and 5 bands.  Add support for the same in driver.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   27 +++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    6 ++
 drivers/net/wireless/ath/ath6kl/init.c     |    4 +
 drivers/net/wireless/ath/ath6kl/wmi.c      |  114 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   22 ++++++
 5 files changed, 173 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b869a35..bf31e63 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3217,6 +3217,21 @@ static int ath6kl_cfg80211_sscan_stop(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ath6kl_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
+				      struct net_device *dev,
+				      const u8 *addr,
+				      const struct cfg80211_bitrate_mask *mask)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
+	int ret;
+
+	ret = ath6kl_wmi_set_bitrate_mask(ar->wmi, vif->fw_vif_idx,
+				mask);
+
+	return ret;
+}
+
 static const struct ieee80211_txrx_stypes
 ath6kl_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	[NL80211_IFTYPE_STATION] = {
@@ -3283,6 +3298,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.mgmt_frame_register = ath6kl_mgmt_frame_register,
 	.sched_scan_start = ath6kl_cfg80211_sscan_start,
 	.sched_scan_stop = ath6kl_cfg80211_sscan_stop,
+	.set_bitrate_mask = ath6kl_cfg80211_set_bitrate_mask,
 };
 
 void ath6kl_cfg80211_stop(struct ath6kl_vif *vif)
@@ -3507,6 +3523,17 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 		ath6kl_band_5ghz.ht_cap.cap = 0;
 		ath6kl_band_5ghz.ht_cap.ht_supported = false;
 	}
+
+	if (ar->hw.bitrate == ATH6KL_32BIT_BITRATES) {
+		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
+		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[0] = 0xff;
+	} else if (ar->hw.bitrate == ATH6KL_64BIT_BITRATES) {
+		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
+		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[0] = 0xff;
+		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[1] = 0xff;
+		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[1] = 0xff;
+	}
+
 	if (band_2gig)
 		wiphy->bands[IEEE80211_BAND_2GHZ] = &ath6kl_band_2ghz;
 	if (band_5gig)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 4d9c6f1..f772c86 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -596,6 +596,11 @@ enum ath6kl_state {
 	ATH6KL_STATE_SCHED_SCAN,
 };
 
+enum ath6kl_bitrate {
+	ATH6KL_32BIT_BITRATES,
+	ATH6KL_64BIT_BITRATES,
+};
+
 struct ath6kl {
 	struct device *dev;
 	struct wiphy *wiphy;
@@ -686,6 +691,7 @@ struct ath6kl {
 		u32 uarttx_pin;
 		u32 testscript_addr;
 		enum wmi_phy_cap cap;
+		enum ath6kl_bitrate bitrate;
 
 		struct ath6kl_hw_fw {
 			const char *dir;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 7eb0515..c386474 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -42,6 +42,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.reserved_ram_size		= 6912,
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 8,
+		.bitrate			= ATH6KL_32BIT_BITRATES,
 
 		/* hw2.0 needs override address hardcoded */
 		.app_start_override_addr	= 0x944C00,
@@ -67,6 +68,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 8,
 		.testscript_addr		= 0x57ef74,
+		.bitrate			= ATH6KL_32BIT_BITRATES,
 
 		.fw = {
 			.dir		= AR6003_HW_2_1_1_FW_DIR,
@@ -91,6 +93,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x433900,
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 11,
+		.bitrate			= ATH6KL_64BIT_BITRATES,
 
 		.fw = {
 			.dir		= AR6004_HW_1_0_FW_DIR,
@@ -110,6 +113,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x43d400,
 		.refclk_hz			= 40000000,
 		.uarttx_pin			= 11,
+		.bitrate			= ATH6KL_64BIT_BITRATES,
 
 		.fw = {
 			.dir		= AR6004_HW_1_1_FW_DIR,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ee8ec23..c7acdef 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2599,6 +2599,120 @@ static void ath6kl_wmi_relinquish_implicit_pstream_credits(struct wmi *wmi)
 	spin_unlock_bh(&wmi->lock);
 }
 
+static int ath6kl_set_bitrate_mask64(struct wmi *wmi, u8 if_idx,
+		       const struct cfg80211_bitrate_mask *mask)
+{
+	u64 *cmd;
+	struct sk_buff *skb;
+	int ret, mode, band;
+	u64 ratemask[IEEE80211_NUM_BANDS];
+	u64 mcsrate;
+
+	memset(&ratemask, 0, sizeof(ratemask));
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		/* copy legacy rate mask */
+		ratemask[band] = mask->control[band].legacy;
+		if  (band == IEEE80211_BAND_5GHZ)
+			ratemask[band] =
+				mask->control[band].legacy << 4;
+
+		/* copy mcs rate mask */
+		mcsrate = mask->control[band].mcs[1];
+		mcsrate <<= 8;
+		mcsrate |= mask->control[band].mcs[0];
+		ratemask[band] |= mcsrate << 12;
+		ratemask[band] |= mcsrate << 28;
+	}
+
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+			"Ratemask 64 bit: 2.4:%llx 5:%llx\n",
+			ratemask[0], ratemask[1]);
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd) * WMI_MODE_MAX);
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (u64 *) skb->data;
+
+	for (mode = 0; mode < WMI_MODE_MAX; mode++) {
+		/* A mode operate in 5GHZ band */
+		if (mode == WMI_MODE_11A || mode == WMI_MODE_11A_HT20 ||
+			mode == WMI_MODE_11A_HT40)
+			band = IEEE80211_BAND_5GHZ;
+		else
+			band = IEEE80211_BAND_2GHZ;
+		cmd[mode] = ratemask[band];
+	}
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				  WMI_SET_TX_SELECT_RATES_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
+static int ath6kl_set_bitrate_mask32(struct wmi *wmi, u8 if_idx,
+		       const struct cfg80211_bitrate_mask *mask)
+{
+	u32 *cmd;
+	struct sk_buff *skb;
+	int ret, mode, band;
+	u32 ratemask[IEEE80211_NUM_BANDS];
+	u32 mcsrate;
+
+	memset(&ratemask, 0, sizeof(ratemask));
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		/* copy legacy rate mask */
+		ratemask[band] = mask->control[band].legacy;
+		if  (band == IEEE80211_BAND_5GHZ)
+			ratemask[band] =
+				mask->control[band].legacy << 4;
+
+		/* copy mcs rate mask */
+		mcsrate = mask->control[band].mcs[0];
+		ratemask[band] |= mcsrate << 12;
+		ratemask[band] |= mcsrate << 20;
+	}
+
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+			"Ratemask 32 bit: 2.4:%x 5:%x\n",
+			ratemask[0], ratemask[1]);
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd) * WMI_MODE_MAX);
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (u32 *) skb->data;
+
+	for (mode = 0; mode < WMI_MODE_MAX; mode++) {
+		/* A mode operate in 5GHZ band */
+		if (mode == WMI_MODE_11A || mode == WMI_MODE_11A_HT20 ||
+			mode == WMI_MODE_11A_HT40)
+			band = IEEE80211_BAND_5GHZ;
+		else
+			band = IEEE80211_BAND_2GHZ;
+		cmd[mode] = ratemask[band];
+	}
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				  WMI_SET_TX_SELECT_RATES_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
+int ath6kl_wmi_set_bitrate_mask(struct wmi *wmi, u8 if_idx,
+		       const struct cfg80211_bitrate_mask *mask)
+{
+	struct ath6kl *ar = wmi->parent_dev;
+	int ret = -EINVAL;
+
+	if (ar->hw.bitrate == ATH6KL_32BIT_BITRATES)
+		ret = ath6kl_set_bitrate_mask32(wmi, if_idx, mask);
+	else if (ar->hw.bitrate == ATH6KL_64BIT_BITRATES)
+		ret = ath6kl_set_bitrate_mask64(wmi, if_idx, mask);
+
+	return ret;
+}
+
 int ath6kl_wmi_set_host_sleep_mode_cmd(struct wmi *wmi, u8 if_idx,
 				       enum ath6kl_host_mode host_mode)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 9076bec..7a235c2 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1048,6 +1048,26 @@ struct wmi_power_params_cmd {
 	__le16 ps_fail_event_policy;
 } __packed;
 
+/*
+ * Ratemask for below modes should be passed
+ * to WMI_SET_TX_SELECT_RATES_CMDID.
+ * AR6003 has 32 bit mask for each modes.
+ * First 12 bits for legacy rates, 13 to 20
+ * bits for HT 20 rates and 21 to 28 bits for
+ * HT 40 rates
+ */
+enum wmi_mode_phy {
+	WMI_MODE_11A = 0,
+	WMI_MODE_11G,
+	WMI_MODE_11B,
+	WMI_MODE_11GONLY,
+	WMI_MODE_11A_HT20,
+	WMI_MODE_11G_HT20,
+	WMI_MODE_11A_HT40,
+	WMI_MODE_11G_HT40,
+	WMI_MODE_MAX
+};
+
 /* WMI_SET_DISC_TIMEOUT_CMDID */
 struct wmi_disc_timeout_cmd {
 	/* seconds */
@@ -2532,6 +2552,8 @@ int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, u8 if_idx,
 			  __be32 ips0, __be32 ips1);
 int ath6kl_wmi_set_host_sleep_mode_cmd(struct wmi *wmi, u8 if_idx,
 				       enum ath6kl_host_mode host_mode);
+int ath6kl_wmi_set_bitrate_mask(struct wmi *wmi, u8 if_idx,
+				const struct cfg80211_bitrate_mask *mask);
 int ath6kl_wmi_set_wow_mode_cmd(struct wmi *wmi, u8 if_idx,
 				enum ath6kl_wow_mode wow_mode,
 				u32 filter, u16 host_req_delay);
-- 
1.7.4.1

