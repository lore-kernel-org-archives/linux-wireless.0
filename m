Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63215 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab1BZTBP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 14:01:15 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/5] iwlagn: add bt config structure support for 2000 series
Date: Sat, 26 Feb 2011 10:46:03 -0800
Message-Id: <1298745966-25130-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1298745966-25130-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1298745966-25130-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2000 series has different bt config command structure, add support for it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 58919f8..b32b143 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2499,6 +2499,29 @@ struct iwl6000_bt_cmd {
 	__le16 rx_prio_boost;	/* SW boost of WiFi rx priority */
 };
 
+struct iwl2000_bt_cmd {
+	u8 flags;
+	u8 ledtime; /* unused */
+	u8 max_kill;
+	u8 bt3_timer_t7_value;
+	__le32 kill_ack_mask;
+	__le32 kill_cts_mask;
+	u8 bt3_prio_sample_time;
+	u8 bt3_timer_t2_value;
+	__le16 bt4_reaction_time; /* unused */
+	__le32 bt3_lookup_table[12];
+	__le16 bt4_decision_time; /* unused */
+	__le16 valid;
+	__le32 prio_boost;
+	/*
+	 * set IWLAGN_BT_VALID_BOOST to "1" in "valid" bitmask
+	 * if configure the following patterns
+	 */
+	u8 reserved;
+	u8 tx_prio_boost;	/* SW boost of WiFi tx priority */
+	__le16 rx_prio_boost;	/* SW boost of WiFi rx priority */
+};
+
 #define IWLAGN_BT_SCO_ACTIVE	cpu_to_le32(BIT(0))
 
 struct iwlagn_bt_sco_cmd {
-- 
1.7.0.4

