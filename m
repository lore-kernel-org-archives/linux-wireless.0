Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24416 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbZGIRdn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:33:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/6] iwlwifi: fix permissions on debugfs files
Date: Thu,  9 Jul 2009 10:33:38 -0700
Message-Id: <1247160821-14989-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247160821-14989-3-git-send-email-reinette.chatre@intel.com>
References: <1247160821-14989-1-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-2-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

debugfs files are created with 644 permissions which gives everybody
read access. This presents a security issue if a user opens the file and
holds it open at the time the driver removes the file. At this point
invalid memory will be accessed.

Fix this by only allowing root to read debugfs files.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index e38ec81..0b9e824 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -49,7 +49,8 @@
 
 #define DEBUGFS_ADD_FILE(name, parent) do {                             \
 	dbgfs->dbgfs_##parent##_files.file_##name =                     \
-	debugfs_create_file(#name, 0644, dbgfs->dir_##parent, priv,     \
+	debugfs_create_file(#name, S_IWUSR | S_IRUSR,                   \
+				dbgfs->dir_##parent, priv,              \
 				&iwl_dbgfs_##name##_ops);               \
 	if (!(dbgfs->dbgfs_##parent##_files.file_##name))               \
 		goto err;                                               \
@@ -57,7 +58,8 @@
 
 #define DEBUGFS_ADD_BOOL(name, parent, ptr) do {                        \
 	dbgfs->dbgfs_##parent##_files.file_##name =                     \
-	debugfs_create_bool(#name, 0644, dbgfs->dir_##parent, ptr);     \
+	debugfs_create_bool(#name, S_IWUSR | S_IRUSR,                   \
+			    dbgfs->dir_##parent, ptr);                  \
 	if (IS_ERR(dbgfs->dbgfs_##parent##_files.file_##name)		\
 			|| !dbgfs->dbgfs_##parent##_files.file_##name)	\
 		goto err;                                               \
@@ -65,7 +67,7 @@
 
 #define DEBUGFS_ADD_X32(name, parent, ptr) do {                        \
 	dbgfs->dbgfs_##parent##_files.file_##name =                     \
-	debugfs_create_x32(#name, 0444, dbgfs->dir_##parent, ptr);     \
+	debugfs_create_x32(#name, S_IRUSR, dbgfs->dir_##parent, ptr);   \
 	if (IS_ERR(dbgfs->dbgfs_##parent##_files.file_##name)		\
 			|| !dbgfs->dbgfs_##parent##_files.file_##name)	\
 		goto err;                                               \
-- 
1.5.6.3

