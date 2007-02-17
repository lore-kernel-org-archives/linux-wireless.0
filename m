Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:46369 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992985AbXBQRqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 12:46:31 -0500
Message-ID: <45D73F71.6050803@lwfinger.net>
Date: Sat, 17 Feb 2007 11:46:25 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Stefano Brivio <stefano.brivio@polimi.it>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: fix for 4309
References: <20070217182444.5a7e3641@localhost>
In-Reply-To: <20070217182444.5a7e3641@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio wrote:
> BCM4309 devices aren't working properly as A PHYs aren't supported yet, but
> we probe 802.11a cores anyway. This fixes it, while still allowing for A PHY code
> to be developed in the future.
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
> ----
> 
> John,
> 
> This is actually a bugfix so I think it should make into 2.6.21. This makes
> BCM4309 cards working.
> 

--- linux-2.6.20/drivers/net/wireless/bcm43xx/bcm43xx_main.c.orig	2007-02-17 18:05:21.872891550 +0100
+++ linux-2.6.20/drivers/net/wireless/bcm43xx/bcm43xx_main.c	2007-02-17 18:14:59.620752491 +0100
@@ -2741,8 +2741,9 @@
 				 * dangling pins on the second core. Be careful
 				 * and ignore these cores here.
 				 */
-				if (bcm->pci_dev->device != 0x4324) {
-					dprintk(KERN_INFO PFX "Ignoring additional 802.11 core.\n");
+				if (1 /*bcm->pci_dev->device != 0x4324*/ ) {
+				/* TODO: A PHY */
+					dprintk(KERN_INFO PFX "Ignoring additional 802.11a core.\n");
 					continue;
 				}
 			}
_______________________________________________
