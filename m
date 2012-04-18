Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39112 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab2DROpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/15] iwlwifi: don't use shared for the logger any more
Date: Wed, 18 Apr 2012 07:41:09 -0700
Message-Id: <1334760077-5714-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_165904_158636_B5767127)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Each modules will hold a pointer to struct device instead.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debug.h  |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-drv.c    |    3 +++
 drivers/net/wireless/iwlwifi/iwl-phy-db.c |    5 ++---
 drivers/net/wireless/iwlwifi/iwl-phy-db.h |    4 ++--
 7 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6771b6d..3f8b30d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1509,6 +1509,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	priv = IWL_OP_MODE_GET_DVM(op_mode);
 	priv->shrd = trans->shrd;
 	priv->trans = trans;
+	priv->dev = trans->dev;
 	priv->cfg = cfg;
 	priv->fw = fw;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 8a09d0c..67cd123 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -481,7 +481,7 @@ do {									\
 	if (!iwl_is_rfkill((m)))					\
 		IWL_ERR(m, fmt, ##args);				\
 	else								\
-		__iwl_err(trans(m)->dev, true,				\
+		__iwl_err((m)->dev, true,				\
 			  !iwl_have_debug_level(IWL_DL_RADIO),		\
 			  fmt, ##args);					\
 } while (0)
@@ -491,7 +491,7 @@ do {									\
 	if (!iwl_is_rfkill((m)))					\
 		IWL_ERR(m, fmt, ##args);				\
 	else								\
-		__iwl_err(trans(m)->dev, true, true, fmt, ##args);	\
+		__iwl_err((m)->dev, true, true, fmt, ##args);	\
 } while (0)
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index a6b32a1..8bae7cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -41,10 +41,10 @@ void __iwl_info(struct device *dev, const char *fmt, ...);
 void __iwl_crit(struct device *dev, const char *fmt, ...);
 
 /* No matter what is m (priv, bus, trans), this will work */
-#define IWL_ERR(m, f, a...) __iwl_err(trans(m)->dev, false, false, f, ## a)
-#define IWL_WARN(m, f, a...) __iwl_warn(trans(m)->dev, f, ## a)
-#define IWL_INFO(m, f, a...) __iwl_info(trans(m)->dev, f, ## a)
-#define IWL_CRIT(m, f, a...) __iwl_crit(trans(m)->dev, f, ## a)
+#define IWL_ERR(m, f, a...) __iwl_err((m)->dev, false, false, f, ## a)
+#define IWL_WARN(m, f, a...) __iwl_warn((m)->dev, f, ## a)
+#define IWL_INFO(m, f, a...) __iwl_info((m)->dev, f, ## a)
+#define IWL_CRIT(m, f, a...) __iwl_crit((m)->dev, f, ## a)
 
 #if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
 void __iwl_dbg(struct device *dev,
@@ -65,9 +65,9 @@ do {									\
 } while (0)
 
 #define IWL_DEBUG(m, level, fmt, args...)				\
-	__iwl_dbg(trans(m)->dev, level, false, __func__, fmt, ##args)
+	__iwl_dbg((m)->dev, level, false, __func__, fmt, ##args)
 #define IWL_DEBUG_LIMIT(m, level, fmt, args...)				\
-	__iwl_dbg(trans(m)->dev, level, true, __func__, fmt, ##args)
+	__iwl_dbg((m)->dev, level, true, __func__, fmt, ##args)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define iwl_print_hex_dump(m, level, p, len)				\
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 33d5878..185289f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -761,6 +761,7 @@ struct iwl_priv {
 	/*data shared among all the driver's layers */
 	struct iwl_shared *shrd;
 	struct iwl_trans *trans;
+	struct device *dev;		/* for debug prints only */
 	const struct iwl_cfg *cfg;
 	const struct iwl_fw *fw;
 	const struct iwl_lib_ops *lib;
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 8270623..1221a8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -80,6 +80,7 @@
  * @shrd: pointer to common shared structure
  * @op_mode: the running op_mode
  * @trans: transport layer
+ * @dev: for debug prints only
  * @cfg: configuration struct
  * @fw_index: firmware revision to try loading
  * @firmware_name: composite filename of ucode file to load
@@ -91,6 +92,7 @@ struct iwl_drv {
 	struct iwl_shared *shrd;
 	struct iwl_op_mode *op_mode;
 	struct iwl_trans *trans;
+	struct device *dev;
 	const struct iwl_cfg *cfg;
 
 	int fw_index;                   /* firmware we're trying to load */
@@ -898,6 +900,7 @@ struct iwl_drv *iwl_drv_start(struct iwl_shared *shrd,
 	/* For printing only - temporary until we change the logger */
 	drv->shrd = shrd;
 	drv->trans = trans;
+	drv->dev = trans->dev;
 	drv->cfg = cfg;
 
 	init_completion(&drv->request_firmware_complete);
diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
index 1a791af..f166955 100644
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
@@ -65,14 +65,13 @@
 #include <linux/string.h>
 
 #include "iwl-debug.h"
-#include "iwl-shared.h"
 #include "iwl-dev.h"
 
 #include "iwl-phy-db.h"
 
 #define CHANNEL_NUM_SIZE	4	/* num of channels in calib_ch size */
 
-struct iwl_phy_db *iwl_phy_db_init(struct iwl_shared *shrd)
+struct iwl_phy_db *iwl_phy_db_init(struct device *dev)
 {
 	struct iwl_phy_db *phy_db = kzalloc(sizeof(struct iwl_phy_db),
 					    GFP_KERNEL);
@@ -80,7 +79,7 @@ struct iwl_phy_db *iwl_phy_db_init(struct iwl_shared *shrd)
 	if (!phy_db)
 		return phy_db;
 
-	phy_db->shrd = shrd;
+	phy_db->dev = dev;
 
 	/* TODO: add default values of the phy db. */
 	return phy_db;
diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.h b/drivers/net/wireless/iwlwifi/iwl-phy-db.h
index 5e86305..c34c6a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.h
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.h
@@ -96,7 +96,7 @@ struct iwl_phy_db {
 	u32 channel_size;
 
 	/* for an access to the logger */
-	const struct iwl_shared *shrd;
+	struct device *dev;
 };
 
 enum iwl_phy_db_section_type {
@@ -114,7 +114,7 @@ struct iwl_phy_db_chg_txp {
 	__le16 max_channel_idx;
 } __packed;
 
-struct iwl_phy_db *iwl_phy_db_init(struct iwl_shared *shrd);
+struct iwl_phy_db *iwl_phy_db_init(struct device *dev);
 
 void iwl_phy_db_free(struct iwl_phy_db *phy_db);
 
-- 
1.7.0.4

