Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:47444 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbZAIUGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 15:06:32 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] p54: fix oops caused by bad eeproms
Date: Fri, 9 Jan 2009 21:06:30 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901092106.30274.chunkeey@web.de> (sfid-20090109_210635_373533_C2F9EE27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug that could occur, if it the eeprom is incomplete or partly corrupted.

BUG: unable to handle kernel NULL pointer dereference at 00000008
IP: p54_assign_address+0x108/0x15d [p54common]
Oops: 0002 [#1] SMP
Pid: 12988, comm: phy1 Tainted: P        W  2.6.28-rc6-wl #3
RIP: 0010: p54_assign_address+0x108/0x15d [p54common]
 [...]
Call Trace:
 p54_alloc_skb+0xa3/0xc0 [p54common]
 p54_scan+0x37/0x204 [p54common]
 [...]

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
This is just a updated version of the old one:
http://www.spinics.net/lists/linux-wireless/msg24853.html
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-01-09 19:14:11.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-01-09 19:13:18.000000000 +0100
@@ -1674,7 +1674,7 @@ static int p54_scan(struct ieee80211_hw 
 
  err:
 	printk(KERN_ERR "%s: frequency change failed\n", wiphy_name(dev->wiphy));
-	kfree_skb(skb);
+	p54_free_skb(dev, skb);
 	return -EINVAL;
 }
 
