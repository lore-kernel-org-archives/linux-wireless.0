Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx5.mail.ru ([94.100.176.19]:8536 "EHLO mx5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZBOKJs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 05:09:48 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: [PATCH] orinoco: firmware: consistently compile out fw cache support
	if not requested
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Date: Sun, 15 Feb 2009 13:09:44 +0300
Message-ID: <20090215100902.7895.2670.stgit@cooker.net> (sfid-20090215_110953_730008_A2517ED9)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently part of support for FW caching is unconditionally compiled
in even if it is never used. Consistently remove caching support if
not requested by user.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

---

Patch is against wireless-next

 drivers/net/wireless/orinoco/fw.c      |   24 +++++++--------
 drivers/net/wireless/orinoco/fw.h      |   50 +++++++++++++++++++++++++++++---
 drivers/net/wireless/orinoco/main.c    |    8 +++--
 drivers/net/wireless/orinoco/orinoco.h |    2 +
 4 files changed, 62 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
index 7d2292d..842834e 100644
--- a/drivers/net/wireless/orinoco/fw.c
+++ b/drivers/net/wireless/orinoco/fw.c
@@ -79,7 +79,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	if (err)
 		goto free;
 
-	if (!priv->cached_fw) {
+	if (!orinoco_cached_fw_get(priv)) {
 		err = request_firmware(&fw_entry, firmware, priv->dev);
 
 		if (err) {
@@ -89,7 +89,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 			goto free;
 		}
 	} else
-		fw_entry = priv->cached_fw;
+		fw_entry = orinoco_cached_fw_get(priv);
 
 	hdr = (const struct orinoco_fw_header *) fw_entry->data;
 
@@ -132,7 +132,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 
 abort:
 	/* If we requested the firmware, release it. */
-	if (!priv->cached_fw)
+	if (!orinoco_cached_fw_get(priv))
 		release_firmware(fw_entry);
 
 free:
@@ -234,20 +234,20 @@ symbol_dl_firmware(struct orinoco_private *priv,
 	int ret;
 	const struct firmware *fw_entry;
 
-	if (!priv->cached_pri_fw) {
+	if (!orinoco_cached_pri_fw_get(priv)) {
 		if (request_firmware(&fw_entry, fw->pri_fw, priv->dev) != 0) {
 			printk(KERN_ERR "%s: Cannot find firmware: %s\n",
 			       dev->name, fw->pri_fw);
 			return -ENOENT;
 		}
 	} else
-		fw_entry = priv->cached_pri_fw;
+		fw_entry = orinoco_cached_pri_fw_get(priv);
 
 	/* Load primary firmware */
 	ret = symbol_dl_image(priv, fw, fw_entry->data,
 			      fw_entry->data + fw_entry->size, 0);
 
-	if (!priv->cached_pri_fw)
+	if (!orinoco_cached_pri_fw_get(priv))
 		release_firmware(fw_entry);
 	if (ret) {
 		printk(KERN_ERR "%s: Primary firmware download failed\n",
@@ -255,19 +255,19 @@ symbol_dl_firmware(struct orinoco_private *priv,
 		return ret;
 	}
 
-	if (!priv->cached_fw) {
+	if (!orinoco_cached_fw_get(priv)) {
 		if (request_firmware(&fw_entry, fw->sta_fw, priv->dev) != 0) {
 			printk(KERN_ERR "%s: Cannot find firmware: %s\n",
 			       dev->name, fw->sta_fw);
 			return -ENOENT;
 		}
 	} else
-		fw_entry = priv->cached_fw;
+		fw_entry = orinoco_cached_fw_get(priv);
 
 	/* Load secondary firmware */
 	ret = symbol_dl_image(priv, fw, fw_entry->data,
 			      fw_entry->data + fw_entry->size, 1);
-	if (!priv->cached_fw)
+	if (!orinoco_cached_fw_get(priv))
 		release_firmware(fw_entry);
 	if (ret) {
 		printk(KERN_ERR "%s: Secondary firmware download failed\n",
@@ -301,9 +301,9 @@ int orinoco_download(struct orinoco_private *priv)
 	return err;
 }
 
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 void orinoco_cache_fw(struct orinoco_private *priv, int ap)
 {
-#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 	const struct firmware *fw_entry = NULL;
 	const char *pri_fw;
 	const char *fw;
@@ -323,12 +323,10 @@ void orinoco_cache_fw(struct orinoco_private *priv, int ap)
 		if (request_firmware(&fw_entry, fw, priv->dev) == 0)
 			priv->cached_fw = fw_entry;
 	}
-#endif
 }
 
 void orinoco_uncache_fw(struct orinoco_private *priv)
 {
-#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 	if (priv->cached_pri_fw)
 		release_firmware(priv->cached_pri_fw);
 	if (priv->cached_fw)
@@ -336,5 +334,5 @@ void orinoco_uncache_fw(struct orinoco_private *priv)
 
 	priv->cached_pri_fw = NULL;
 	priv->cached_fw = NULL;
-#endif
 }
+#endif
diff --git a/drivers/net/wireless/orinoco/fw.h b/drivers/net/wireless/orinoco/fw.h
index 2290f08..1d1e02f 100644
--- a/drivers/net/wireless/orinoco/fw.h
+++ b/drivers/net/wireless/orinoco/fw.h
@@ -5,12 +5,52 @@
 #ifndef _ORINOCO_FW_H_
 #define _ORINOCO_FW_H_
 
-/* Forward declations */
-struct orinoco_private;
-
 int orinoco_download(struct orinoco_private *priv);
 
-void orinoco_cache_fw(struct orinoco_private *priv, int ap);
-void orinoco_uncache_fw(struct orinoco_private *priv);
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
+static inline const struct firmware *
+orinoco_cached_fw_get(struct orinoco_private *priv)
+{
+	return priv->cached_fw;
+}
+
+static inline const struct firmware *
+orinoco_cached_pri_fw_get(struct orinoco_private *priv)
+{
+	return priv->cached_pri_fw;
+}
+
+static inline void
+orinoco_cached_fw_set(struct orinoco_private *priv, struct firmware *fw)
+{
+	priv->cached_fw = fw;
+}
+
+static inline void
+orinoco_cached_pri_fw_set(struct orinoco_private *priv, struct firmware *fw)
+{
+	priv->cached_pri_fw = fw;
+}
+
+extern void orinoco_cache_fw(struct orinoco_private *priv, int ap);
+extern void orinoco_uncache_fw(struct orinoco_private *priv);
+#else
+static inline const struct firmware *
+orinoco_cached_fw_get(struct orinoco_private *priv)
+{
+	return NULL;
+}
+
+static inline const struct firmware *
+orinoco_cached_pri_fw_get(struct orinoco_private *priv)
+{
+	return NULL;
+}
+
+#define orinoco_cached_fw_set(priv, fw) do { } while (0)
+#define orinoco_cached_pri_fw_set(priv, fw) do { } while (0)
+#define orinoco_cache_fw(priv, ap) do { } while(0)
+#define orinoco_uncache_fw(priv) do { } while (0)
+#endif
 
 #endif /* _ORINOCO_FW_H_ */
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index f953059..2afab2a 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -89,6 +89,8 @@
 #include <linux/ieee80211.h>
 #include <net/iw_handler.h>
 
+#include "orinoco.h"
+
 #include "hermes_rid.h"
 #include "hermes_dld.h"
 #include "hw.h"
@@ -98,8 +100,6 @@
 #include "wext.h"
 #include "main.h"
 
-#include "orinoco.h"
-
 /********************************************************************/
 /* Module information                                               */
 /********************************************************************/
@@ -2580,8 +2580,8 @@ struct net_device
 	netif_carrier_off(dev);
 	priv->last_linkstatus = 0xffff;
 
-	priv->cached_pri_fw = NULL;
-	priv->cached_fw = NULL;
+	orinoco_cached_pri_fw_set(priv, NULL);
+	orinoco_cached_fw_set(priv, NULL);
 
 	/* Register PM notifiers */
 	orinoco_register_pm_notifier(priv);
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index f3f94b2..8e5a72c 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -159,9 +159,11 @@ struct orinoco_private {
 	unsigned int tkip_cm_active:1;
 	unsigned int key_mgmt:3;
 
+#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
 	/* Cached in memory firmware to use during ->resume. */
 	const struct firmware *cached_pri_fw;
 	const struct firmware *cached_fw;
+#endif
 
 	struct notifier_block pm_notifier;
 };

