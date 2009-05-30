Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:11165 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763386AbZE3Rh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:37:29 -0400
Received: by ey-out-2122.google.com with SMTP id 22so243532eye.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:37:31 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 08/23] orinoco: Move FID allocation to hw.c
Date: Sat, 30 May 2009 18:36:42 +0100
Message-Id: <1243705017-8784-9-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is part of refactorring the initialisation code so that we can
load the firmware before registerring with netdev.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hw.c   |   23 +++++++++++++++++++++++
 drivers/net/wireless/orinoco/hw.h   |    1 +
 drivers/net/wireless/orinoco/main.c |   25 ++-----------------------
 3 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 40dc25c..0f6426d 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -15,6 +15,9 @@
 
 #define SYMBOL_MAX_VER_LEN	(14)
 
+/* Symbol firmware has a bug allocating buffers larger than this */
+#define TX_NICBUF_SIZE_BUG	1585
+
 /********************************************************************/
 /* Data tables                                                      */
 /********************************************************************/
@@ -364,6 +367,26 @@ out:
 	return err;
 }
 
+int orinoco_hw_allocate_fid(struct orinoco_private *priv)
+{
+	struct net_device *dev = priv->ndev;
+	struct hermes *hw = &priv->hw;
+	int err;
+
+	err = hermes_allocate(hw, priv->nicbuf_size, &priv->txfid);
+	if (err == -EIO && priv->nicbuf_size > TX_NICBUF_SIZE_BUG) {
+		/* Try workaround for old Symbol firmware bug */
+		priv->nicbuf_size = TX_NICBUF_SIZE_BUG;
+		err = hermes_allocate(hw, priv->nicbuf_size, &priv->txfid);
+
+		printk(KERN_WARNING "%s: firmware ALLOC bug detected "
+		       "(old Symbol firmware?). Work around %s\n",
+		       dev->name, err ? "failed!" : "ok.");
+	}
+
+	return err;
+}
+
 int orinoco_get_bitratemode(int bitrate, int automatic)
 {
 	int ratemode = -1;
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
index 6186e44..89277de 100644
--- a/drivers/net/wireless/orinoco/hw.h
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -25,6 +25,7 @@ struct dev_addr_list;
 
 int determine_fw_capabilities(struct orinoco_private *priv);
 int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr);
+int orinoco_hw_allocate_fid(struct orinoco_private *priv);
 int orinoco_get_bitratemode(int bitrate, int automatic);
 void orinoco_get_ratemode_cfg(int ratemode, int *bitrate, int *automatic);
 
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 0fe9420..58a48db 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -147,7 +147,6 @@ static const u8 encaps_hdr[] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
 					    * how many events the
 					    * device could
 					    * legitimately generate */
-#define TX_NICBUF_SIZE_BUG	1585		/* Bug in Symbol firmware */
 
 #define DUMMY_FID		0xFFFF
 
@@ -1574,26 +1573,6 @@ int __orinoco_down(struct net_device *dev)
 }
 EXPORT_SYMBOL(__orinoco_down);
 
-static int orinoco_allocate_fid(struct net_device *dev)
-{
-	struct orinoco_private *priv = netdev_priv(dev);
-	struct hermes *hw = &priv->hw;
-	int err;
-
-	err = hermes_allocate(hw, priv->nicbuf_size, &priv->txfid);
-	if (err == -EIO && priv->nicbuf_size > TX_NICBUF_SIZE_BUG) {
-		/* Try workaround for old Symbol firmware bug */
-		priv->nicbuf_size = TX_NICBUF_SIZE_BUG;
-		err = hermes_allocate(hw, priv->nicbuf_size, &priv->txfid);
-
-		printk(KERN_WARNING "%s: firmware ALLOC bug detected "
-		       "(old Symbol firmware?). Work around %s\n",
-		       dev->name, err ? "failed!" : "ok.");
-	}
-
-	return err;
-}
-
 int orinoco_reinit_firmware(struct net_device *dev)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
@@ -1607,7 +1586,7 @@ int orinoco_reinit_firmware(struct net_device *dev)
 			priv->do_fw_download = 0;
 	}
 	if (!err)
-		err = orinoco_allocate_fid(dev);
+		err = orinoco_hw_allocate_fid(priv);
 
 	return err;
 }
@@ -2167,7 +2146,7 @@ static int orinoco_init(struct net_device *dev)
 	if (err)
 		goto out;
 
-	err = orinoco_allocate_fid(dev);
+	err = orinoco_hw_allocate_fid(priv);
 	if (err) {
 		printk(KERN_ERR "%s: failed to allocate NIC buffer!\n",
 		       dev->name);
-- 
1.6.0.6

