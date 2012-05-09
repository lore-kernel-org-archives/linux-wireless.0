Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:59902 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757752Ab2EIBdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 21:33:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 12/18] mwifiex: add cfg80211 start_ap and stop_ap handlers
Date: Tue,  8 May 2012 18:30:24 -0700
Message-Id: <1336527030-2045-13-git-send-email-bzhao@marvell.com> (sfid-20120509_035904_949021_BE4524A8)
In-Reply-To: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
References: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

1. add start AP and stop AP handlers
2. support for parsing ssid, beacon period, DTIM period
from beacon_parameters structure and setting it to FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   71 +++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/decl.h     |   10 ++++
 drivers/net/wireless/mwifiex/fw.h       |   18 ++++++++
 drivers/net/wireless/mwifiex/ioctl.h    |    5 ++
 drivers/net/wireless/mwifiex/uap_cmd.c  |   35 +++++++++++++++
 5 files changed, 139 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index daa7b4b..8ae9b68 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -922,6 +922,75 @@ static int mwifiex_cfg80211_set_cqm_rssi_config(struct wiphy *wiphy,
 	return 0;
 }
 
+/* cfg80211 operation handler for stop ap.
+ * Function stops BSS running at uAP interface.
+ */
+static int mwifiex_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_UAP_BSS_STOP,
+				  HostCmd_ACT_GEN_SET, 0, NULL)) {
+		wiphy_err(wiphy, "Failed to stop the BSS\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+/* cfg80211 operation handler for start_ap.
+ * Function sets beacon period, DTIM period, SSID and security into
+ * AP config structure.
+ * AP is configured with these settings and BSS is started.
+ */
+static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     struct cfg80211_ap_settings *params)
+{
+	struct mwifiex_uap_bss_param *bss_cfg;
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	bss_cfg = kzalloc(sizeof(struct mwifiex_uap_bss_param), GFP_KERNEL);
+	if (!bss_cfg)
+		return -ENOMEM;
+
+	mwifiex_set_sys_config_invalid_data(bss_cfg);
+
+	if (params->beacon_interval)
+		bss_cfg->beacon_period = params->beacon_interval;
+	if (params->dtim_period)
+		bss_cfg->dtim_period = params->dtim_period;
+
+	if (params->ssid && params->ssid_len) {
+		memcpy(bss_cfg->ssid.ssid, params->ssid, params->ssid_len);
+		bss_cfg->ssid.ssid_len = params->ssid_len;
+	}
+
+	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_UAP_BSS_STOP,
+				  HostCmd_ACT_GEN_SET, 0, NULL)) {
+		wiphy_err(wiphy, "Failed to stop the BSS\n");
+		kfree(bss_cfg);
+		return -1;
+	}
+
+	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_UAP_SYS_CONFIG,
+				   HostCmd_ACT_GEN_SET, 0, bss_cfg)) {
+		wiphy_err(wiphy, "Failed to set the SSID\n");
+		kfree(bss_cfg);
+		return -1;
+	}
+
+	kfree(bss_cfg);
+
+	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_UAP_BSS_START,
+				   HostCmd_ACT_GEN_SET, 0, NULL)) {
+		wiphy_err(wiphy, "Failed to start the BSS\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 /*
  * CFG802.11 operation handler for disconnection request.
  *
@@ -1581,6 +1650,8 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.set_power_mgmt = mwifiex_cfg80211_set_power_mgmt,
 	.set_tx_power = mwifiex_cfg80211_set_tx_power,
 	.set_bitrate_mask = mwifiex_cfg80211_set_bitrate_mask,
+	.start_ap = mwifiex_cfg80211_start_ap,
+	.stop_ap = mwifiex_cfg80211_stop_ap,
 	.set_cqm_rssi_config = mwifiex_cfg80211_set_cqm_rssi_config,
 };
 
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 31dc2ba..f918f66 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -55,6 +55,11 @@
 #define MWIFIEX_RX_DATA_BUF_SIZE     (4 * 1024)
 #define MWIFIEX_RX_CMD_BUF_SIZE	     (2 * 1024)
 
+#define MAX_BEACON_PERIOD                  (4000)
+#define MIN_BEACON_PERIOD                  (50)
+#define MAX_DTIM_PERIOD                    (100)
+#define MIN_DTIM_PERIOD                    (1)
+
 #define MWIFIEX_RTS_MIN_VALUE              (0)
 #define MWIFIEX_RTS_MAX_VALUE              (2347)
 #define MWIFIEX_FRAG_MIN_VALUE             (256)
@@ -93,6 +98,11 @@ struct mwifiex_fw_image {
 	u32 fw_len;
 };
 
+struct mwifiex_802_11_ssid {
+	u32 ssid_len;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+};
+
 struct mwifiex_wait_queue {
 	wait_queue_head_t wait;
 	int status;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index a4c2fc3..07243c0 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -93,6 +93,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 #define CAL_SNR(RSSI, NF)		((s16)((s16)(RSSI)-(s16)(NF)))
 
+#define TLV_TYPE_UAP_SSID			0x0000
+
 #define PROPRIETARY_TLV_BASE_ID                 0x0100
 #define TLV_TYPE_KEY_MATERIAL       (PROPRIETARY_TLV_BASE_ID + 0)
 #define TLV_TYPE_CHANLIST           (PROPRIETARY_TLV_BASE_ID + 1)
@@ -106,6 +108,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_AUTH_TYPE          (PROPRIETARY_TLV_BASE_ID + 31)
 #define TLV_TYPE_STA_MAC_ADDR       (PROPRIETARY_TLV_BASE_ID + 32)
 #define TLV_TYPE_CHANNELBANDLIST    (PROPRIETARY_TLV_BASE_ID + 42)
+#define TLV_TYPE_UAP_BEACON_PERIOD  (PROPRIETARY_TLV_BASE_ID + 44)
+#define TLV_TYPE_UAP_DTIM_PERIOD    (PROPRIETARY_TLV_BASE_ID + 45)
 #define TLV_TYPE_UAP_RTS_THRESHOLD  (PROPRIETARY_TLV_BASE_ID + 51)
 #define TLV_TYPE_UAP_FRAG_THRESHOLD (PROPRIETARY_TLV_BASE_ID + 70)
 #define TLV_TYPE_RATE_DROP_CONTROL  (PROPRIETARY_TLV_BASE_ID + 82)
@@ -1119,6 +1123,20 @@ struct host_cmd_ds_sys_config {
 	__le16 action;
 	u8 tlv[0];
 };
+struct host_cmd_tlv_ssid {
+	struct host_cmd_tlv tlv;
+	u8 ssid[0];
+} __packed;
+
+struct host_cmd_tlv_beacon_period {
+	struct host_cmd_tlv tlv;
+	__le16 period;
+} __packed;
+
+struct host_cmd_tlv_dtim_period {
+	struct host_cmd_tlv tlv;
+	u8 period;
+} __packed;
 
 struct host_cmd_tlv_frag_threshold {
 	struct host_cmd_tlv tlv;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 535a57a..99a7168 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -69,6 +69,11 @@ struct mwifiex_uap_bss_param {
 	u16 rts_threshold;
 	u16 frag_threshold;
 	u8 retry_limit;
+	struct mwifiex_802_11_ssid ssid;
+	u8 bcast_ssid_ctl;
+	u8 radio_ctl;
+	u8 dtim_period;
+	u16 beacon_period;
 };
 
 enum {
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 2225bac..66047cf 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -38,6 +38,9 @@ static int mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd,
 {
 	u8 *tlv;
 	struct host_cmd_ds_sys_config *sys_config = &cmd->params.uap_sys_config;
+	struct host_cmd_tlv_dtim_period *dtim_period;
+	struct host_cmd_tlv_beacon_period *beacon_period;
+	struct host_cmd_tlv_ssid *ssid;
 	struct host_cmd_tlv_channel_band *chan_band;
 	struct host_cmd_tlv_frag_threshold *frag_threshold;
 	struct host_cmd_tlv_rts_threshold *rts_threshold;
@@ -52,6 +55,15 @@ static int mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd,
 
 	tlv = sys_config->tlv;
 
+	if (bss_cfg->ssid.ssid_len) {
+		ssid = (struct host_cmd_tlv_ssid *)tlv;
+		ssid->tlv.type = cpu_to_le16(TLV_TYPE_UAP_SSID);
+		ssid->tlv.len = cpu_to_le16((u16)bss_cfg->ssid.ssid_len);
+		memcpy(ssid->ssid, bss_cfg->ssid.ssid, bss_cfg->ssid.ssid_len);
+		cmd_size += sizeof(struct host_cmd_tlv) +
+			    bss_cfg->ssid.ssid_len;
+		tlv += sizeof(struct host_cmd_tlv) + bss_cfg->ssid.ssid_len;
+	}
 	if (bss_cfg->channel && bss_cfg->channel <= MAX_CHANNEL_BAND_BG) {
 		chan_band = (struct host_cmd_tlv_channel_band *)tlv;
 		chan_band->tlv.type = cpu_to_le16(TLV_TYPE_CHANNELBANDLIST);
@@ -63,6 +75,29 @@ static int mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd,
 		cmd_size += sizeof(struct host_cmd_tlv_channel_band);
 		tlv += sizeof(struct host_cmd_tlv_channel_band);
 	}
+	if (bss_cfg->beacon_period >= MIN_BEACON_PERIOD &&
+	    bss_cfg->beacon_period <= MAX_BEACON_PERIOD) {
+		beacon_period = (struct host_cmd_tlv_beacon_period *)tlv;
+		beacon_period->tlv.type =
+					cpu_to_le16(TLV_TYPE_UAP_BEACON_PERIOD);
+		beacon_period->tlv.len =
+			cpu_to_le16(sizeof(struct host_cmd_tlv_beacon_period) -
+				    sizeof(struct host_cmd_tlv));
+		beacon_period->period = cpu_to_le16(bss_cfg->beacon_period);
+		cmd_size += sizeof(struct host_cmd_tlv_beacon_period);
+		tlv += sizeof(struct host_cmd_tlv_beacon_period);
+	}
+	if (bss_cfg->dtim_period >= MIN_DTIM_PERIOD &&
+	    bss_cfg->dtim_period <= MAX_DTIM_PERIOD) {
+		dtim_period = (struct host_cmd_tlv_dtim_period *)tlv;
+		dtim_period->tlv.type = cpu_to_le16(TLV_TYPE_UAP_DTIM_PERIOD);
+		dtim_period->tlv.len =
+			cpu_to_le16(sizeof(struct host_cmd_tlv_dtim_period) -
+				    sizeof(struct host_cmd_tlv));
+		dtim_period->period = bss_cfg->dtim_period;
+		cmd_size += sizeof(struct host_cmd_tlv_dtim_period);
+		tlv += sizeof(struct host_cmd_tlv_dtim_period);
+	}
 	if (bss_cfg->rts_threshold <= MWIFIEX_RTS_MAX_VALUE) {
 		rts_threshold = (struct host_cmd_tlv_rts_threshold *)tlv;
 		rts_threshold->tlv.type =
-- 
1.7.0.2

