Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:47879 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbYL3MuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 07:50:05 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] p54: implement FIF_OTHER_BSS filter setting
Date: Tue, 30 Dec 2008 13:48:29 +0100
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812301348.29992.chunkeey@web.de> (sfid-20081230_135014_152585_B9494DBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to STMicroelectronics' LMAC documentation, the P54_FILTER_TYPE_TRANSPARENT flag
"configures the receive frame filter to pass all frames without regard to type and address matching."

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-27 00:27:49.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-30 13:21:07.000000000 +0100
@@ -1555,7 +1555,8 @@ static int p54_setup_mac(struct ieee8021
 		 * "TRANSPARENT and PROMISCUOUS are mutually exclusive"
 		 * STSW45X0C LMAC API - page 12
 		 */
-		if ((priv->filter_flags & FIF_PROMISC_IN_BSS) &&
+		if (((priv->filter_flags & FIF_PROMISC_IN_BSS) ||
+		     (priv->filter_flags & FIF_OTHER_BSS)) &&
 		    (mode != P54_FILTER_TYPE_PROMISCUOUS))
 			mode |= P54_FILTER_TYPE_TRANSPARENT;
 	} else
@@ -1983,12 +1984,13 @@ static void p54_configure_filter(struct 
 	struct p54_common *priv = dev->priv;
 
 	*total_flags &= FIF_PROMISC_IN_BSS |
+			FIF_OTHER_BSS |
 			(*total_flags & FIF_PROMISC_IN_BSS) ?
 				FIF_FCSFAIL : 0;
 
 	priv->filter_flags = *total_flags;
 
-	if (changed_flags & FIF_PROMISC_IN_BSS)
+	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS))
 		p54_setup_mac(dev);
 }
 
