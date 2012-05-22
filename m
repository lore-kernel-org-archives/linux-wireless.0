Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5788 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2EVHx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 03:53:27 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3] ath6kl: Add support for setting tx rateset.
Date: Tue, 22 May 2012 13:23:12 +0530
Message-ID: <1337673192-3469-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120522_095332_581744_84D98875)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tx legacy and mcs rateset can configured using iw for
2.4 and 5 bands.  Add support for the same in driver.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
v2 : Incorporate Kalli comments
v3 : Fix indentation issues
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   25 +++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +
 drivers/net/wireless/ath/ath6kl/init.c     |    5 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |  109 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   32 ++++++++
 5 files changed, 173 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 7845d33..c648539 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3320,6 +3320,19 @@ static int ath6kl_cfg80211_sscan_stop(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ath6kl_cfg80211_set_bitrate_mask(
+				struct wiphy *wiphy,
+				struct net_device *dev,
+				const u8 *addr,
+				const struct cfg80211_bitrate_mask *mask)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
+
+	return ath6kl_wmi_set_bitrate_mask(ar->wmi, vif->fw_vif_idx,
+					   mask);
+}
+
 static const struct ieee80211_txrx_stypes
 ath6kl_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	[NL80211_IFTYPE_STATION] = {
@@ -3386,6 +3399,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.mgmt_frame_register = ath6kl_mgmt_frame_register,
 	.sched_scan_start = ath6kl_cfg80211_sscan_start,
 	.sched_scan_stop = ath6kl_cfg80211_sscan_stop,
+	.set_bitrate_mask = ath6kl_cfg80211_set_bitrate_mask,
 };
 
 void ath6kl_cfg80211_stop(struct ath6kl_vif *vif)
@@ -3616,6 +3630,17 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 		ath6kl_band_5ghz.ht_cap.cap = 0;
 		ath6kl_band_5ghz.ht_cap.ht_supported = false;
 	}
+
+	if (ar->hw.flags & ATH6KL_64BIT_BITRATES) {
+		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
+		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[0] = 0xff;
+		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[1] = 0xff;
+		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[1] = 0xff;
+	} else {
+		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
+		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[0] = 0xff;
+	}
+
 	if (band_2gig)
 		wiphy->bands[IEEE80211_BAND_2GHZ] = &ath6kl_band_2ghz;
 	if (band_5gig)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 991bd96..d944b98 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -701,6 +701,8 @@ struct ath6kl {
 		u32 uarttx_pin;
 		u32 testscript_addr;
 		enum wmi_phy_cap cap;
+#define ATH6KL_64BIT_BITRATES 1
+		u32 flags;
 
 		struct ath6kl_hw_fw {
 			const char *dir;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 10de132..96205f3 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -42,6 +42,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.reserved_ram_size		= 6912,
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 8,
+		.flags				= 0,
 
 		/* hw2.0 needs override address hardcoded */
 		.app_start_override_addr	= 0x944C00,
@@ -67,6 +68,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 8,
 		.testscript_addr		= 0x57ef74,
+		.flags				= 0,
 
 		.fw = {
 			.dir		= AR6003_HW_2_1_1_FW_DIR,
@@ -91,6 +93,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x433900,
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 11,
+		.flags				= ATH6KL_64BIT_BITRATES,
 
 		.fw = {
 			.dir		= AR6004_HW_1_0_FW_DIR,
@@ -110,6 +113,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x43d400,
 		.refclk_hz			= 40000000,
 		.uarttx_pin			= 11,
+		.flags				= ATH6KL_64BIT_BITRATES,
 
 		.fw = {
 			.dir		= AR6004_HW_1_1_FW_DIR,
@@ -129,6 +133,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x435c00,
 		.refclk_hz			= 40000000,
 		.uarttx_pin			= 11,
+		.flags				= ATH6KL_64BIT_BITRATES,
 
 		.fw = {
 			.dir		= AR6004_HW_1_2_FW_DIR,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 6ad762d..552874f 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2599,6 +2599,115 @@ static void ath6kl_wmi_relinquish_implicit_pstream_credits(struct wmi *wmi)
 	spin_unlock_bh(&wmi->lock);
 }
 
+static int ath6kl_set_bitrate_mask64(struct wmi *wmi, u8 if_idx,
+				     const struct cfg80211_bitrate_mask *mask)
+{
+	struct sk_buff *skb;
+	int ret, mode, band;
+	u64 mcsrate, ratemask[IEEE80211_NUM_BANDS];
+	struct wmi_set_tx_select_rates64_cmd *cmd;
+
+	memset(&ratemask, 0, sizeof(ratemask));
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		/* copy legacy rate mask */
+		ratemask[band] = mask->control[band].legacy;
+		if (band == IEEE80211_BAND_5GHZ)
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
+		   "Ratemask 64 bit: 2.4:%llx 5:%llx\n",
+		   ratemask[0], ratemask[1]);
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd) * WMI_RATES_MODE_MAX);
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_set_tx_select_rates64_cmd *) skb->data;
+	for (mode = 0; mode < WMI_RATES_MODE_MAX; mode++) {
+		/* A mode operate in 5GHZ band */
+		if (mode == WMI_RATES_MODE_11A ||
+		    mode == WMI_RATES_MODE_11A_HT20 ||
+		    mode == WMI_RATES_MODE_11A_HT40)
+			band = IEEE80211_BAND_5GHZ;
+		else
+			band = IEEE80211_BAND_2GHZ;
+		cmd->ratemask[mode] = cpu_to_le64(ratemask[band]);
+	}
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				  WMI_SET_TX_SELECT_RATES_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
+static int ath6kl_set_bitrate_mask32(struct wmi *wmi, u8 if_idx,
+				     const struct cfg80211_bitrate_mask *mask)
+{
+	struct sk_buff *skb;
+	int ret, mode, band;
+	u32 mcsrate, ratemask[IEEE80211_NUM_BANDS];
+	struct wmi_set_tx_select_rates32_cmd *cmd;
+
+	memset(&ratemask, 0, sizeof(ratemask));
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		/* copy legacy rate mask */
+		ratemask[band] = mask->control[band].legacy;
+		if (band == IEEE80211_BAND_5GHZ)
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
+		   "Ratemask 32 bit: 2.4:%x 5:%x\n",
+		   ratemask[0], ratemask[1]);
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd) * WMI_RATES_MODE_MAX);
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_set_tx_select_rates32_cmd *) skb->data;
+	for (mode = 0; mode < WMI_RATES_MODE_MAX; mode++) {
+		/* A mode operate in 5GHZ band */
+		if (mode == WMI_RATES_MODE_11A ||
+		    mode == WMI_RATES_MODE_11A_HT20 ||
+		    mode == WMI_RATES_MODE_11A_HT40)
+			band = IEEE80211_BAND_5GHZ;
+		else
+			band = IEEE80211_BAND_2GHZ;
+		cmd->ratemask[mode] = cpu_to_le32(ratemask[band]);
+	}
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				  WMI_SET_TX_SELECT_RATES_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
+int ath6kl_wmi_set_bitrate_mask(struct wmi *wmi, u8 if_idx,
+				const struct cfg80211_bitrate_mask *mask)
+{
+	struct ath6kl *ar = wmi->parent_dev;
+
+	if (ar->hw.flags & ATH6KL_64BIT_BITRATES)
+		return ath6kl_set_bitrate_mask64(wmi, if_idx, mask);
+	else
+		return ath6kl_set_bitrate_mask32(wmi, if_idx, mask);
+}
+
 int ath6kl_wmi_set_host_sleep_mode_cmd(struct wmi *wmi, u8 if_idx,
 				       enum ath6kl_host_mode host_mode)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 4775679..7c94fe3 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1063,6 +1063,36 @@ struct wmi_power_params_cmd {
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
+	WMI_RATES_MODE_11A = 0,
+	WMI_RATES_MODE_11G,
+	WMI_RATES_MODE_11B,
+	WMI_RATES_MODE_11GONLY,
+	WMI_RATES_MODE_11A_HT20,
+	WMI_RATES_MODE_11G_HT20,
+	WMI_RATES_MODE_11A_HT40,
+	WMI_RATES_MODE_11G_HT40,
+	WMI_RATES_MODE_MAX
+};
+
+/* WMI_SET_TX_SELECT_RATES_CMDID */
+struct wmi_set_tx_select_rates32_cmd {
+	__le32 ratemask[WMI_RATES_MODE_MAX];
+} __packed;
+
+/* WMI_SET_TX_SELECT_RATES_CMDID */
+struct wmi_set_tx_select_rates64_cmd {
+	__le64 ratemask[WMI_RATES_MODE_MAX];
+} __packed;
+
 /* WMI_SET_DISC_TIMEOUT_CMDID */
 struct wmi_disc_timeout_cmd {
 	/* seconds */
@@ -2547,6 +2577,8 @@ int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, u8 if_idx,
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

