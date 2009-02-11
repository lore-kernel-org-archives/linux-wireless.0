Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:37652 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbZBKUv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 15:51:26 -0500
Received: by bwz5 with SMTP id 5so572598bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 12:51:24 -0800 (PST)
Message-ID: <49933A53.8050901@gmail.com> (sfid-20090211_215130_879215_D70404C2)
Date: Wed, 11 Feb 2009 21:51:31 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: jt@hpl.hp.com
CC: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] wavelan: Test arraysize before an element of the array.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Test arraysize before an element of the array.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/wavelan.c b/drivers/net/wireless/wavelan.c
index 8326793..5439e39 100644
--- a/drivers/net/wireless/wavelan.c
+++ b/drivers/net/wireless/wavelan.c
@@ -4281,8 +4281,7 @@ int __init init_module(void)
 
 
 	/* Loop on all possible base addresses. */
-	i = -1;
-	while ((io[++i] != 0) && (i < ARRAY_SIZE(io))) {
+	for (i = 0; i < ARRAY_SIZE(io) && io[i] != 0; i++) {
 		struct net_device *dev = alloc_etherdev(sizeof(net_local));
 		if (!dev)
 			break;
