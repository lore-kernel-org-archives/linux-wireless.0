Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50787 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZKSR6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 12:58:07 -0500
Date: Thu, 19 Nov 2009 11:58:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Improve error response for bug in openfwwf
Message-ID: <4b058734.0H90xGUti/95cLxC%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With open firmware being distributed by some distros, the problem
of a duplicate skb returned to b43_dma_handle_txstatus() is being
reported. (See Bug #538579 at bugzilla@redhat.com.)

When this problem occurs, A BUG_ON() is encountered - the kernel
panic yields little information. This patch turns that panic into
a KERN_ERR message. The interface will not continue; however, reporting
of the condition is better.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.org>
---

John,

This change should be sent to 2.6.32. I have used a variation of it in
private testing for the openfwwf project, and would have sent it up earlier
if I had known that the open firmware was being distributed.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c
+++ wireless-testing/drivers/net/wireless/b43/dma.c
@@ -1522,7 +1522,13 @@ void b43_dma_handle_txstatus(struct b43_
 		if (meta->is_last_fragment) {
 			struct ieee80211_tx_info *info;
 
-			BUG_ON(!meta->skb);
+			if (meta->skb == (void *)0x0606060606060606) {
+				printk(KERN_ERR "b43: Duplicate free of skb\n");
+				return;
+			} else if (!meta->skb) {
+				printk(KERN_ERR "b43: skb is NULL\n");
+				return;
+			}
 
 			info = IEEE80211_SKB_CB(meta->skb);
 
@@ -1540,8 +1546,8 @@ void b43_dma_handle_txstatus(struct b43_
 #endif /* DEBUG */
 			ieee80211_tx_status(dev->wl->hw, meta->skb);
 
-			/* skb is freed by ieee80211_tx_status() */
-			meta->skb = NULL;
+			/* skb was freed by ieee80211_tx_status() - poison it */
+			meta->skb = (void *)0x0606060606060606;
 		} else {
 			/* No need to call free_descriptor_buffer here, as
 			 * this is only the txhdr, which is not allocated.
