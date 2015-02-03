Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965134AbbBCHO4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:14:56 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/19] iwlwifi: mvm: rs: enable forcing single stream Tx decision
Date: Tue,  3 Feb 2015 09:14:26 +0200
Message-Id: <1422947678-16917-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081501_318752_6A5228E4)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

In certain testing scenarios we'd like to force a decision
between STBC/BFER/SISO. In the normal scenario this decision
is done by the FW. Enable this option vis debugfs.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h |  8 +++
 drivers/net/wireless/iwlwifi/mvm/rs.c        | 84 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/rs.h        | 10 ++++
 3 files changed, 102 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
index 4c33f27..0f1ea80 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
@@ -330,6 +330,14 @@ enum {
 #define LQ_SS_BFER_ALLOWED_POS		2
 #define LQ_SS_BFER_ALLOWED		(1 << LQ_SS_BFER_ALLOWED_POS)
 
+/* Bit 3: Force BFER or STBC for testing
+ * If this is set:
+ * If BFER is allowed then force the ucode to choose BFER else
+ * If STBC is allowed then force the ucode to choose STBC over SISO
+ */
+#define LQ_SS_FORCE_POS			3
+#define LQ_SS_FORCE			(1 << LQ_SS_FORCE_POS)
+
 /* Bit 31: ss_params field is valid. Used for FW backward compatibility
  * with other drivers which don't support the ss_params API yet
  */
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 95b718b..194bd1f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -39,6 +39,7 @@
 #include "sta.h"
 #include "iwl-op-mode.h"
 #include "mvm.h"
+#include "debugfs.h"
 
 #define RS_NAME "iwl-mvm-rs"
 
@@ -3057,6 +3058,20 @@ static void rs_set_lq_ss_params(struct iwl_mvm *mvm,
 	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
 		goto out;
 
+	/* Check if forcing the decision is configured.
+	 * Note that SISO is forced by not allowing STBC or BFER
+	 */
+	if (lq_sta->ss_force == RS_SS_FORCE_STBC)
+		ss_params |= (LQ_SS_STBC_1SS_ALLOWED | LQ_SS_FORCE);
+	else if (lq_sta->ss_force == RS_SS_FORCE_BFER)
+		ss_params |= (LQ_SS_BFER_ALLOWED | LQ_SS_FORCE);
+
+	if (lq_sta->ss_force != RS_SS_FORCE_NONE) {
+		IWL_DEBUG_RATE(mvm, "Forcing single stream Tx decision %d\n",
+			       lq_sta->ss_force);
+		goto out;
+	}
+
 	if (lq_sta->stbc_capable)
 		ss_params |= LQ_SS_STBC_1SS_ALLOWED;
 
@@ -3502,9 +3517,73 @@ static const struct file_operations rs_sta_dbgfs_drv_tx_stats_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t iwl_dbgfs_ss_force_read(struct file *file,
+				       char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct iwl_lq_sta *lq_sta = file->private_data;
+	char buf[12];
+	int bufsz = sizeof(buf);
+	int pos = 0;
+	static const char * const ss_force_name[] = {
+		[RS_SS_FORCE_NONE] = "none",
+		[RS_SS_FORCE_STBC] = "stbc",
+		[RS_SS_FORCE_BFER] = "bfer",
+		[RS_SS_FORCE_SISO] = "siso",
+	};
+
+	pos += scnprintf(buf+pos, bufsz-pos, "%s\n",
+			 ss_force_name[lq_sta->ss_force]);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+static ssize_t iwl_dbgfs_ss_force_write(struct iwl_lq_sta *lq_sta, char *buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = lq_sta->pers.drv;
+	int ret = 0;
+
+	if (!strncmp("none", buf, 4)) {
+		lq_sta->ss_force = RS_SS_FORCE_NONE;
+	} else if (!strncmp("siso", buf, 4)) {
+		lq_sta->ss_force = RS_SS_FORCE_SISO;
+	} else if (!strncmp("stbc", buf, 4)) {
+		if (lq_sta->stbc_capable) {
+			lq_sta->ss_force = RS_SS_FORCE_STBC;
+		} else {
+			IWL_ERR(mvm,
+				"can't force STBC. peer doesn't support\n");
+			ret = -EINVAL;
+		}
+	} else if (!strncmp("bfer", buf, 4)) {
+		if (lq_sta->bfer_capable) {
+			lq_sta->ss_force = RS_SS_FORCE_BFER;
+		} else {
+			IWL_ERR(mvm,
+				"can't force BFER. peer doesn't support\n");
+			ret = -EINVAL;
+		}
+	} else {
+		IWL_ERR(mvm, "valid values none|siso|stbc|bfer\n");
+		ret = -EINVAL;
+	}
+	return ret ?: count;
+}
+
+#define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
+	_MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz, struct iwl_lq_sta)
+#define MVM_DEBUGFS_ADD_FILE_RS(name, parent, mode) do {		\
+		if (!debugfs_create_file(#name, mode, parent, lq_sta,	\
+					 &iwl_dbgfs_##name##_ops))	\
+			goto err;					\
+	} while (0)
+
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(ss_force, 32);
+
 static void rs_add_debugfs(void *mvm, void *mvm_sta, struct dentry *dir)
 {
 	struct iwl_lq_sta *lq_sta = mvm_sta;
+
 	debugfs_create_file("rate_scale_table", S_IRUSR | S_IWUSR, dir,
 			    lq_sta, &rs_sta_dbgfs_scale_table_ops);
 	debugfs_create_file("rate_stats_table", S_IRUSR, dir,
@@ -3515,6 +3594,11 @@ static void rs_add_debugfs(void *mvm, void *mvm_sta, struct dentry *dir)
 			  &lq_sta->tx_agg_tid_en);
 	debugfs_create_u8("reduced_tpc", S_IRUSR | S_IWUSR, dir,
 			  &lq_sta->pers.dbg_fixed_txp_reduction);
+
+	MVM_DEBUGFS_ADD_FILE_RS(ss_force, dir, S_IRUSR | S_IWUSR);
+	return;
+err:
+	IWL_ERR((struct iwl_mvm *)mvm, "Can't create debugfs entity\n");
 }
 
 static void rs_remove_debugfs(void *mvm, void *mvm_sta)
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index ba57f5a..dc4ef3d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -240,6 +240,13 @@ enum rs_column {
 	RS_COLUMN_INVALID,
 };
 
+enum rs_ss_force_opt {
+	RS_SS_FORCE_NONE = 0,
+	RS_SS_FORCE_STBC,
+	RS_SS_FORCE_BFER,
+	RS_SS_FORCE_SISO,
+};
+
 /* Packet stats per rate */
 struct rs_rate_stats {
 	u64 success;
@@ -324,6 +331,9 @@ struct iwl_lq_sta {
 	/* tx power reduce for this sta */
 	int tpc_reduce;
 
+	/* force STBC/BFER/SISO for testing */
+	enum rs_ss_force_opt ss_force;
+
 	/* persistent fields - initialized only once - keep last! */
 	struct lq_sta_pers {
 #ifdef CONFIG_MAC80211_DEBUGFS
-- 
1.9.1

