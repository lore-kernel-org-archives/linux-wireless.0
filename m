Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3ACOpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:45:53 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/12] iwlwifi: use __packed
Date: Thu,  3 Jan 2013 15:46:09 +0100
Message-Id: <1357224376-27803-5-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154602_798775_A4E02408)
In-Reply-To: <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
References: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
 <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use __packed instead of __attribute__((packed)).

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/commands.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/commands.h b/drivers/net/wireless/iwlwifi/dvm/commands.h
index 71ab76b..0ca99c1 100644
--- a/drivers/net/wireless/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/iwlwifi/dvm/commands.h
@@ -3695,7 +3695,7 @@ struct iwl_bt_uart_msg {
 	u8 frame5;
 	u8 frame6;
 	u8 frame7;
-} __attribute__((packed));
+} __packed;
 
 struct iwl_bt_coex_profile_notif {
 	struct iwl_bt_uart_msg last_bt_uart_msg;
@@ -3703,7 +3703,7 @@ struct iwl_bt_coex_profile_notif {
 	u8 bt_traffic_load; /* 0 .. 3? */
 	u8 bt_ci_compliance; /* 0 - not complied, 1 - complied */
 	u8 reserved;
-} __attribute__((packed));
+} __packed;
 
 #define IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_POS	0
 #define IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_MSK	0x1
@@ -3752,7 +3752,7 @@ enum bt_coex_prio_table_priorities {
 
 struct iwl_bt_coex_prio_table_cmd {
 	u8 prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX];
-} __attribute__((packed));
+} __packed;
 
 #define IWL_BT_COEX_ENV_CLOSE	0
 #define IWL_BT_COEX_ENV_OPEN	1
@@ -3764,7 +3764,7 @@ struct iwl_bt_coex_prot_env_cmd {
 	u8 action; /* 0 = closed, 1 = open */
 	u8 type; /* 0 .. 15 */
 	u8 reserved[2];
-} __attribute__((packed));
+} __packed;
 
 /*
  * REPLY_D3_CONFIG
-- 
1.8.0

