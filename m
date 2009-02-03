Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43284 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZBCUmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 15:42:25 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so2846565ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 12:42:25 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 10/17] orinoco: Move MIC helpers into new file
Date: Tue,  3 Feb 2009 20:40:32 +0000
Message-Id: <1233693639-8608-11-git-send-email-kilroyd@googlemail.com> (sfid-20090203_214230_053053_AFD95279)
In-Reply-To: <1233693639-8608-10-git-send-email-kilroyd@googlemail.com>
References: <1233693639-8608-1-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-2-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-3-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-4-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-5-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-6-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-7-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-8-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-9-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-10-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional change.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/Makefile |    2 +-
 drivers/net/wireless/orinoco/main.c   |   72 +-----------------------------
 drivers/net/wireless/orinoco/mic.c    |   79 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/orinoco/mic.h    |   22 +++++++++
 4 files changed, 103 insertions(+), 72 deletions(-)
 create mode 100644 drivers/net/wireless/orinoco/mic.c
 create mode 100644 drivers/net/wireless/orinoco/mic.h

diff --git a/drivers/net/wireless/orinoco/Makefile b/drivers/net/wireless/orinoco/Makefile
index efde451..9d3ef29 100644
--- a/drivers/net/wireless/orinoco/Makefile
+++ b/drivers/net/wireless/orinoco/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the orinoco wireless device drivers.
 #
-orinoco-objs := main.o scan.o
+orinoco-objs := main.o mic.o scan.o
 
 obj-$(CONFIG_HERMES)		+= orinoco.o hermes.o hermes_dld.o
 obj-$(CONFIG_PCMCIA_HERMES)	+= orinoco_cs.o
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 3307119..9c2aba4 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -90,12 +90,10 @@
 #include <linux/ieee80211.h>
 #include <net/iw_handler.h>
 
-#include <linux/scatterlist.h>
-#include <linux/crypto.h>
-
 #include "hermes_rid.h"
 #include "hermes_dld.h"
 #include "scan.h"
+#include "mic.h"
 
 #include "orinoco.h"
 
@@ -255,74 +253,6 @@ static int __orinoco_program_rids(struct net_device *dev);
 static void __orinoco_set_multicast_list(struct net_device *dev);
 
 /********************************************************************/
-/* Michael MIC crypto setup                                         */
-/********************************************************************/
-#define MICHAEL_MIC_LEN 8
-static int orinoco_mic_init(struct orinoco_private *priv)
-{
-	priv->tx_tfm_mic = crypto_alloc_hash("michael_mic", 0, 0);
-	if (IS_ERR(priv->tx_tfm_mic)) {
-		printk(KERN_DEBUG "orinoco_mic_init: could not allocate "
-		       "crypto API michael_mic\n");
-		priv->tx_tfm_mic = NULL;
-		return -ENOMEM;
-	}
-
-	priv->rx_tfm_mic = crypto_alloc_hash("michael_mic", 0, 0);
-	if (IS_ERR(priv->rx_tfm_mic)) {
-		printk(KERN_DEBUG "orinoco_mic_init: could not allocate "
-		       "crypto API michael_mic\n");
-		priv->rx_tfm_mic = NULL;
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static void orinoco_mic_free(struct orinoco_private *priv)
-{
-	if (priv->tx_tfm_mic)
-		crypto_free_hash(priv->tx_tfm_mic);
-	if (priv->rx_tfm_mic)
-		crypto_free_hash(priv->rx_tfm_mic);
-}
-
-static int michael_mic(struct crypto_hash *tfm_michael, u8 *key,
-		       u8 *da, u8 *sa, u8 priority,
-		       u8 *data, size_t data_len, u8 *mic)
-{
-	struct hash_desc desc;
-	struct scatterlist sg[2];
-	u8 hdr[ETH_HLEN + 2]; /* size of header + padding */
-
-	if (tfm_michael == NULL) {
-		printk(KERN_WARNING "michael_mic: tfm_michael == NULL\n");
-		return -1;
-	}
-
-	/* Copy header into buffer. We need the padding on the end zeroed */
-	memcpy(&hdr[0], da, ETH_ALEN);
-	memcpy(&hdr[ETH_ALEN], sa, ETH_ALEN);
-	hdr[ETH_ALEN*2] = priority;
-	hdr[ETH_ALEN*2+1] = 0;
-	hdr[ETH_ALEN*2+2] = 0;
-	hdr[ETH_ALEN*2+3] = 0;
-
-	/* Use scatter gather to MIC header and data in one go */
-	sg_init_table(sg, 2);
-	sg_set_buf(&sg[0], hdr, sizeof(hdr));
-	sg_set_buf(&sg[1], data, data_len);
-
-	if (crypto_hash_setkey(tfm_michael, key, MIC_KEYLEN))
-		return -1;
-
-	desc.tfm = tfm_michael;
-	desc.flags = 0;
-	return crypto_hash_digest(&desc, sg, data_len + sizeof(hdr),
-				  mic);
-}
-
-/********************************************************************/
 /* Internal helper functions                                        */
 /********************************************************************/
 
diff --git a/drivers/net/wireless/orinoco/mic.c b/drivers/net/wireless/orinoco/mic.c
new file mode 100644
index 0000000..c39d9ea
--- /dev/null
+++ b/drivers/net/wireless/orinoco/mic.c
@@ -0,0 +1,79 @@
+/* Orinoco MIC helpers
+ *
+ * See copyright notice in main.c
+ */
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/if_ether.h>
+#include <linux/scatterlist.h>
+#include <linux/crypto.h>
+
+#include "orinoco.h"
+#include "mic.h"
+
+/********************************************************************/
+/* Michael MIC crypto setup                                         */
+/********************************************************************/
+int orinoco_mic_init(struct orinoco_private *priv)
+{
+	priv->tx_tfm_mic = crypto_alloc_hash("michael_mic", 0, 0);
+	if (IS_ERR(priv->tx_tfm_mic)) {
+		printk(KERN_DEBUG "orinoco_mic_init: could not allocate "
+		       "crypto API michael_mic\n");
+		priv->tx_tfm_mic = NULL;
+		return -ENOMEM;
+	}
+
+	priv->rx_tfm_mic = crypto_alloc_hash("michael_mic", 0, 0);
+	if (IS_ERR(priv->rx_tfm_mic)) {
+		printk(KERN_DEBUG "orinoco_mic_init: could not allocate "
+		       "crypto API michael_mic\n");
+		priv->rx_tfm_mic = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void orinoco_mic_free(struct orinoco_private *priv)
+{
+	if (priv->tx_tfm_mic)
+		crypto_free_hash(priv->tx_tfm_mic);
+	if (priv->rx_tfm_mic)
+		crypto_free_hash(priv->rx_tfm_mic);
+}
+
+int michael_mic(struct crypto_hash *tfm_michael, u8 *key,
+		u8 *da, u8 *sa, u8 priority,
+		u8 *data, size_t data_len, u8 *mic)
+{
+	struct hash_desc desc;
+	struct scatterlist sg[2];
+	u8 hdr[ETH_HLEN + 2]; /* size of header + padding */
+
+	if (tfm_michael == NULL) {
+		printk(KERN_WARNING "michael_mic: tfm_michael == NULL\n");
+		return -1;
+	}
+
+	/* Copy header into buffer. We need the padding on the end zeroed */
+	memcpy(&hdr[0], da, ETH_ALEN);
+	memcpy(&hdr[ETH_ALEN], sa, ETH_ALEN);
+	hdr[ETH_ALEN*2] = priority;
+	hdr[ETH_ALEN*2+1] = 0;
+	hdr[ETH_ALEN*2+2] = 0;
+	hdr[ETH_ALEN*2+3] = 0;
+
+	/* Use scatter gather to MIC header and data in one go */
+	sg_init_table(sg, 2);
+	sg_set_buf(&sg[0], hdr, sizeof(hdr));
+	sg_set_buf(&sg[1], data, data_len);
+
+	if (crypto_hash_setkey(tfm_michael, key, MIC_KEYLEN))
+		return -1;
+
+	desc.tfm = tfm_michael;
+	desc.flags = 0;
+	return crypto_hash_digest(&desc, sg, data_len + sizeof(hdr),
+				  mic);
+}
diff --git a/drivers/net/wireless/orinoco/mic.h b/drivers/net/wireless/orinoco/mic.h
new file mode 100644
index 0000000..bc1db16
--- /dev/null
+++ b/drivers/net/wireless/orinoco/mic.h
@@ -0,0 +1,22 @@
+/* Orinoco MIC helpers
+ *
+ * See copyright notice in main.c
+ */
+#ifndef _ORINOCO_MIC_H_
+#define _ORINOCO_MIC_H_
+
+#include <linux/types.h>
+
+#define MICHAEL_MIC_LEN 8
+
+/* Forward declarations */
+struct orinoco_private;
+struct crypto_hash;
+
+int orinoco_mic_init(struct orinoco_private *priv);
+void orinoco_mic_free(struct orinoco_private *priv);
+int michael_mic(struct crypto_hash *tfm_michael, u8 *key,
+		u8 *da, u8 *sa, u8 priority,
+		u8 *data, size_t data_len, u8 *mic);
+
+#endif /* ORINOCO_MIC_H */
-- 
1.6.0.6

