Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42204 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbZHEUYU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 16:24:20 -0400
Received: by mail-ew0-f214.google.com with SMTP id 10so285565ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 13:24:21 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 3/6] orinoco: pass orinoco_set_tkip_key the sequence lengths
Date: Wed,  5 Aug 2009 21:23:29 +0100
Message-Id: <1249503812-16921-4-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1249503812-16921-1-git-send-email-kilroyd@googlemail.com>
References: <1249503812-16921-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we store the keys for cfg80211, the sequence lengths will also be
stored. So avoid assuming the sequence lengths at this level.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hw.c   |   30 ++++++++++++++++++------------
 drivers/net/wireless/orinoco/hw.h   |    3 ++-
 drivers/net/wireless/orinoco/wext.c |    2 +-
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index d069fe8..35516a9 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -905,11 +905,12 @@ int __orinoco_hw_setup_enc(struct orinoco_private *priv)
 }
 
 /* key must be 32 bytes, including the tx and rx MIC keys.
- * rsc must be 8 bytes
- * tsc must be 8 bytes or NULL
+ * rsc must be NULL or up to 8 bytes
+ * tsc must be NULL or up to 8 bytes
  */
 int __orinoco_hw_set_tkip_key(struct orinoco_private *priv, int key_idx,
-			      int set_tx, u8 *key, u8 *rsc, u8 *tsc)
+			      int set_tx, u8 *key, u8 *rsc, size_t rsc_len,
+			      u8 *tsc, size_t tsc_len)
 {
 	struct {
 		__le16 idx;
@@ -934,17 +935,22 @@ int __orinoco_hw_set_tkip_key(struct orinoco_private *priv, int key_idx,
 	memcpy(buf.key, key,
 	       sizeof(buf.key) + sizeof(buf.tx_mic) + sizeof(buf.rx_mic));
 
-	if (rsc == NULL)
-		memset(buf.rsc, 0, sizeof(buf.rsc));
-	else
-		memcpy(buf.rsc, rsc, sizeof(buf.rsc));
+	if (rsc_len > sizeof(buf.rsc))
+		rsc_len = sizeof(buf.rsc);
+
+	if (tsc_len > sizeof(buf.tsc))
+		tsc_len = sizeof(buf.tsc);
+
+	memset(buf.rsc, 0, sizeof(buf.rsc));
+	memset(buf.tsc, 0, sizeof(buf.tsc));
+
+	if (rsc != NULL)
+		memcpy(buf.rsc, rsc, rsc_len);
 
-	if (tsc == NULL) {
-		memset(buf.tsc, 0, sizeof(buf.tsc));
+	if (tsc != NULL)
+		memcpy(buf.tsc, tsc, tsc_len);
+	else
 		buf.tsc[4] = 0x10;
-	} else {
-		memcpy(buf.tsc, tsc, sizeof(buf.tsc));
-	}
 
 	/* Wait upto 100ms for tx queue to empty */
 	for (k = 100; k > 0; k--) {
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
index 27b4276..33a31fa 100644
--- a/drivers/net/wireless/orinoco/hw.h
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -38,7 +38,8 @@ int __orinoco_hw_set_wap(struct orinoco_private *priv);
 int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv);
 int __orinoco_hw_setup_enc(struct orinoco_private *priv);
 int __orinoco_hw_set_tkip_key(struct orinoco_private *priv, int key_idx,
-			      int set_tx, u8 *key, u8 *rsc, u8 *tsc);
+			      int set_tx, u8 *key, u8 *rsc, size_t rsc_len,
+			      u8 *tsc, size_t tsc_len);
 int orinoco_clear_tkip_key(struct orinoco_private *priv, int key_idx);
 int __orinoco_hw_set_multicast_list(struct orinoco_private *priv,
 				    struct dev_addr_list *mc_list,
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 33d81b4..7e18bb4 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -863,7 +863,7 @@ static int orinoco_ioctl_set_encodeext(struct net_device *dev,
 			err = __orinoco_hw_set_tkip_key(priv, idx,
 				 ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY,
 				 (u8 *) &priv->tkip_key[idx],
-				 tkip_iv, NULL);
+				 tkip_iv, ORINOCO_SEQ_LEN, NULL, 0);
 			if (err)
 				printk(KERN_ERR "%s: Error %d setting TKIP key"
 				       "\n", dev->name, err);
-- 
1.6.3.3

