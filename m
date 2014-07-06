Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:34601 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaGFJgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:47 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so3149695wes.17
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:46 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/40] iwlwifi: mvm: BT Coex - fix debugfs with old API
Date: Sun,  6 Jul 2014 12:35:52 +0300
Message-Id: <1404639376-3792-16-git-send-email-egrumbach@gmail.com> (sfid-20140706_115953_446356_7D928BCB)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Fix the debugfs hook to make it able to display the data
with the old firmware API.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 183 +++++++++++++++++++++++------
 1 file changed, 148 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index e66c659..f131ef0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -312,20 +312,69 @@ static ssize_t iwl_dbgfs_disable_power_off_write(struct iwl_mvm *mvm, char *buf,
 					 BT_MBOX_MSG(notif, _num, _field),  \
 					 true ? "\n" : ", ");
 
-static ssize_t iwl_dbgfs_bt_notif_read(struct file *file, char __user *user_buf,
-				       size_t count, loff_t *ppos)
+static
+int iwl_mvm_coex_dump_mbox(struct iwl_bt_coex_profile_notif *notif, char *buf,
+			   int pos, int bufsz)
 {
-	struct iwl_mvm *mvm = file->private_data;
-	struct iwl_bt_coex_profile_notif *notif = &mvm->last_bt_notif;
-	char *buf;
-	int ret, pos = 0, bufsz = sizeof(char) * 1024;
+	pos += scnprintf(buf+pos, bufsz-pos, "MBOX dw0:\n");
 
-	buf = kmalloc(bufsz, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	BT_MBOX_PRINT(0, LE_SLAVE_LAT, false);
+	BT_MBOX_PRINT(0, LE_PROF1, false);
+	BT_MBOX_PRINT(0, LE_PROF2, false);
+	BT_MBOX_PRINT(0, LE_PROF_OTHER, false);
+	BT_MBOX_PRINT(0, CHL_SEQ_N, false);
+	BT_MBOX_PRINT(0, INBAND_S, false);
+	BT_MBOX_PRINT(0, LE_MIN_RSSI, false);
+	BT_MBOX_PRINT(0, LE_SCAN, false);
+	BT_MBOX_PRINT(0, LE_ADV, false);
+	BT_MBOX_PRINT(0, LE_MAX_TX_POWER, false);
+	BT_MBOX_PRINT(0, OPEN_CON_1, true);
 
-	mutex_lock(&mvm->mutex);
+	pos += scnprintf(buf+pos, bufsz-pos, "MBOX dw1:\n");
+
+	BT_MBOX_PRINT(1, BR_MAX_TX_POWER, false);
+	BT_MBOX_PRINT(1, IP_SR, false);
+	BT_MBOX_PRINT(1, LE_MSTR, false);
+	BT_MBOX_PRINT(1, AGGR_TRFC_LD, false);
+	BT_MBOX_PRINT(1, MSG_TYPE, false);
+	BT_MBOX_PRINT(1, SSN, true);
+
+	pos += scnprintf(buf+pos, bufsz-pos, "MBOX dw2:\n");
+
+	BT_MBOX_PRINT(2, SNIFF_ACT, false);
+	BT_MBOX_PRINT(2, PAG, false);
+	BT_MBOX_PRINT(2, INQUIRY, false);
+	BT_MBOX_PRINT(2, CONN, false);
+	BT_MBOX_PRINT(2, SNIFF_INTERVAL, false);
+	BT_MBOX_PRINT(2, DISC, false);
+	BT_MBOX_PRINT(2, SCO_TX_ACT, false);
+	BT_MBOX_PRINT(2, SCO_RX_ACT, false);
+	BT_MBOX_PRINT(2, ESCO_RE_TX, false);
+	BT_MBOX_PRINT(2, SCO_DURATION, true);
 
+	pos += scnprintf(buf+pos, bufsz-pos, "MBOX dw3:\n");
+
+	BT_MBOX_PRINT(3, SCO_STATE, false);
+	BT_MBOX_PRINT(3, SNIFF_STATE, false);
+	BT_MBOX_PRINT(3, A2DP_STATE, false);
+	BT_MBOX_PRINT(3, ACL_STATE, false);
+	BT_MBOX_PRINT(3, MSTR_STATE, false);
+	BT_MBOX_PRINT(3, OBX_STATE, false);
+	BT_MBOX_PRINT(3, OPEN_CON_2, false);
+	BT_MBOX_PRINT(3, TRAFFIC_LOAD, false);
+	BT_MBOX_PRINT(3, CHL_SEQN_LSB, false);
+	BT_MBOX_PRINT(3, INBAND_P, false);
+	BT_MBOX_PRINT(3, MSG_TYPE_2, false);
+	BT_MBOX_PRINT(3, SSN_2, false);
+	BT_MBOX_PRINT(3, UPDATE_REQUEST, true);
+
+	return pos;
+}
+
+static
+int iwl_mvm_coex_dump_mbox_old(struct iwl_bt_coex_profile_notif_old *notif,
+			       char *buf, int pos, int bufsz)
+{
 	pos += scnprintf(buf+pos, bufsz-pos, "MBOX dw0:\n");
 
 	BT_MBOX_PRINT(0, LE_SLAVE_LAT, false);
@@ -378,17 +427,59 @@ static ssize_t iwl_dbgfs_bt_notif_read(struct file *file, char __user *user_buf,
 	BT_MBOX_PRINT(3, SSN_2, false);
 	BT_MBOX_PRINT(3, UPDATE_REQUEST, true);
 
-	pos += scnprintf(buf+pos, bufsz-pos, "bt_ci_compliance = %d\n",
-			 notif->bt_ci_compliance);
-	pos += scnprintf(buf+pos, bufsz-pos, "primary_ch_lut = %d\n",
-			 le32_to_cpu(notif->primary_ch_lut));
-	pos += scnprintf(buf+pos, bufsz-pos, "secondary_ch_lut = %d\n",
-			 le32_to_cpu(notif->secondary_ch_lut));
-	pos += scnprintf(buf+pos, bufsz-pos, "bt_activity_grading = %d\n",
-			 le32_to_cpu(notif->bt_activity_grading));
-	pos += scnprintf(buf+pos, bufsz-pos,
-			 "antenna isolation = %d CORUN LUT index = %d\n",
-			 mvm->last_ant_isol, mvm->last_corun_lut);
+	return pos;
+}
+
+static ssize_t iwl_dbgfs_bt_notif_read(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	char *buf;
+	int ret, pos = 0, bufsz = sizeof(char) * 1024;
+
+	buf = kmalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mutex_lock(&mvm->mutex);
+
+	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
+		struct iwl_bt_coex_profile_notif_old *notif =
+			&mvm->last_bt_notif_old;
+
+		pos += iwl_mvm_coex_dump_mbox_old(notif, buf, pos, bufsz);
+
+		pos += scnprintf(buf+pos, bufsz-pos, "bt_ci_compliance = %d\n",
+				 notif->bt_ci_compliance);
+		pos += scnprintf(buf+pos, bufsz-pos, "primary_ch_lut = %d\n",
+				 le32_to_cpu(notif->primary_ch_lut));
+		pos += scnprintf(buf+pos, bufsz-pos, "secondary_ch_lut = %d\n",
+				 le32_to_cpu(notif->secondary_ch_lut));
+		pos += scnprintf(buf+pos,
+				 bufsz-pos, "bt_activity_grading = %d\n",
+				 le32_to_cpu(notif->bt_activity_grading));
+		pos += scnprintf(buf+pos, bufsz-pos,
+				 "antenna isolation = %d CORUN LUT index = %d\n",
+				 mvm->last_ant_isol, mvm->last_corun_lut);
+	} else {
+		struct iwl_bt_coex_profile_notif *notif =
+			&mvm->last_bt_notif;
+
+		pos += iwl_mvm_coex_dump_mbox(notif, buf, pos, bufsz);
+
+		pos += scnprintf(buf+pos, bufsz-pos, "bt_ci_compliance = %d\n",
+				 notif->bt_ci_compliance);
+		pos += scnprintf(buf+pos, bufsz-pos, "primary_ch_lut = %d\n",
+				 le32_to_cpu(notif->primary_ch_lut));
+		pos += scnprintf(buf+pos, bufsz-pos, "secondary_ch_lut = %d\n",
+				 le32_to_cpu(notif->secondary_ch_lut));
+		pos += scnprintf(buf+pos,
+				 bufsz-pos, "bt_activity_grading = %d\n",
+				 le32_to_cpu(notif->bt_activity_grading));
+		pos += scnprintf(buf+pos, bufsz-pos,
+				 "antenna isolation = %d CORUN LUT index = %d\n",
+				 mvm->last_ant_isol, mvm->last_corun_lut);
+	}
 
 	mutex_unlock(&mvm->mutex);
 
@@ -403,26 +494,48 @@ static ssize_t iwl_dbgfs_bt_cmd_read(struct file *file, char __user *user_buf,
 				     size_t count, loff_t *ppos)
 {
 	struct iwl_mvm *mvm = file->private_data;
-	struct iwl_bt_coex_ci_cmd *cmd = &mvm->last_bt_ci_cmd;
 	char buf[256];
 	int bufsz = sizeof(buf);
 	int pos = 0;
 
 	mutex_lock(&mvm->mutex);
 
-	pos += scnprintf(buf+pos, bufsz-pos, "Channel inhibition CMD\n");
-	pos += scnprintf(buf+pos, bufsz-pos,
-		       "\tPrimary Channel Bitmap 0x%016llx\n",
-		       le64_to_cpu(cmd->bt_primary_ci));
-	pos += scnprintf(buf+pos, bufsz-pos,
-		       "\tSecondary Channel Bitmap 0x%016llx\n",
-		       le64_to_cpu(cmd->bt_secondary_ci));
-
-	pos += scnprintf(buf+pos, bufsz-pos, "BT Configuration CMD\n");
-	pos += scnprintf(buf+pos, bufsz-pos, "\tACK Kill Mask 0x%08x\n",
-			 iwl_bt_ack_kill_msk[mvm->bt_kill_msk]);
-	pos += scnprintf(buf+pos, bufsz-pos, "\tCTS Kill Mask 0x%08x\n",
-			 iwl_bt_cts_kill_msk[mvm->bt_kill_msk]);
+	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
+		struct iwl_bt_coex_ci_cmd_old *cmd = &mvm->last_bt_ci_cmd_old;
+
+		pos += scnprintf(buf+pos, bufsz-pos,
+				 "Channel inhibition CMD\n");
+		pos += scnprintf(buf+pos, bufsz-pos,
+			       "\tPrimary Channel Bitmap 0x%016llx\n",
+			       le64_to_cpu(cmd->bt_primary_ci));
+		pos += scnprintf(buf+pos, bufsz-pos,
+			       "\tSecondary Channel Bitmap 0x%016llx\n",
+			       le64_to_cpu(cmd->bt_secondary_ci));
+
+		pos += scnprintf(buf+pos, bufsz-pos, "BT Configuration CMD\n");
+		pos += scnprintf(buf+pos, bufsz-pos, "\tACK Kill Mask 0x%08x\n",
+				 iwl_bt_ack_kill_msk[mvm->bt_kill_msk]);
+		pos += scnprintf(buf+pos, bufsz-pos, "\tCTS Kill Mask 0x%08x\n",
+				 iwl_bt_cts_kill_msk[mvm->bt_kill_msk]);
+
+	} else {
+		struct iwl_bt_coex_ci_cmd *cmd = &mvm->last_bt_ci_cmd;
+
+		pos += scnprintf(buf+pos, bufsz-pos,
+				 "Channel inhibition CMD\n");
+		pos += scnprintf(buf+pos, bufsz-pos,
+			       "\tPrimary Channel Bitmap 0x%016llx\n",
+			       le64_to_cpu(cmd->bt_primary_ci));
+		pos += scnprintf(buf+pos, bufsz-pos,
+			       "\tSecondary Channel Bitmap 0x%016llx\n",
+			       le64_to_cpu(cmd->bt_secondary_ci));
+
+		pos += scnprintf(buf+pos, bufsz-pos, "BT Configuration CMD\n");
+		pos += scnprintf(buf+pos, bufsz-pos, "\tACK Kill Mask 0x%08x\n",
+				 iwl_bt_ack_kill_msk[mvm->bt_kill_msk]);
+		pos += scnprintf(buf+pos, bufsz-pos, "\tCTS Kill Mask 0x%08x\n",
+				 iwl_bt_cts_kill_msk[mvm->bt_kill_msk]);
+	}
 
 	mutex_unlock(&mvm->mutex);
 
-- 
1.8.3.2

