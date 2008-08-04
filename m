Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45768 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759484AbYHDVOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 17:14:51 -0400
Date: Mon, 04 Aug 2008 16:14:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: Fix regression due to commit b19fa1f
Message-ID: <4897714b.z7H23Rca9Z4lOo4Q%Larry.Finger@lwfinger.net> (sfid-20080804_231456_051077_1A4A941D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit b19fa1fa91845234961c64dbd564671aa7c0fd27, the configuration
parameter NETDEVICES_MULTIQUEUE was eliminated making multiple TX queues
the normal behavior. For p54usb, enabling multiple queues broke the driver.

The real failure is not known, but a temporary hack that forces only one
queue is presented here.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is clearly not the best fix, but there has been no action so far, and
it does fix the b19fa1f regression. Let's push this up to 2.6.27.

Larry


Index: linux-2.6/drivers/net/wireless/p54/p54common.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/p54/p54common.c
+++ linux-2.6/drivers/net/wireless/p54/p54common.c
@@ -150,7 +150,7 @@ void p54_parse_firmware(struct ieee80211
 		priv->tx_stats[1].limit = 4;
 		priv->tx_stats[2].limit = 3;
 		priv->tx_stats[3].limit = 1;
-		dev->queues = 4;
+		dev->queues = 1; /* temp. hack, set to 1 as 4 breaks p54usb */
 	}
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);
