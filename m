Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:48132 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535AbYHaUMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2008 16:12:34 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54pci: increase ring buffer index counter when skipping
Date: Sun, 31 Aug 2008 22:15:40 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808312215.40870.chunkeey@web.de> (sfid-20080831_221241_495652_1F2D6643)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm afraid, I forgot to add the following lines to 
7262d59366 ("p54pci: rx tasklet refactoring").

These changes are necessary to ensure loop termination.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

for wireless-next.
---
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-08-31 21:28:55.000000000 +0200
+++ b/drivers/net/wireless/p54/p54pci.c	2008-08-31 21:18:25.000000000 +0200
@@ -301,9 +301,11 @@ static void p54p_check_rx_ring(struct ie
 		len = le16_to_cpu(desc->len);
 		skb = rx_buf[i];
 
-		if (!skb)
+		if (!skb) {
+			i++;
+			i %= ring_limit;
 			continue;
-
+		}
 		skb_put(skb, len);
 
 		if (p54_rx(dev, skb)) {

