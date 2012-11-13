Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54986 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab2KMR24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:28:56 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so4133183eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:28:56 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 04/17] staging: rtl8187se: Fixed bugs in interrupt handler
Date: Tue, 13 Nov 2012 19:28:10 +0200
Message-Id: <1352827703-4659-5-git-send-email-maxtram95@gmail.com> (sfid-20121113_182903_701791_6DADB550)
In-Reply-To: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
References: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed typo in rtl8180_interrupt() and added missing line

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 1a76cc9..6ec3a93 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
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

