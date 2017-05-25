Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35148 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164690AbdEYALg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 20:11:36 -0400
Received: by mail-pf0-f173.google.com with SMTP id n23so150180144pfb.2
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 17:11:35 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 01/14] mwifiex: pcie: properly synchronize, disable interrupts in driver callbacks
Date: Wed, 24 May 2017 17:11:06 -0700
Message-Id: <20170525001119.64791-1-briannorris@chromium.org> (sfid-20170525_021528_466661_A3160C1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that the implicit assumption of the mwifiex
{enable,disable}_int() callbacks is that after ->disable_int(), all
interrupt handling should be complete (synchronized) and not fire again
until after ->enable_int(). Also, interrupts should not be serviced
until after the first ->enable_int().

However, the PCIe driver does none of this. First, the existing
interrupt mask programming appears to only have an effect for legacy
interrupts. It doesn't actually prevent MSI/MSI-X interrupts. Second,
even when it might mask interrupts, we're doing nothing to ensure that
pending IRQs have finished processing; they could be already in-flight
when a CPU masks them.

Another quirk of this driver's design is the use of a racy
"surprise_removed" check in mwifiex_pcie_interrupt(). This appears to
act like a racy poor-man's version of masking our interrupts -- it
allows us to short-circuit the ISR if it fires when we're not prepared
to handle more work.

We can resolve this all by:
(a) disabling our IRQs after requesting them
(b) call {enable,disable}_irq() in the {enable,disable}_int() callbacks
(c) remove the racy '->surprise_removed' hack from
    mwifiex_pcie_interrupt()
(d) document the effect (or lack thereof) of PCIE_HOST_INT_MASK, to
    clarify and possibly prevent future misuse

Along the way, I decided to use underscores to prefix the driver-private
forms of "disabling interrupts" (instead of the awkward "_noerr" suffix
used already), partly to discourage their use.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 70 ++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 394224d6c219..ea75315bf19d 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -505,12 +505,10 @@ static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function disables the host interrupt.
- *
- * The host interrupt mask is read, the disable bit is reset and
- * written back to the card host interrupt mask register.
+ * This function masks the host interrupt. Effective only for legacy PCI
+ * interrupts.
  */
-static int mwifiex_pcie_disable_host_int(struct mwifiex_adapter *adapter)
+static int __mwifiex_pcie_disable_host_int(struct mwifiex_adapter *adapter)
 {
 	if (mwifiex_pcie_ok_to_access_hw(adapter)) {
 		if (mwifiex_write_reg(adapter, PCIE_HOST_INT_MASK,
@@ -525,18 +523,30 @@ static int mwifiex_pcie_disable_host_int(struct mwifiex_adapter *adapter)
 	return 0;
 }
 
-static void mwifiex_pcie_disable_host_int_noerr(struct mwifiex_adapter *adapter)
+/*
+ * Disable interrupts, synchronizing with any outstanding interrupts.
+ */
+static void mwifiex_pcie_disable_host_int(struct mwifiex_adapter *adapter)
 {
-	WARN_ON(mwifiex_pcie_disable_host_int(adapter));
+	struct pcie_service_card *card = adapter->card;
+	int i;
+
+	WARN_ON(__mwifiex_pcie_disable_host_int(adapter));
+
+	if (card->msix_enable) {
+		for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++) {
+			disable_irq(card->msix_entries[i].vector);
+		}
+	} else {
+		disable_irq(card->dev->irq);
+	}
 }
 
 /*
- * This function enables the host interrupt.
- *
- * The host interrupt enable mask is written to the card
- * host interrupt mask register.
+ * This function unmasks the host interrupt. Effective only for legacy PCI
+ * interrupts.
  */
-static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter)
+static int __mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter)
 {
 	if (mwifiex_pcie_ok_to_access_hw(adapter)) {
 		/* Simply write the mask to the register */
@@ -551,6 +561,26 @@ static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter)
 	return 0;
 }
 
+static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	int i, ret;
+
+	ret = __mwifiex_pcie_enable_host_int(adapter);
+	if (ret)
+		return ret;
+
+	if (card->msix_enable) {
+		for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++) {
+			enable_irq(card->msix_entries[i].vector);
+		}
+	} else {
+		enable_irq(card->dev->irq);
+	}
+
+	return 0;
+}
+
 /*
  * This function initializes TX buffer ring descriptors
  */
@@ -1738,7 +1768,7 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 			while (reg->sleep_cookie && (count++ < 10) &&
 			       mwifiex_pcie_ok_to_access_hw(adapter))
 				usleep_range(50, 60);
-			mwifiex_pcie_enable_host_int(adapter);
+			__mwifiex_pcie_enable_host_int(adapter);
 			mwifiex_process_sleep_confirm_resp(adapter, skb->data,
 							   skb->len);
 		} else {
@@ -2081,7 +2111,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		    "info: Downloading FW image (%d bytes)\n",
 		    firmware_len);
 
-	if (mwifiex_pcie_disable_host_int(adapter)) {
+	if (__mwifiex_pcie_disable_host_int(adapter)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: Disabling interrupts failed.\n", __func__);
 		return -1;
@@ -2335,8 +2365,7 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter,
 		if ((pcie_ireg == 0xFFFFFFFF) || !pcie_ireg)
 			return;
 
-
-		mwifiex_pcie_disable_host_int(adapter);
+		__mwifiex_pcie_disable_host_int(adapter);
 
 		/* Clear the pending interrupts */
 		if (mwifiex_write_reg(adapter, PCIE_HOST_INT_STATUS,
@@ -2387,9 +2416,6 @@ static irqreturn_t mwifiex_pcie_interrupt(int irq, void *context)
 	}
 	adapter = card->adapter;
 
-	if (adapter->surprise_removed)
-		goto exit;
-
 	if (card->msix_enable)
 		mwifiex_interrupt_status(adapter, ctx->msg_id);
 	else
@@ -2494,7 +2520,7 @@ static int mwifiex_process_pcie_int(struct mwifiex_adapter *adapter)
 		    "info: cmd_sent=%d data_sent=%d\n",
 		    adapter->cmd_sent, adapter->data_sent);
 	if (!card->msi_enable && adapter->ps_state != PS_STATE_SLEEP)
-		mwifiex_pcie_enable_host_int(adapter);
+		__mwifiex_pcie_enable_host_int(adapter);
 
 	return 0;
 }
@@ -3055,6 +3081,7 @@ static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
 						  &card->msix_ctx[i]);
 				if (ret)
 					break;
+				disable_irq(card->msix_entries[i].vector);
 			}
 
 			if (ret) {
@@ -3087,6 +3114,7 @@ static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
 		pr_err("request_irq failed: ret=%d\n", ret);
 		return -1;
 	}
+	disable_irq(pdev->irq);
 
 	return 0;
 }
@@ -3244,7 +3272,7 @@ static struct mwifiex_if_ops pcie_ops = {
 	.register_dev =			mwifiex_register_dev,
 	.unregister_dev =		mwifiex_unregister_dev,
 	.enable_int =			mwifiex_pcie_enable_host_int,
-	.disable_int =			mwifiex_pcie_disable_host_int_noerr,
+	.disable_int =			mwifiex_pcie_disable_host_int,
 	.process_int_status =		mwifiex_process_int_status,
 	.host_to_card =			mwifiex_pcie_host_to_card,
 	.wakeup =			mwifiex_pm_wakeup_card,
-- 
2.13.0.219.gdb65acc882-goog
