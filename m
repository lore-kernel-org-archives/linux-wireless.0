Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:39096 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYLDN3P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 08:29:15 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: fix oops caused by bad eeproms
Date: Thu, 4 Dec 2008 14:29:16 +0100
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812041429.16869.chunkeey@web.de> (sfid-20081204_142919_768615_5407673F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug that could occur, if it the eeprom is incomplete or partly corrupted.

e.g:
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
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 719bdab..234fee3 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1490,7 +1490,7 @@ static int p54_scan(struct ieee80211_hw *dev, u16 mode, u16 dwell,
 
  err:
 	printk(KERN_ERR "%s: frequency change failed\n", wiphy_name(dev->wiphy));
-	kfree_skb(skb);
+	p54_free_skb(dev, skb);
 	return -EINVAL;
 }
 
