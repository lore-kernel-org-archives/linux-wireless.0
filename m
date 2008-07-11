Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61406 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637AbYGKD5L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:57:11 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 10/14] iwlwifi: unify 4965 and 5000 scanning code
Date: Fri, 11 Jul 2008 11:53:38 +0800
Message-Id: <1215748422-12672-11-git-send-email-yi.zhu@intel.com> (sfid-20080711_061545_462991_588294DF)
In-Reply-To: <1215748422-12672-10-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-4-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-5-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-6-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-7-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-8-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-9-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-10-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch unifies 4965 and 5000 scanning code.

We increases the version number to 1.3.27. Since new uCode
iwlwifi-4965-2.ucode is required for 4965 cards.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |   15 +++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 ------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   23 +++++++++++++----------
 5 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a20adab..9afecb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -49,6 +49,13 @@
 static int iwl4965_send_tx_power(struct iwl_priv *priv);
 static int iwl4965_hw_get_temperature(const struct iwl_priv *priv);
 
+/* Change firmware file name, using "-" and incrementing number,
+ *   *only* when uCode interface or architecture changes so that it
+ *   is not compatible with earlier drivers.
+ * This number will also appear in << 8 position of 1st dword of uCode file */
+#define IWL4965_UCODE_API "-2"
+
+
 /* module parameters */
 static struct iwl_mod_params iwl4965_mod_params = {
 	.num_of_queues = IWL49_NUM_QUEUES,
@@ -2454,6 +2461,9 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.mod_params = &iwl4965_mod_params,
 };
 
+/* Module firmware */
+MODULE_FIRMWARE("iwlwifi-4965" IWL4965_UCODE_API ".ucode");
+
 module_param_named(antenna, iwl4965_mod_params.antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
 module_param_named(disable, iwl4965_mod_params.disable, int, 0444);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 3e96df8..e9bb1de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2099,6 +2099,9 @@ struct iwl_ct_kill_config {
  *
  *****************************************************************************/
 
+#define SCAN_CHANNEL_TYPE_PASSIVE __constant_cpu_to_le32(0)
+#define SCAN_CHANNEL_TYPE_ACTIVE  __constant_cpu_to_le32(1)
+
 /**
  * struct iwl_scan_channel - entry in REPLY_SCAN_CMD channel table
  *
@@ -2122,12 +2125,12 @@ struct iwl_scan_channel {
 	/*
 	 * type is defined as:
 	 * 0:0 1 = active, 0 = passive
-	 * 1:4 SSID direct bit map; if a bit is set, then corresponding
+	 * 1:20 SSID direct bit map; if a bit is set, then corresponding
 	 *     SSID IE is transmitted in probe request.
-	 * 5:7 reserved
+	 * 21:31 reserved
 	 */
-	u8 type;
-	u8 channel;	/* band is selected by iwl4965_scan_cmd "flags" field */
+	__le32 type;
+	__le16 channel;	/* band is selected by iwl_scan_cmd "flags" field */
 	u8 tx_gain;		/* gain for analog radio */
 	u8 dsp_atten;		/* gain for DSP */
 	__le16 active_dwell;	/* in 1024-uSec TU (time units), typ 5-50 */
@@ -2147,9 +2150,9 @@ struct iwl_ssid_ie {
 	u8 ssid[32];
 } __attribute__ ((packed));
 
-#define PROBE_OPTION_MAX        0x4
+#define PROBE_OPTION_MAX        	0x14
 #define TX_CMD_LIFE_TIME_INFINITE	__constant_cpu_to_le32(0xFFFFFFFF)
-#define IWL_GOOD_CRC_TH		__constant_cpu_to_le16(1)
+#define IWL_GOOD_CRC_TH			__constant_cpu_to_le16(1)
 #define IWL_MAX_SCAN_SIZE 1024
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 0293ae9..db66114 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -70,7 +70,7 @@ struct iwl_host_cmd;
 struct iwl_cmd;
 
 
-#define IWLWIFI_VERSION "1.2.26k"
+#define IWLWIFI_VERSION "1.3.27k"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2008 Intel Corporation"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 84a3ecf..4d789e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -54,12 +54,6 @@ extern struct iwl_cfg iwl5350_agn_cfg;
 extern struct iwl_cfg iwl5100_bg_cfg;
 extern struct iwl_cfg iwl5100_abg_cfg;
 
-/* Change firmware file name, using "-" and incrementing number,
- *   *only* when uCode interface or architecture changes so that it
- *   is not compatible with earlier drivers.
- * This number will also appear in << 8 position of 1st dword of uCode file */
-#define IWL4965_UCODE_API "-1"
-
 /* CT-KILL constants */
 #define CT_KILL_THRESHOLD	110 /* in Celsius */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 5b420b4..cf24c27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -375,6 +375,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 	u16 passive_dwell = 0;
 	u16 active_dwell = 0;
 	int added, i;
+	u16 channel;
 
 	sband = iwl_get_hw_mode(priv, band);
 	if (!sband)
@@ -389,24 +390,25 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		if (channels[i].flags & IEEE80211_CHAN_DISABLED)
 			continue;
 
-		scan_ch->channel =
+		channel =
 			ieee80211_frequency_to_channel(channels[i].center_freq);
+		scan_ch->channel = cpu_to_le16(channel);
 
-		ch_info = iwl_get_channel_info(priv, band, scan_ch->channel);
+		ch_info = iwl_get_channel_info(priv, band, channel);
 		if (!is_channel_valid(ch_info)) {
 			IWL_DEBUG_SCAN("Channel %d is INVALID for this band.\n",
-				       scan_ch->channel);
+					channel);
 			continue;
 		}
 
 		if (!is_active || is_channel_passive(ch_info) ||
 		    (channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN))
-			scan_ch->type = 0;
+			scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
 		else
-			scan_ch->type = 1;
+			scan_ch->type = SCAN_CHANNEL_TYPE_ACTIVE;
 
-		if (scan_ch->type & 1)
-			scan_ch->type |= (direct_mask << 1);
+		if (scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE)
+			scan_ch->type |= cpu_to_le32(direct_mask << 1);
 
 		scan_ch->active_dwell = cpu_to_le16(active_dwell);
 		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
@@ -425,9 +427,10 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		}
 
 		IWL_DEBUG_SCAN("Scanning %d [%s %d]\n",
-			       scan_ch->channel,
-			       (scan_ch->type & 1) ? "ACTIVE" : "PASSIVE",
-			       (scan_ch->type & 1) ?
+			       channel,
+			       (scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE) ?
+				"ACTIVE" : "PASSIVE",
+			       (scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE) ?
 			       active_dwell : passive_dwell);
 
 		scan_ch++;
-- 
1.5.3.6

