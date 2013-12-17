Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:40425 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3LQUpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:13 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so3141868eek.4
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:11 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/36] iwlwifi: mvm: rs: move rs_program_fix_rate to cleanup ifdefs
Date: Tue, 17 Dec 2013 22:44:22 +0200
Message-Id: <1387313079-28123-19-git-send-email-egrumbach@gmail.com> (sfid-20131217_214627_760752_C0DA4D4A)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Move rs_program_fix_rate right before it's caller where we're
already in the context of an ifdef CPTCFG_MAC80211_DEBUGFS so
we can get rid of the extra ifdefs surrounding the original
location.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   46 ++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index bf6e29f..83306a0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -504,30 +504,6 @@ static inline u8 rs_is_valid_ant(u8 valid_antenna, u8 ant_type)
 	return (ant_type & valid_antenna) == ant_type;
 }
 
-#ifdef CONFIG_MAC80211_DEBUGFS
-/**
- * Program the device to use fixed rate for frame transmit
- * This is for debugging/testing only
- * once the device start use fixed rate, we need to reload the module
- * to being back the normal operation.
- */
-static void rs_program_fix_rate(struct iwl_mvm *mvm,
-				struct iwl_lq_sta *lq_sta)
-{
-	lq_sta->active_legacy_rate = 0x0FFF;	/* 1 - 54 MBits, includes CCK */
-	lq_sta->active_siso_rate   = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
-	lq_sta->active_mimo2_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
-
-	IWL_DEBUG_RATE(mvm, "sta_id %d rate 0x%X\n",
-		       lq_sta->lq.sta_id, lq_sta->dbg_fixed_rate);
-
-	if (lq_sta->dbg_fixed_rate) {
-		rs_fill_link_cmd(NULL, NULL, lq_sta, lq_sta->dbg_fixed_rate);
-		iwl_mvm_send_lq_cmd(lq_sta->drv, &lq_sta->lq, false);
-	}
-}
-#endif
-
 static int rs_tl_turn_on_agg_for_tid(struct iwl_mvm *mvm,
 				      struct iwl_lq_sta *lq_data, u8 tid,
 				      struct ieee80211_sta *sta)
@@ -2612,6 +2588,28 @@ static int rs_pretty_print_rate(char *buf, const u32 rate)
 		       (rate & RATE_MCS_ZLF_MSK) ? "ZLF " : "");
 }
 
+/**
+ * Program the device to use fixed rate for frame transmit
+ * This is for debugging/testing only
+ * once the device start use fixed rate, we need to reload the module
+ * to being back the normal operation.
+ */
+static void rs_program_fix_rate(struct iwl_mvm *mvm,
+				struct iwl_lq_sta *lq_sta)
+{
+	lq_sta->active_legacy_rate = 0x0FFF;	/* 1 - 54 MBits, includes CCK */
+	lq_sta->active_siso_rate   = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
+	lq_sta->active_mimo2_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
+
+	IWL_DEBUG_RATE(mvm, "sta_id %d rate 0x%X\n",
+		       lq_sta->lq.sta_id, lq_sta->dbg_fixed_rate);
+
+	if (lq_sta->dbg_fixed_rate) {
+		rs_fill_link_cmd(NULL, NULL, lq_sta, lq_sta->dbg_fixed_rate);
+		iwl_mvm_send_lq_cmd(lq_sta->drv, &lq_sta->lq, false);
+	}
+}
+
 static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 			const char __user *user_buf, size_t count, loff_t *ppos)
 {
-- 
1.7.9.5

