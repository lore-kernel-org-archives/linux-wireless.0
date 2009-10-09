Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:18946 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761413AbZJIUXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:23:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 17/17] iwlwifi: update channel switch command API
Date: Fri,  9 Oct 2009 13:20:34 -0700
Message-Id: <1255119634-3060-19-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Channel switch host command has different data structure for
different devices. Adding additional structures to support 5000 and 6000
NICs. unlike 4965, starting with 5000 series, the tx power is managed by
uCode, there is no tx power db information need to be passing from driver to
uCode; but the space needs to be reserved to match uCode expection.

1000 NIC do not support channel switch operation since it is 'bgn'
device, there is no need to have data structure defined for it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   47 ++++++++++++++++++++++++++-
 1 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 2e8a55e..cc4e912 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -353,6 +353,9 @@ struct iwl3945_power_per_rate {
 #define POWER_TABLE_NUM_HT_OFDM_ENTRIES		32
 #define POWER_TABLE_CCK_ENTRY			32
 
+#define IWL_PWR_NUM_HT_OFDM_ENTRIES		24
+#define IWL_PWR_CCK_ENTRIES			2
+
 /**
  * union iwl4965_tx_power_dual_stream
  *
@@ -803,7 +806,7 @@ struct iwl3945_channel_switch_cmd {
 	struct iwl3945_power_per_rate power[IWL_MAX_RATES];
 } __attribute__ ((packed));
 
-struct iwl_channel_switch_cmd {
+struct iwl4965_channel_switch_cmd {
 	u8 band;
 	u8 expect_beacon;
 	__le16 channel;
@@ -813,6 +816,48 @@ struct iwl_channel_switch_cmd {
 	struct iwl4965_tx_power_db tx_power;
 } __attribute__ ((packed));
 
+/**
+ * struct iwl5000_channel_switch_cmd
+ * @band: 0- 5.2GHz, 1- 2.4GHz
+ * @expect_beacon: 0- resume transmits after channel switch
+ *		   1- wait for beacon to resume transmits
+ * @channel: new channel number
+ * @rxon_flags: Rx on flags
+ * @rxon_filter_flags: filtering parameters
+ * @switch_time: switch time in extended beacon format
+ * @reserved: reserved bytes
+ */
+struct iwl5000_channel_switch_cmd {
+	u8 band;
+	u8 expect_beacon;
+	__le16 channel;
+	__le32 rxon_flags;
+	__le32 rxon_filter_flags;
+	__le32 switch_time;
+	__le32 reserved[2][IWL_PWR_NUM_HT_OFDM_ENTRIES + IWL_PWR_CCK_ENTRIES];
+} __attribute__ ((packed));
+
+/**
+ * struct iwl6000_channel_switch_cmd
+ * @band: 0- 5.2GHz, 1- 2.4GHz
+ * @expect_beacon: 0- resume transmits after channel switch
+ *		   1- wait for beacon to resume transmits
+ * @channel: new channel number
+ * @rxon_flags: Rx on flags
+ * @rxon_filter_flags: filtering parameters
+ * @switch_time: switch time in extended beacon format
+ * @reserved: reserved bytes
+ */
+struct iwl6000_channel_switch_cmd {
+	u8 band;
+	u8 expect_beacon;
+	__le16 channel;
+	__le32 rxon_flags;
+	__le32 rxon_filter_flags;
+	__le32 switch_time;
+	__le32 reserved[3][IWL_PWR_NUM_HT_OFDM_ENTRIES + IWL_PWR_CCK_ENTRIES];
+} __attribute__ ((packed));
+
 /*
  * CHANNEL_SWITCH_NOTIFICATION = 0x73 (notification only, not a command)
  */
-- 
1.5.6.3

