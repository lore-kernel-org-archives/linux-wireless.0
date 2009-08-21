Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50995 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634AbZHUUe1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:27 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/14] iwlwifi: change IWL6000_UCODE_API_MAX to v4
Date: Fri, 21 Aug 2009 13:34:18 -0700
Message-Id: <1250886867-4112-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

uCode version changed to v4 for 6000 series

The additional parameter added to v4 is providing current tx power for
each chain in tx statistics portion of "statistics notification"
command.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |   18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 383177d..33ef736 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -46,8 +46,8 @@
 #include "iwl-5000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL6000_UCODE_API_MAX 3
-#define IWL6050_UCODE_API_MAX 3
+#define IWL6000_UCODE_API_MAX 4
+#define IWL6050_UCODE_API_MAX 4
 
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 1
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index f430384..6b82d4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2930,6 +2930,20 @@ struct statistics_rx {
 	struct statistics_rx_ht_phy ofdm_ht;
 } __attribute__ ((packed));
 
+/**
+ * struct statistics_tx_power - current tx power
+ *
+ * @ant_a: current tx power on chain a in 1/2 dB step
+ * @ant_b: current tx power on chain b in 1/2 dB step
+ * @ant_c: current tx power on chain c in 1/2 dB step
+ */
+struct statistics_tx_power {
+	u8 ant_a;
+	u8 ant_b;
+	u8 ant_c;
+	u8 reserved;
+} __attribute__ ((packed));
+
 struct statistics_tx_non_phy_agg {
 	__le32 ba_timeout;
 	__le32 ba_reschedule_frames;
@@ -2941,8 +2955,6 @@ struct statistics_tx_non_phy_agg {
 	__le32 underrun;
 	__le32 bt_prio_kill;
 	__le32 rx_ba_rsp_cnt;
-	__le32 reserved2;
-	__le32 reserved3;
 } __attribute__ ((packed));
 
 struct statistics_tx {
@@ -2961,6 +2973,8 @@ struct statistics_tx {
 	__le32 cts_timeout_collision;
 	__le32 ack_or_ba_timeout_collision;
 	struct statistics_tx_non_phy_agg agg;
+	struct statistics_tx_power tx_power;
+	__le32 reserved1;
 } __attribute__ ((packed));
 
 
-- 
1.5.6.3

