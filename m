Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58094 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3GZI2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:28:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/30] iwlwifi: remove forward debugfs function declarations
Date: Fri, 26 Jul 2013 10:28:19 +0200
Message-Id: <1374827327-3464-3-git-send-email-johannes@sipsolutions.net> (sfid-20130726_102901_066069_A3D4AE5F)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to have 'forward' debugfs function declarations
as part of the macros because the macros are always used after
the static functions are defined already, so remove them.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/dvm/debugfs.c | 15 ---------------
 drivers/net/wireless/iwlwifi/pcie/trans.c  | 14 --------------
 2 files changed, 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index d532948..d94f8ab 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -69,19 +69,7 @@
 } while (0)
 
 /* file operation */
-#define DEBUGFS_READ_FUNC(name)                                         \
-static ssize_t iwl_dbgfs_##name##_read(struct file *file,               \
-					char __user *user_buf,          \
-					size_t count, loff_t *ppos);
-
-#define DEBUGFS_WRITE_FUNC(name)                                        \
-static ssize_t iwl_dbgfs_##name##_write(struct file *file,              \
-					const char __user *user_buf,    \
-					size_t count, loff_t *ppos);
-
-
 #define DEBUGFS_READ_FILE_OPS(name)                                     \
-	DEBUGFS_READ_FUNC(name);                                        \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
@@ -89,7 +77,6 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 };
 
 #define DEBUGFS_WRITE_FILE_OPS(name)                                    \
-	DEBUGFS_WRITE_FUNC(name);                                       \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
 	.open = simple_open,						\
@@ -98,8 +85,6 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 
 
 #define DEBUGFS_READ_WRITE_FILE_OPS(name)                               \
-	DEBUGFS_READ_FUNC(name);                                        \
-	DEBUGFS_WRITE_FUNC(name);                                       \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
 	.read = iwl_dbgfs_##name##_read,                                \
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 82194e8..bc908d3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1113,18 +1113,7 @@ void iwl_pcie_dump_csr(struct iwl_trans *trans)
 } while (0)
 
 /* file operation */
-#define DEBUGFS_READ_FUNC(name)                                         \
-static ssize_t iwl_dbgfs_##name##_read(struct file *file,               \
-					char __user *user_buf,          \
-					size_t count, loff_t *ppos);
-
-#define DEBUGFS_WRITE_FUNC(name)                                        \
-static ssize_t iwl_dbgfs_##name##_write(struct file *file,              \
-					const char __user *user_buf,    \
-					size_t count, loff_t *ppos);
-
 #define DEBUGFS_READ_FILE_OPS(name)					\
-	DEBUGFS_READ_FUNC(name);					\
 static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
@@ -1132,7 +1121,6 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 };
 
 #define DEBUGFS_WRITE_FILE_OPS(name)                                    \
-	DEBUGFS_WRITE_FUNC(name);                                       \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
 	.open = simple_open,						\
@@ -1140,8 +1128,6 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 };
 
 #define DEBUGFS_READ_WRITE_FILE_OPS(name)				\
-	DEBUGFS_READ_FUNC(name);					\
-	DEBUGFS_WRITE_FUNC(name);					\
 static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.write = iwl_dbgfs_##name##_write,				\
 	.read = iwl_dbgfs_##name##_read,				\
-- 
1.8.0

