Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34870 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbaIAHbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:31:47 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 12/17] mwifiex: bring in scan channel gap feature
Date: Mon, 1 Sep 2014 18:29:00 +0530
Message-ID: <1409576345-13717-13-git-send-email-patila@marvell.com> (sfid-20140901_093150_776026_DC3FFBC4)
In-Reply-To: <1409576345-13717-1-git-send-email-patila@marvell.com>
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With scan channel gap when any station/AP is active, FW comes back
to connected channel for any pending data transfter after scanning each
channel.
We set scan channel gap TLV to FW in scan command when any of the
interface is active. This enables scan channel gap in FW.
Also when scan channel gap is enabled, we would scan maximum channels
allowed by FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |  4 ++++
 drivers/net/wireless/mwifiex/fw.h       | 10 +++++++++-
 drivers/net/wireless/mwifiex/init.c     |  1 +
 drivers/net/wireless/mwifiex/main.h     | 22 ++++++++++++++++++++++
 drivers/net/wireless/mwifiex/scan.c     | 17 +++++++++++++++++
 5 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 320512f..654fc27 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1990,6 +1990,10 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 		user_scan_cfg->chan_list[i].scan_time = 0;
 	}
 
+	if (mwifiex_is_any_intf_active(priv))
+		user_scan_cfg->scan_chan_gap =
+					      priv->adapter->scan_chan_gap_time;
+
 	ret = mwifiex_scan_networks(priv, user_scan_cfg);
 	kfree(user_scan_cfg);
 	if (ret) {
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 6a703ea..1eb6173 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -170,7 +170,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_COALESCE_RULE      (PROPRIETARY_TLV_BASE_ID + 154)
 #define TLV_TYPE_KEY_PARAM_V2       (PROPRIETARY_TLV_BASE_ID + 156)
 #define TLV_TYPE_TDLS_IDLE_TIMEOUT  (PROPRIETARY_TLV_BASE_ID + 194)
-#define TLV_TYPE_API_REV	    (PROPRIETARY_TLV_BASE_ID + 199)
+#define TLV_TYPE_SCAN_CHANNEL_GAP   (PROPRIETARY_TLV_BASE_ID + 197)
+#define TLV_TYPE_API_REV            (PROPRIETARY_TLV_BASE_ID + 199)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
@@ -653,6 +654,12 @@ struct mwifiex_ie_types_num_probes {
 	__le16 num_probes;
 } __packed;
 
+struct mwifiex_ie_types_scan_chan_gap {
+	struct mwifiex_ie_types_header header;
+	/* time gap in TUs to be used between two consecutive channels scan */
+	__le16 chan_gap;
+} __packed;
+
 struct mwifiex_ie_types_wildcard_ssid_params {
 	struct mwifiex_ie_types_header header;
 	u8 max_ssid_length;
@@ -1249,6 +1256,7 @@ struct mwifiex_user_scan_cfg {
 	u8 num_ssids;
 	/* Variable number (fixed maximum) of channels to scan up */
 	struct mwifiex_user_scan_chan chan_list[MWIFIEX_USER_SCAN_CHAN_MAX];
+	u16 scan_chan_gap;
 } __packed;
 
 struct ie_body {
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 80bda80..d99c6f6 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -212,6 +212,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->specific_scan_time = MWIFIEX_SPECIFIC_SCAN_CHAN_TIME;
 	adapter->active_scan_time = MWIFIEX_ACTIVE_SCAN_CHAN_TIME;
 	adapter->passive_scan_time = MWIFIEX_PASSIVE_SCAN_CHAN_TIME;
+	adapter->scan_chan_gap_time = MWIFIEX_DEF_SCAN_CHAN_GAP_TIME;
 
 	adapter->scan_probes = 1;
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 5439963..18c327c 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -84,6 +84,7 @@ enum {
 #define MWIFIEX_PASSIVE_SCAN_CHAN_TIME	110
 #define MWIFIEX_ACTIVE_SCAN_CHAN_TIME	30
 #define MWIFIEX_SPECIFIC_SCAN_CHAN_TIME	30
+#define MWIFIEX_DEF_SCAN_CHAN_GAP_TIME  50
 
 #define SCAN_RSSI(RSSI)					(0x100 - ((u8)(RSSI)))
 
@@ -770,6 +771,7 @@ struct mwifiex_adapter {
 	u16 specific_scan_time;
 	u16 active_scan_time;
 	u16 passive_scan_time;
+	u16 scan_chan_gap_time;
 	u8 fw_bands;
 	u8 adhoc_start_band;
 	u8 config_bands;
@@ -1139,6 +1141,25 @@ mwifiex_11h_get_csa_closed_channel(struct mwifiex_private *priv)
 	return priv->csa_chan;
 }
 
+static inline u8 mwifiex_is_any_intf_active(struct mwifiex_private *priv)
+{
+	struct mwifiex_private *priv_num;
+	int i;
+
+	for (i = 0; i < priv->adapter->priv_num; i++) {
+		priv_num = priv->adapter->priv[i];
+		if (priv_num) {
+			if ((GET_BSS_ROLE(priv_num) == MWIFIEX_BSS_ROLE_UAP &&
+			     priv_num->bss_started) ||
+			    (GET_BSS_ROLE(priv_num) == MWIFIEX_BSS_ROLE_STA &&
+			     priv_num->media_connected))
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
 int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 			     u32 func_init_shutdown);
 int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *, u8);
@@ -1274,6 +1295,7 @@ void mwifiex_disable_all_tdls_links(struct mwifiex_private *priv);
 bool mwifiex_is_bss_in_11ac_mode(struct mwifiex_private *priv);
 u8 mwifiex_get_center_freq_index(struct mwifiex_private *priv, u8 band,
 				 u32 pri_chan, u8 chan_bw);
+int mwifiex_init_channel_scan_gap(struct mwifiex_adapter *adapter);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index bec48cc..6fd69af 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -799,6 +799,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_ie_types_num_probes *num_probes_tlv;
+	struct mwifiex_ie_types_scan_chan_gap *chan_gap_tlv;
 	struct mwifiex_ie_types_wildcard_ssid_params *wildcard_ssid_tlv;
 	struct mwifiex_ie_types_bssid_list *bssid_tlv;
 	u8 *tlv_pos;
@@ -939,6 +940,22 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	else
 		*max_chan_per_scan = MWIFIEX_DEF_CHANNELS_PER_SCAN_CMD;
 
+	if (user_scan_in->scan_chan_gap) {
+		*max_chan_per_scan = MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN;
+		dev_dbg(adapter->dev, "info: scan: channel gap = %d\n",
+			user_scan_in->scan_chan_gap);
+
+		chan_gap_tlv = (void *)tlv_pos;
+		chan_gap_tlv->header.type =
+					 cpu_to_le16(TLV_TYPE_SCAN_CHANNEL_GAP);
+		chan_gap_tlv->header.len =
+			cpu_to_le16(sizeof(chan_gap_tlv->chan_gap));
+		chan_gap_tlv->chan_gap =
+				     cpu_to_le16((user_scan_in->scan_chan_gap));
+
+		tlv_pos += sizeof(struct mwifiex_ie_types_scan_chan_gap);
+	}
+
 	/* If the input config or adapter has the number of Probes set,
 	   add tlv */
 	if (num_probes) {
-- 
1.8.1.4

