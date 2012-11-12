Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49658 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab2KLV6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:58:55 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so3644080eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:58:55 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 04/17] Fixed bugs in interrupt handler
Date: Mon, 12 Nov 2012 23:58:18 +0200
Message-Id: <1352757511-26957-5-git-send-email-maxtram95@gmail.com> (sfid-20121112_225859_787685_77FD8999)
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 r8180_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/r8180_core.c b/r8180_core.c
index 53a645b..d903786 100644
--- a/r8180_core.c
+++ b/r8180_core.c
@@ -3787,7 +3787,7 @@ irqreturn_t rtl8180_interrupt(int irq, void *netdev, struct pt_regs *regs)
 		priv->stats.txbkperr++;
 		priv->ieee80211->stats.tx_errors++;
 		rtl8180_tx_isr(dev, BK_PRIORITY, 1);
-		rtl8180_try_wake_queue(dev, BE_PRIORITY);
+		rtl8180_try_wake_queue(dev, BK_PRIORITY);
 	}
 
 	if (inta & ISR_TBEDER) { /* corresponding to BE_PRIORITY */
@@ -3841,6 +3841,7 @@ irqreturn_t rtl8180_interrupt(int irq, void *netdev, struct pt_regs *regs)
 		priv->link_detect.NumTxOkInPeriod++; /* YJ,add,080828 */
 		priv->stats.txnpokint++;
 		rtl8180_tx_isr(dev, NORM_PRIORITY, 0);
+		rtl8180_try_wake_queue(dev, NORM_PRIORITY);
 	}
 
 	if (inta & ISR_TLPDOK) { /* Low priority tx ok */
-- 
1.7.10.4

