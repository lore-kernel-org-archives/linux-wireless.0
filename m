Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54833 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab0GOIY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jul 2010 04:24:56 -0400
Date: Thu, 15 Jul 2010 10:23:10 +0200
From: Dan Carpenter <error27@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: David Gibson <hermes@gibson.dropbear.id.au>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Kilroy <kilroyd@googlemail.com>,
	linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	kernel-janitors@vger.kernel.org
Subject: [patch] orinoco_usb: potential null dereference
Message-ID: <20100715082309.GE5164@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch complains that "upriv->read_urb" gets dereferenced before
checking for NULL.  It turns out that it's possible for
"upriv->read_urb" to be NULL so I added checks around the dereferences.

Also I remove an "if (upriv->bap_buf != NULL)" check because
"kfree(NULL) is OK.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 78f089b..11d5ec2 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1504,16 +1504,16 @@ static inline void ezusb_delete(struct ezusb_priv *upriv)
 	    ezusb_ctx_complete(list_entry(item,
 					  struct request_context, list));
 
-	if (upriv->read_urb->status == -EINPROGRESS)
+	if (upriv->read_urb && upriv->read_urb->status == -EINPROGRESS)
 		printk(KERN_ERR PFX "Some URB in progress\n");
 
 	mutex_unlock(&upriv->mtx);
 
-	kfree(upriv->read_urb->transfer_buffer);
-	if (upriv->bap_buf != NULL)
-		kfree(upriv->bap_buf);
-	if (upriv->read_urb != NULL)
+	if (upriv->read_urb) {
+		kfree(upriv->read_urb->transfer_buffer);
 		usb_free_urb(upriv->read_urb);
+	}
+	kfree(upriv->bap_buf);
 	if (upriv->dev) {
 		struct orinoco_private *priv = ndev_priv(upriv->dev);
 		orinoco_if_del(priv);
