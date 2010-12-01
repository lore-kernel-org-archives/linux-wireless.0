Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:34306 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab0LAMmC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 07:42:02 -0500
Date: Wed, 1 Dec 2010 13:42:16 +0100
From: David Chosrova <david.chosrova@libertysurf.fr>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, error27@gmail.com,
	andreamrl@tiscali.it, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] Staging: rtl8192u: check return code kmalloc.
Message-ID: <20101201124216.GA28979@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch checks the return code of  kmalloc when trying to allocate memory for priv->rx_urb in rtl8192_usb_initendpoints(), return -ENOMEM when failed.


Signed-off-by: David Chosrova <david.chosrova@libertysurf.fr>

---
Compiled

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 494f180..67ba8f7 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2203,6 +2203,8 @@ short rtl8192_usb_initendpoints(struct net_device *dev)
 
 	priv->rx_urb = kmalloc(sizeof(struct urb *) * (MAX_RX_URB+1),
 				GFP_KERNEL);
+	if (priv->rx_urb == NULL)
+		return -ENOMEM;
 
 #ifndef JACKSON_NEW_RX
 	for(i=0;i<(MAX_RX_URB+1);i++){
