Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:58946 "HELO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751201Ab2DQEhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 00:37:07 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: corrections in timestamp related code
Date: Mon, 16 Apr 2012 21:36:52 -0700
Message-Id: <1334637412-4786-2-git-send-email-bzhao@marvell.com> (sfid-20120417_063749_746590_664D3CB8)
In-Reply-To: <1334637412-4786-1-git-send-email-bzhao@marvell.com>
References: <1334637412-4786-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We get two timing related fields for each bss from firmware in scan
results.
1) timestamp - Actual timestamp information in probe response/beacon
2) network_tsf - firmware's TSF value at the time the beacon or probe
response was received.
Both are needed while associating by firmware.

The patch takes care of following things.
1) We should pass "timestamp" to cfg80211_inform_bss(), but currently
"network_tsf" is being provided. This error is corrected here.
2) Rename "network_tsf" to "fw_tsf"
3) Make use of u64 variable instead of an array of u8/u32 to save
parsed "timestamp" information.
4) Use timestamp provided to stack in scan results using
cfg80211_inform_bss() while associating. (bss->tsf)
5) Allocate space to save fw_tsf in "priv" of cfg80211_bss
and retrieve it while associating.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |    4 ++--
 drivers/net/wireless/mwifiex/fw.h        |    2 +-
 drivers/net/wireless/mwifiex/join.c      |    6 +++---
 drivers/net/wireless/mwifiex/main.h      |    9 +++++++--
 drivers/net/wireless/mwifiex/scan.c      |   22 +++++++++++++---------
 drivers/net/wireless/mwifiex/sta_ioctl.c |    5 ++++-
 6 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 01d4d17..c78ea87 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1482,8 +1482,8 @@ int mwifiex_register_cfg80211(struct mwifiex_private *priv)
 	memcpy(wdev->wiphy->perm_addr, priv->curr_addr, ETH_ALEN);
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
-	/* Reserve space for bss band information */
-	wdev->wiphy->bss_priv_size = sizeof(u8);
+	/* Reserve space for mwifiex specific private data for BSS */
+	wdev->wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
 
 	wdev->wiphy->reg_notifier = mwifiex_reg_notifier;
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 342f799..6b15449 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -819,7 +819,7 @@ struct host_cmd_ds_txpwr_cfg {
 struct mwifiex_bcn_param {
 	u8 bssid[ETH_ALEN];
 	u8 rssi;
-	__le32 timestamp[2];
+	__le64 timestamp;
 	__le16 beacon_period;
 	__le16 cap_info_bitmap;
 } __packed;
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 5189afb..8a39098 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -118,15 +118,15 @@ mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *priv, u8 **buffer,
 	*buffer += sizeof(tsf_tlv.header);
 
 	/* TSF at the time when beacon/probe_response was received */
-	tsf_val = cpu_to_le64(bss_desc->network_tsf);
+	tsf_val = cpu_to_le64(bss_desc->fw_tsf);
 	memcpy(*buffer, &tsf_val, sizeof(tsf_val));
 	*buffer += sizeof(tsf_val);
 
-	memcpy(&tsf_val, bss_desc->time_stamp, sizeof(tsf_val));
+	tsf_val = cpu_to_le64(bss_desc->timestamp);
 
 	dev_dbg(priv->adapter->dev,
 		"info: %s: TSF offset calc: %016llx - %016llx\n",
-		__func__, tsf_val, bss_desc->network_tsf);
+		__func__, bss_desc->timestamp, bss_desc->fw_tsf);
 
 	memcpy(*buffer, &tsf_val, sizeof(tsf_val));
 	*buffer += sizeof(tsf_val);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index fa8af58..a4000f9 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -260,8 +260,8 @@ struct mwifiex_bssdescriptor {
 	 * BAND_A(0X04): 'a' band
 	 */
 	u16 bss_band;
-	u64 network_tsf;
-	u8 time_stamp[8];
+	u64 fw_tsf;
+	u64 timestamp;
 	union ieee_types_phy_param_set phy_param_set;
 	union ieee_types_ss_param_set ss_param_set;
 	u16 cap_info_bitmap;
@@ -522,6 +522,11 @@ struct cmd_ctrl_node {
 	u8 cmd_wait_q_woken;
 };
 
+struct mwifiex_bss_priv {
+	u8 band;
+	u64 fw_tsf;
+};
+
 struct mwifiex_if_ops {
 	int (*init_if) (struct mwifiex_adapter *);
 	void (*cleanup_if) (struct mwifiex_adapter *);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index f6bec2f..74f0457 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1603,14 +1603,16 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		const u8 *ie_buf;
 		size_t ie_len;
 		u16 channel = 0;
-		u64 network_tsf = 0;
+		u64 fw_tsf = 0;
 		u16 beacon_size = 0;
 		u32 curr_bcn_bytes;
 		u32 freq;
 		u16 beacon_period;
 		u16 cap_info_bitmap;
 		u8 *current_ptr;
+		u64 timestamp;
 		struct mwifiex_bcn_param *bcn_param;
+		struct mwifiex_bss_priv *bss_priv;
 
 		if (bytes_left >= sizeof(beacon_size)) {
 			/* Extract & convert beacon size from command buffer */
@@ -1654,6 +1656,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		rssi = (-rssi) * 100;		/* Convert dBm to mBm */
 		dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%d\n", rssi);
 
+		timestamp = le64_to_cpu(bcn_param->timestamp);
 		beacon_period = le16_to_cpu(bcn_param->beacon_period);
 
 		cap_info_bitmap = le16_to_cpu(bcn_param->cap_info_bitmap);
@@ -1693,14 +1696,13 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 		/*
 		 * If the TSF TLV was appended to the scan results, save this
-		 * entry's TSF value in the networkTSF field.The networkTSF is
-		 * the firmware's TSF value at the time the beacon or probe
-		 * response was received.
+		 * entry's TSF value in the fw_tsf field. It is the firmware's
+		 * TSF value at the time the beacon or probe response was
+		 * received.
 		 */
 		if (tsf_tlv)
-			memcpy(&network_tsf,
-			       &tsf_tlv->tsf_data[idx * TSF_DATA_SIZE],
-			       sizeof(network_tsf));
+			memcpy(&fw_tsf, &tsf_tlv->tsf_data[idx * TSF_DATA_SIZE],
+			       sizeof(fw_tsf));
 
 		if (channel) {
 			struct ieee80211_channel *chan;
@@ -1723,10 +1725,12 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 			if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
 				bss = cfg80211_inform_bss(priv->wdev->wiphy,
-					      chan, bssid, network_tsf,
+					      chan, bssid, timestamp,
 					      cap_info_bitmap, beacon_period,
 					      ie_buf, ie_len, rssi, GFP_KERNEL);
-				*(u8 *)bss->priv = band;
+				bss_priv = (struct mwifiex_bss_priv *)bss->priv;
+				bss_priv->band = band;
+				bss_priv->fw_tsf = fw_tsf;
 				if (priv->media_connected &&
 				    !memcmp(bssid,
 					    priv->curr_bss_params.bss_descriptor
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index f80622b..58970e0 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -160,6 +160,7 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 {
 	int ret;
 	u8 *beacon_ie;
+	struct mwifiex_bss_priv *bss_priv = (void *)bss->priv;
 
 	beacon_ie = kmemdup(bss->information_elements, bss->len_beacon_ies,
 			    GFP_KERNEL);
@@ -174,7 +175,9 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	bss_desc->beacon_buf_size = bss->len_beacon_ies;
 	bss_desc->beacon_period = bss->beacon_interval;
 	bss_desc->cap_info_bitmap = bss->capability;
-	bss_desc->bss_band = *(u8 *)bss->priv;
+	bss_desc->bss_band = bss_priv->band;
+	bss_desc->fw_tsf = bss_priv->fw_tsf;
+	bss_desc->timestamp = bss->tsf;
 	if (bss_desc->cap_info_bitmap & WLAN_CAPABILITY_PRIVACY) {
 		dev_dbg(priv->adapter->dev, "info: InterpretIE: AP WEP enabled\n");
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
-- 
1.7.0.2

