Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7288 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbYBVFAq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 00:00:46 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 1/5] at76_usb: fix missing newlines in printk,
	improve some messages
To: linux-wireless@vger.kernel.org, at76c503a-develop@lists.berlios.de
Date: Fri, 22 Feb 2008 00:00:44 -0500
Message-ID: <20080222050044.11158.86655.stgit@dv.roinet.com> (sfid-20080222_050102_133539_9BF2A0C7)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's important to know which function failed.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 8db15bd..cdc258e 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1645,7 +1645,7 @@ static struct fwentry *at76_load_firmware(struct usb_device *udev,
 			   fwe->fwname);
 		dev_printk(KERN_ERR, &udev->dev,
 			   "you may need to download the firmware from "
-			   "http://developer.berlios.de/projects/at76c503a/");
+			   "http://developer.berlios.de/projects/at76c503a/\n");
 		goto exit;
 	}
 
@@ -1885,7 +1885,7 @@ static int at76_join(struct at76_priv *priv)
 				    sizeof(struct at76_req_join));
 
 	if (ret < 0) {
-		printk(KERN_ERR "%s: CMD_JOIN failed: %d",
+		printk(KERN_ERR "%s: at76_set_card_command failed: %d\n",
 		       wiphy_name(priv->hw->wiphy), ret);
 		return 0;
 	}
@@ -1893,7 +1893,7 @@ static int at76_join(struct at76_priv *priv)
 	ret = at76_wait_completion(priv, CMD_JOIN);
 	at76_dbg(DBG_MAC80211, "%s: CMD_JOIN returned: 0x%02x", __func__, ret);
 	if (ret != CMD_STATUS_COMPLETE) {
-		printk(KERN_ERR "%s: CMD_JOIN failed: %d",
+		printk(KERN_ERR "%s: at76_wait_completion failed: %d\n",
 		       wiphy_name(priv->hw->wiphy), ret);
 		return 0;
 	}
