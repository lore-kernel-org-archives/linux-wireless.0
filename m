Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:36895 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756607AbdGYBOZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:25 -0400
Received: by mail-pg0-f48.google.com with SMTP id y129so63969552pgy.4
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:24 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 15/20] mwifiex: pcie: unify MSI-X / non-MSI-X interrupt process
Date: Mon, 24 Jul 2017 18:13:31 -0700
Message-Id: <20170725011336.99993-16-briannorris@chromium.org> (sfid-20170725_031749_451713_2A99B7E8)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After removing the interrupt loop in commit 5d5ddb5e0d9b ("mwifiex:
pcie: don't loop/retry interrupt status checks"), there is practically
zero difference between mwifiex_process_pcie_int() (which handled legacy
PCI interrupts and MSI interrupts) and mwifiex_process_msix_int() (which
handled MSI-X interrupts). Let's add the one relevant line to
mwifiex_process_pcie_int() and kill the copy-and-paste.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
new in v2
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 68 ++---------------------------
 1 file changed, 3 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 2f4da08f127c..c08ebb55a7e8 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2417,7 +2417,7 @@ static irqreturn_t mwifiex_pcie_interrupt(int irq, void *context)
  * In case of Rx packets received, the packets are uploaded from card to
  * host and processed accordingly.
  */
-static int mwifiex_process_pcie_int(struct mwifiex_adapter *adapter)
+static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 {
 	int ret;
 	u32 pcie_ireg = 0;
@@ -2492,75 +2492,13 @@ static int mwifiex_process_pcie_int(struct mwifiex_adapter *adapter)
 	mwifiex_dbg(adapter, INTR,
 		    "info: cmd_sent=%d data_sent=%d\n",
 		    adapter->cmd_sent, adapter->data_sent);
-	if (!card->msi_enable && adapter->ps_state != PS_STATE_SLEEP)
+	if (!card->msi_enable && !card->msix_enable &&
+				 adapter->ps_state != PS_STATE_SLEEP)
 		mwifiex_pcie_enable_host_int(adapter);
 
 	return 0;
 }
 
-static int mwifiex_process_msix_int(struct mwifiex_adapter *adapter)
-{
-	int ret;
-	u32 pcie_ireg;
-	unsigned long flags;
-
-	spin_lock_irqsave(&adapter->int_lock, flags);
-	/* Clear out unused interrupts */
-	pcie_ireg = adapter->int_status;
-	adapter->int_status = 0;
-	spin_unlock_irqrestore(&adapter->int_lock, flags);
-
-	if (pcie_ireg & HOST_INTR_DNLD_DONE) {
-		mwifiex_dbg(adapter, INTR,
-			    "info: TX DNLD Done\n");
-		ret = mwifiex_pcie_send_data_complete(adapter);
-		if (ret)
-			return ret;
-	}
-	if (pcie_ireg & HOST_INTR_UPLD_RDY) {
-		mwifiex_dbg(adapter, INTR,
-			    "info: Rx DATA\n");
-		ret = mwifiex_pcie_process_recv_data(adapter);
-		if (ret)
-			return ret;
-	}
-	if (pcie_ireg & HOST_INTR_EVENT_RDY) {
-		mwifiex_dbg(adapter, INTR,
-			    "info: Rx EVENT\n");
-		ret = mwifiex_pcie_process_event_ready(adapter);
-		if (ret)
-			return ret;
-	}
-
-	if (pcie_ireg & HOST_INTR_CMD_DONE) {
-		if (adapter->cmd_sent) {
-			mwifiex_dbg(adapter, INTR,
-				    "info: CMD sent Interrupt\n");
-			adapter->cmd_sent = false;
-		}
-		/* Handle command response */
-		ret = mwifiex_pcie_process_cmd_complete(adapter);
-		if (ret)
-			return ret;
-	}
-
-	mwifiex_dbg(adapter, INTR,
-		    "info: cmd_sent=%d data_sent=%d\n",
-		    adapter->cmd_sent, adapter->data_sent);
-
-	return 0;
-}
-
-static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
-{
-	struct pcie_service_card *card = adapter->card;
-
-	if (card->msix_enable)
-		return mwifiex_process_msix_int(adapter);
-	else
-		return mwifiex_process_pcie_int(adapter);
-}
-
 /*
  * This function downloads data from driver to card.
  *
-- 
2.14.0.rc0.284.gd933b75aa4-goog
