Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab2HUQ5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 12:57:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.6 1/2] iwlwifi: fix flow handler debug code
Date: Tue, 21 Aug 2012 18:57:10 +0200
Message-Id: <1345568231-20584-2-git-send-email-johannes@sipsolutions.net> (sfid-20120821_185722_929337_BC8EC510)
In-Reply-To: <1345568231-20584-1-git-send-email-johannes@sipsolutions.net>
References: <1345568231-20584-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

iwl_dbgfs_fh_reg_read() can cause crashes and/or
BUG_ON in slub because the ifdefs are wrong, the
code in iwl_dump_fh() should use DEBUGFS, not
DEBUG to protect the buffer writing code.

Also, while at it, clean up the arguments to the
function, some code and make it generally safer.

Cc: stable@vger.kernel.org
Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |    2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c       |    2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c    |   30 ++++++++++++++------------
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index d9694c5..4ffc18d 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -350,7 +350,7 @@ int iwl_queue_space(const struct iwl_queue *q);
 /*****************************************************
 * Error handling
 ******************************************************/
-int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display);
+int iwl_dump_fh(struct iwl_trans *trans, char **buf);
 void iwl_dump_csr(struct iwl_trans *trans);
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 39a6ca1..d1a61ba 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -555,7 +555,7 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 	}
 
 	iwl_dump_csr(trans);
-	iwl_dump_fh(trans, NULL, false);
+	iwl_dump_fh(trans, NULL);
 
 	iwl_op_mode_nic_error(trans->op_mode);
 }
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 939c2f7..1e86ea2 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1649,13 +1649,9 @@ static const char *get_fh_string(int cmd)
 #undef IWL_CMD
 }
 
-int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
+int iwl_dump_fh(struct iwl_trans *trans, char **buf)
 {
 	int i;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	int pos = 0;
-	size_t bufsz = 0;
-#endif
 	static const u32 fh_tbl[] = {
 		FH_RSCSR_CHNL0_STTS_WPTR_REG,
 		FH_RSCSR_CHNL0_RBDCB_BASE_REG,
@@ -1667,29 +1663,35 @@ int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
 		FH_TSSR_TX_STATUS_REG,
 		FH_TSSR_TX_ERROR_REG
 	};
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (display) {
-		bufsz = ARRAY_SIZE(fh_tbl) * 48 + 40;
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (buf) {
+		int pos = 0;
+		size_t bufsz = ARRAY_SIZE(fh_tbl) * 48 + 40;
+
 		*buf = kmalloc(bufsz, GFP_KERNEL);
 		if (!*buf)
 			return -ENOMEM;
+
 		pos += scnprintf(*buf + pos, bufsz - pos,
 				"FH register values:\n");
-		for (i = 0; i < ARRAY_SIZE(fh_tbl); i++) {
+
+		for (i = 0; i < ARRAY_SIZE(fh_tbl); i++)
 			pos += scnprintf(*buf + pos, bufsz - pos,
 				"  %34s: 0X%08x\n",
 				get_fh_string(fh_tbl[i]),
 				iwl_read_direct32(trans, fh_tbl[i]));
-		}
+
 		return pos;
 	}
 #endif
+
 	IWL_ERR(trans, "FH register values:\n");
-	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
+	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++)
 		IWL_ERR(trans, "  %34s: 0X%08x\n",
 			get_fh_string(fh_tbl[i]),
 			iwl_read_direct32(trans, fh_tbl[i]));
-	}
+
 	return 0;
 }
 
@@ -1982,11 +1984,11 @@ static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
 				     size_t count, loff_t *ppos)
 {
 	struct iwl_trans *trans = file->private_data;
-	char *buf;
+	char *buf = NULL;
 	int pos = 0;
 	ssize_t ret = -EFAULT;
 
-	ret = pos = iwl_dump_fh(trans, &buf, true);
+	ret = pos = iwl_dump_fh(trans, &buf);
 	if (buf) {
 		ret = simple_read_from_buffer(user_buf,
 					      count, ppos, buf, pos);
-- 
1.7.10.4

