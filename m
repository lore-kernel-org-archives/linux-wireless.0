Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44618 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751077AbdHRPwh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:52:37 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:11 +0300
Message-Id: <20170818154922.2904-14-luca@coelho.fi> (sfid-20170818_175240_715961_ED2A4408)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 13/24] iwlwifi: move BT_MBOX_PRINT macro to common header
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Move the BT_MBOX_PRINT() macro from mvm/debugfs.c to fw/api/coex.h so
it can be reused and remove duplicate definition of BT_MBOX_MSG(),
keeping only the one already in coex.h.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h |  6 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 12 ------------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/coex.h b/drivers/net/wireless/intel/iwlwifi/fw/api/coex.h
index d9a74db01f90..d09555afe2c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/coex.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/coex.h
@@ -197,6 +197,12 @@ enum iwl_bt_mxbox_dw4 {
 	((le32_to_cpu((_notif)->mbox_msg[(_num)]) & BT_MBOX##_num##_##_field)\
 	>> BT_MBOX##_num##_##_field##_POS)
 
+#define BT_MBOX_PRINT(_num, _field, _end)				    \
+			pos += scnprintf(buf + pos, bufsz - pos,	    \
+					 "\t%s: %d%s",			    \
+					 #_field,			    \
+					 BT_MBOX_MSG(notif, _num, _field),  \
+					 true ? "\n" : ", ");
 enum iwl_bt_activity_grading {
 	BT_OFF			= 0,
 	BT_ON_NO_CONNECTION	= 1,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index c88a37397075..e97904c2c4d4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -469,18 +469,6 @@ static ssize_t iwl_dbgfs_disable_power_off_write(struct iwl_mvm *mvm, char *buf,
 	return ret ?: count;
 }
 
-#define BT_MBOX_MSG(_notif, _num, _field)				     \
-	((le32_to_cpu((_notif)->mbox_msg[(_num)]) & BT_MBOX##_num##_##_field)\
-	>> BT_MBOX##_num##_##_field##_POS)
-
-
-#define BT_MBOX_PRINT(_num, _field, _end)				    \
-			pos += scnprintf(buf + pos, bufsz - pos,	    \
-					 "\t%s: %d%s",			    \
-					 #_field,			    \
-					 BT_MBOX_MSG(notif, _num, _field),  \
-					 true ? "\n" : ", ");
-
 static
 int iwl_mvm_coex_dump_mbox(struct iwl_mvm *mvm,
 			   struct iwl_bt_coex_profile_notif *notif, char *buf,
-- 
2.14.1
