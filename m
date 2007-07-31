Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4710 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbXGaVev (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 17:34:51 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 60] drivers/net/wireless/prism54/oid_mgt.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 23:34:50 +0200
Cc: kernel-janitors@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Message-Id: <200707312334.51067.m.kozlowski@tuxland.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/net/wireless/prism54/oid_mgt.c | 25377 -> 25297 (-80 bytes)
 drivers/net/wireless/prism54/oid_mgt.o | 128460 -> 128284 (-176 bytes)

 drivers/net/wireless/prism54/oid_mgt.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/net/wireless/prism54/oid_mgt.c	2007-07-26 13:07:43.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/net/wireless/prism54/oid_mgt.c	2007-07-30 00:27:44.000000000 +0200
@@ -244,13 +244,11 @@ mgt_init(islpci_private *priv)
 	/* Alloc the cache */
 	for (i = 0; i < OID_NUM_LAST; i++) {
 		if (isl_oid[i].flags & OID_FLAG_CACHED) {
-			priv->mib[i] = kmalloc(isl_oid[i].size *
+			priv->mib[i] = kzalloc(isl_oid[i].size *
 					       (isl_oid[i].range + 1),
 					       GFP_KERNEL);
 			if (!priv->mib[i])
 				return -ENOMEM;
-			memset(priv->mib[i], 0,
-			       isl_oid[i].size * (isl_oid[i].range + 1));
 		} else
 			priv->mib[i] = NULL;
 	}
