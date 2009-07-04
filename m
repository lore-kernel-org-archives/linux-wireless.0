Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:52393 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZGDQYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 12:24:06 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: fix beacon template dtim IE corruption
Date: Sat, 4 Jul 2009 18:24:07 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200907041824.07655.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a regression that sneaked in with 
"[PATCH] p54: re-enable power save feature".
When p54_beacon_format_ie_tim was divided up
and rewritten to use skb_* macros.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 42abf34..c9a0545 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -111,10 +111,6 @@ static int p54_beacon_format_ie_tim(struct sk_buff *skb)
 		return -EINVAL;
 
 	memmove(tim, next, skb_tail_pointer(skb) - next);
-
-	if (dtim_len > 3)
-		skb_trim(skb, skb->len - (dtim_len - 3));
-
 	tim = skb_tail_pointer(skb) - (dtim_len + 2);
 
 	/* add the dummy at the end */
@@ -123,6 +119,10 @@ static int p54_beacon_format_ie_tim(struct sk_buff *skb)
 	tim[2] = 0;
 	tim[3] = dtim_period;
 	tim[4] = 0;
+
+	if (dtim_len > 3)
+		skb_trim(skb, skb->len - (dtim_len - 3));
+
 	return 0;
 }
 
