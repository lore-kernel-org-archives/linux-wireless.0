Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:51433 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992992AbXBQRuL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 12:50:11 -0500
Date: Sat, 17 Feb 2007 18:24:44 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [PATCH] bcm43xx: fix for 4309
Message-ID: <20070217182444.5a7e3641@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BCM4309 devices aren't working properly as A PHYs aren't supported yet, but
we probe 802.11a cores anyway. This fixes it, while still allowing for A PHY code
to be developed in the future.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
----

John,

This is actually a bugfix so I think it should make into 2.6.21. This makes
BCM4309 cards working.

-- 
Ciao
Stefano

----

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
