Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17554 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYLBUNP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Subject: [PATCH 09/11] iwlwifi: store ucode version number
Date: Tue,  2 Dec 2008 12:14:05 -0800
Message-Id: <1228248847-10424-10-git-send-email-reinette.chatre@intel.com> (sfid-20081202_213859_629704_8B3B5ADF)
In-Reply-To: <1228248847-10424-9-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-4-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-5-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-6-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-7-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-8-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chatre, Reinette <reinette.chatre@intel.com>

We store the ucode version number as part of
iwl_priv/iwl3945_priv. This enables us to determine
if particular ucode has support for features in order
to have driver support more than one ucode API.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-3945.h          |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   12 +++++++++---
 drivers/net/wireless/iwlwifi/iwl-commands.h      |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    4 +++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c      |   12 +++++++++---
 6 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 8772d9d..1bec123 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -69,6 +69,12 @@
 #ifndef __iwl_3945_commands_h__
 #define __iwl_3945_commands_h__
 
+/* uCode version contains 4 values: Major/Minor/API/Serial */
+#define IWL_UCODE_MAJOR(ver)	(((ver) & 0xFF000000) >> 24)
+#define IWL_UCODE_MINOR(ver)	(((ver) & 0x00FF0000) >> 16)
+#define IWL_UCODE_API(ver)	(((ver) & 0x0000FF00) >> 8)
+#define IWL_UCODE_SERIAL(ver)	((ver) & 0x000000FF)
+
 enum {
 	REPLY_ALIVE = 0x1,
 	REPLY_ERROR = 0x2,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 2a924c1..972c454 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -505,7 +505,7 @@ struct fw_desc {
 
 /* uCode file layout */
 struct iwl3945_ucode {
-	__le32 ver;		/* major/minor/subminor */
+	__le32 ver;		/* major/minor/API/serial */
 	__le32 inst_size;	/* bytes of runtime instructions */
 	__le32 data_size;	/* bytes of runtime data */
 	__le32 init_size;	/* bytes of initialization instructions */
@@ -762,6 +762,8 @@ struct iwl3945_priv {
 	void __iomem *hw_base;
 
 	/* uCode images, save to reload in case of failure */
+	u32 ucode_ver;			/* ucode version, copy of
+					   iwl3945_ucode.ver */
 	struct fw_desc ucode_code;	/* runtime inst */
 	struct fw_desc ucode_data;	/* runtime data original */
 	struct fw_desc ucode_data_backup;	/* runtime data save/restore */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4bdd33b..c906260 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1579,7 +1579,7 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	const char *name = priv->cfg->fw_name;
 	u8 *src;
 	size_t len;
-	u32 ver, inst_size, data_size, init_size, init_data_size, boot_size;
+	u32 inst_size, data_size, init_size, init_data_size, boot_size;
 
 	/* Ask kernel firmware_class module to get the boot firmware off disk.
 	 * request_firmware() is synchronous, file is in memory on return. */
@@ -1603,14 +1603,20 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	/* Data from ucode file:  header followed by uCode images */
 	ucode = (void *)ucode_raw->data;
 
-	ver = le32_to_cpu(ucode->ver);
+	priv->ucode_ver = le32_to_cpu(ucode->ver);
 	inst_size = le32_to_cpu(ucode->inst_size);
 	data_size = le32_to_cpu(ucode->data_size);
 	init_size = le32_to_cpu(ucode->init_size);
 	init_data_size = le32_to_cpu(ucode->init_data_size);
 	boot_size = le32_to_cpu(ucode->boot_size);
 
-	IWL_DEBUG_INFO("f/w package hdr ucode version = 0x%x\n", ver);
+	IWL_DEBUG_INFO("f/w package hdr ucode version raw = 0x%x\n",
+		       priv->ucode_ver);
+	IWL_DEBUG_INFO("f/w package hdr ucode version = %u.%u.%u.%u\n",
+		       IWL_UCODE_MAJOR(priv->ucode_ver),
+		       IWL_UCODE_MINOR(priv->ucode_ver),
+		       IWL_UCODE_API(priv->ucode_ver),
+		       IWL_UCODE_SERIAL(priv->ucode_ver));
 	IWL_DEBUG_INFO("f/w package hdr runtime inst size = %u\n",
 		       inst_size);
 	IWL_DEBUG_INFO("f/w package hdr runtime data size = %u\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index d6196b9..0db151b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -69,6 +69,12 @@
 #ifndef __iwl_commands_h__
 #define __iwl_commands_h__
 
+/* uCode version contains 4 values: Major/Minor/API/Serial */
+#define IWL_UCODE_MAJOR(ver)	(((ver) & 0xFF000000) >> 24)
+#define IWL_UCODE_MINOR(ver)	(((ver) & 0x00FF0000) >> 16)
+#define IWL_UCODE_API(ver)	(((ver) & 0x0000FF00) >> 8)
+#define IWL_UCODE_SERIAL(ver)	((ver) & 0x000000FF)
+
 enum {
 	REPLY_ALIVE = 0x1,
 	REPLY_ERROR = 0x2,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5f6805b..a19fbb5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -462,7 +462,7 @@ struct fw_desc {
 
 /* uCode file layout */
 struct iwl_ucode {
-	__le32 ver;		/* major/minor/subminor */
+	__le32 ver;		/* major/minor/API/serial */
 	__le32 inst_size;	/* bytes of runtime instructions */
 	__le32 data_size;	/* bytes of runtime data */
 	__le32 init_size;	/* bytes of initialization instructions */
@@ -843,6 +843,8 @@ struct iwl_priv {
 	u8   rev_id;
 
 	/* uCode images, save to reload in case of failure */
+	u32 ucode_ver;			/* version of ucode, copy of
+					   iwl_ucode.ver */
 	struct fw_desc ucode_code;	/* runtime inst */
 	struct fw_desc ucode_data;	/* runtime data original */
 	struct fw_desc ucode_data_backup;	/* runtime data save/restore */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 074b43c..c003814 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5341,7 +5341,7 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	const char *name = priv->cfg->fw_name;
 	u8 *src;
 	size_t len;
-	u32 ver, inst_size, data_size, init_size, init_data_size, boot_size;
+	u32 inst_size, data_size, init_size, init_data_size, boot_size;
 
 	/* Ask kernel firmware_class module to get the boot firmware off disk.
 	 * request_firmware() is synchronous, file is in memory on return. */
@@ -5365,14 +5365,20 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	/* Data from ucode file:  header followed by uCode images */
 	ucode = (void *)ucode_raw->data;
 
-	ver = le32_to_cpu(ucode->ver);
+	priv->ucode_ver = le32_to_cpu(ucode->ver);
 	inst_size = le32_to_cpu(ucode->inst_size);
 	data_size = le32_to_cpu(ucode->data_size);
 	init_size = le32_to_cpu(ucode->init_size);
 	init_data_size = le32_to_cpu(ucode->init_data_size);
 	boot_size = le32_to_cpu(ucode->boot_size);
 
-	IWL_DEBUG_INFO("f/w package hdr ucode version = 0x%x\n", ver);
+	IWL_DEBUG_INFO("f/w package hdr ucode version raw = 0x%x\n",
+		       priv->ucode_ver);
+	IWL_DEBUG_INFO("f/w package hdr ucode version = %u.%u.%u.%u\n",
+		       IWL_UCODE_MAJOR(priv->ucode_ver),
+		       IWL_UCODE_MINOR(priv->ucode_ver),
+		       IWL_UCODE_API(priv->ucode_ver),
+		       IWL_UCODE_SERIAL(priv->ucode_ver));
 	IWL_DEBUG_INFO("f/w package hdr runtime inst size = %u\n", inst_size);
 	IWL_DEBUG_INFO("f/w package hdr runtime data size = %u\n", data_size);
 	IWL_DEBUG_INFO("f/w package hdr init inst size = %u\n", init_size);
-- 
1.5.4.3

