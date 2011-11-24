Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40906 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1KXDac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 22:30:32 -0500
Received: by ggnr5 with SMTP id r5so2131388ggn.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 19:30:31 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix incorrect return of IRQ_HANDLED
Date: Wed, 23 Nov 2011 21:30:19 -0600
Message-Id: <1322105419-5207-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111124_043042_005858_0BC87051)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recent discussion regarding an incorrect return of IRQ_HANDLED
from rt2800pci caused me to look at this PCI interrupt routine. I
discovered that changes were needed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 3.3 material.

Larry
---
 drivers/net/wireless/rtlwifi/pci.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index b6683a2..91f0525 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -780,6 +780,7 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	unsigned long flags;
 	u32 inta = 0;
 	u32 intb = 0;
+	irqreturn_t ret = IRQ_HANDLED;
 
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 
@@ -787,8 +788,10 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	rtlpriv->cfg->ops->interrupt_recognized(hw, &inta, &intb);
 
 	/*Shared IRQ or HW disappared */
-	if (!inta || inta == 0xffff)
+	if (!inta || inta == 0xffff) {
+		ret = IRQ_NONE;
 		goto done;
+	}
 
 	/*<1> beacon related */
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_TBDOK]) {
@@ -892,7 +895,7 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 
 done:
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
-	return IRQ_HANDLED;
+	return ret;
 }
 
 static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
-- 
1.7.7

