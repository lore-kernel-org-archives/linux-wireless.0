Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57356 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab0HUKul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Aug 2010 06:50:41 -0400
Received: by wyb32 with SMTP id 32so4722301wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 21 Aug 2010 03:50:40 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: dkirjanov@kernel.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: Fix walking past the end of the buffer
Date: Sat, 21 Aug 2010 12:08:15 +0100
Message-Id: <1282388895-30045-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix walking past the end of the bitrate_table array
in the case when the loop counter == BITRATE_TABLE_SIZE.

Reported by: Denis Kirjanov <dkirjanov@kernel.org>
Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---

This patch improves upon Denis' original by reporting the error to
the caller and handling it there instead of passing an invalid
bitrate to userspace. In this case we can ignore the error and send
userspace the known configuration.

---
 drivers/net/wireless/orinoco/hw.c   |    9 ++++++---
 drivers/net/wireless/orinoco/wext.c |   11 +++++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 077baa8..b4772c1 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -762,14 +762,17 @@ int orinoco_hw_get_act_bitrate(struct orinoco_private *priv, int *bitrate)
 	case FIRMWARE_TYPE_INTERSIL: /* Intersil style rate */
 	case FIRMWARE_TYPE_SYMBOL: /* Symbol style rate */
 		for (i = 0; i < BITRATE_TABLE_SIZE; i++)
-			if (bitrate_table[i].intersil_txratectrl == val)
+			if (bitrate_table[i].intersil_txratectrl == val) {
+				*bitrate = bitrate_table[i].bitrate * 100000;
 				break;
+			}
 
-		if (i >= BITRATE_TABLE_SIZE)
+		if (i >= BITRATE_TABLE_SIZE) {
 			printk(KERN_INFO "%s: Unable to determine current bitrate (0x%04hx)\n",
 			       priv->ndev->name, val);
+			err = -EIO;
+		}
 
-		*bitrate = bitrate_table[i].bitrate * 100000;
 		break;
 	default:
 		BUG();
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index cf7be1e..93505f9 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -589,8 +589,15 @@ static int orinoco_ioctl_getrate(struct net_device *dev,
 
 	/* If the interface is running we try to find more about the
 	   current mode */
-	if (netif_running(dev))
-		err = orinoco_hw_get_act_bitrate(priv, &bitrate);
+	if (netif_running(dev)) {
+		int act_bitrate;
+		int lerr;
+
+		/* Ignore errors if we can't get the actual bitrate */
+		lerr = orinoco_hw_get_act_bitrate(priv, &act_bitrate);
+		if (!lerr)
+			bitrate = act_bitrate;
+	}
 
 	orinoco_unlock(priv, &flags);
 
-- 
1.7.1

