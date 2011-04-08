Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:46702 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757Ab1DHJJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 05:09:11 -0400
Subject: [PATCH] mwl8k: interrupt handling changes
From: Nishant Sarmukadam <nishants@marvell.com>
Reply-To: nishants@marvell.com
To: <linux-wireless@vger.kernel.org>
CC: <buytenh@wantstofly.org>
Content-Type: text/plain
Date: Fri, 8 Apr 2011 14:38:27 +0530
Message-ID: <1302253707.3447.86.camel@localhost.localdomain>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not need to enable all the interrupts in mwl8k_probe_hw.
We need to enable only MWL8K_A2H_INT_OPC_DONE interrupt for sending
commands to the firmware. Keep the other interrupts masked in
mwl8k_probe_hw. Also, in mwl8k_start, where we expect other interrupts,
enable only those interrupts we are interested in.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 8913180..07e8134 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4285,6 +4285,8 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 
 	/* Enable interrupts */
 	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
+	iowrite32(MWL8K_A2H_EVENTS,
+		  priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
 
 	rc = mwl8k_fw_lock(hw);
 	if (!rc) {
@@ -5283,7 +5285,8 @@ static int mwl8k_probe_hw(struct ieee80211_hw *hw)
 	iowrite32(MWL8K_A2H_INT_TX_DONE|MWL8K_A2H_INT_RX_READY|
 		  MWL8K_A2H_INT_BA_WATCHDOG,
 		  priv->regs + MWL8K_HIU_A2H_INTERRUPT_CLEAR_SEL);
-	iowrite32(0xffffffff, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
+	iowrite32(MWL8K_A2H_INT_OPC_DONE,
+		  priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
 
 	rc = request_irq(priv->pdev->irq, mwl8k_interrupt,
 			 IRQF_SHARED, MWL8K_NAME, hw);
-- 
1.6.0.3



