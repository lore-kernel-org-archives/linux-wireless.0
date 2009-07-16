Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360AbZGPDtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 23:49:07 -0400
Date: Wed, 15 Jul 2009 22:49:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, j@w1.fi
Cc: puck@dp-indexing.com, linux-wireless@vger.kernel.org
Subject: [PATCH] hostap_cs: Enable shared interrupts
Message-ID: <4a5ea347.5tHxSLRR7DKOcW+q%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hostap_cs driver is programmed for exclusive rather that shared
interrupts.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-Tested-by: Jack Schneider <puck@dp-indexing.com>
---

John,

This is an original bug. It doesn't make much difference which
kernel first gets the fix.

Larry
---

Index: wireless-testing/drivers/net/wireless/hostap/hostap_cs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/hostap/hostap_cs.c
+++ wireless-testing/drivers/net/wireless/hostap/hostap_cs.c
@@ -666,7 +666,8 @@ static int prism2_config(struct pcmcia_d
 	 * irq structure is initialized.
 	 */
 	if (link->conf.Attributes & CONF_ENABLE_IRQ) {
-		link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+		link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING |
+				       IRQ_HANDLE_PRESENT;
 		link->irq.IRQInfo1 = IRQ_LEVEL_ID;
 		link->irq.Handler = prism2_interrupt;
 		link->irq.Instance = dev;
