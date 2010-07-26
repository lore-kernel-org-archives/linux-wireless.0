Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52953 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0GZTPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 15:15:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: wey-yi.w.guy@intel.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlagn: use __packed on new structure definitions
Date: Mon, 26 Jul 2010 15:12:50 -0400
Message-Id: <1280171570-12141-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"iwlagn: add statistic notification structure for WiFi/BT devices" added
several new '__attribute__ ((packed))' lines.  Change them to the
generic __packed.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 798bf9e..9c44ab5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3132,7 +3132,7 @@ struct statistics_rx_non_phy_bt {
 	/* additional stats for bt */
 	__le32 num_bt_kills;
 	__le32 reserved[2];
-} __attribute__ ((packed));
+} __packed;
 
 struct statistics_rx {
 	struct statistics_rx_phy ofdm;
@@ -3146,7 +3146,7 @@ struct statistics_rx_bt {
 	struct statistics_rx_phy cck;
 	struct statistics_rx_non_phy_bt general;
 	struct statistics_rx_ht_phy ofdm_ht;
-} __attribute__ ((packed));
+} __packed;
 
 /**
  * struct statistics_tx_power - current tx power
@@ -3226,7 +3226,7 @@ struct statistics_general_common {
 	 *  in order to get out of bad PHY status
 	 */
 	__le32 num_of_sos_states;
-} __attribute__ ((packed));
+} __packed;
 
 struct statistics_bt_activity {
 	/* Tx statistics */
@@ -3239,13 +3239,13 @@ struct statistics_bt_activity {
 	__le32 hi_priority_rx_denied_cnt;
 	__le32 lo_priority_rx_req_cnt;
 	__le32 lo_priority_rx_denied_cnt;
-} __attribute__ ((packed));
+} __packed;
 
 struct statistics_general {
 	struct statistics_general_common common;
 	__le32 reserved2;
 	__le32 reserved3;
-} __attribute__ ((packed));
+} __packed;
 
 struct statistics_general_bt {
 	struct statistics_general_common common;
@@ -3316,7 +3316,7 @@ struct iwl_bt_notif_statistics {
 	struct statistics_rx_bt rx;
 	struct statistics_tx tx;
 	struct statistics_general_bt general;
-} __attribute__ ((packed));
+} __packed;
 
 /*
  * MISSED_BEACONS_NOTIFICATION = 0xa2 (notification only, not a command)
-- 
1.7.1.1

