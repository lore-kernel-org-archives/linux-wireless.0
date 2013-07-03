Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.laptop.org ([18.85.2.166]:56186 "EHLO swan.laptop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab3GCBzd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 21:55:33 -0400
From: Daniel Drake <dsd@laptop.org>
To: bzhao@marvell.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
Message-Id: <20130703015653.82651FAAD5@dev.laptop.org> (sfid-20130703_035536_640948_248465C3)
Date: Tue,  2 Jul 2013 21:56:52 -0400 (EDT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the card is being removed, mwifiex_remove_card() immediately sets
surprise_removed to 1. This flag then causes the SDIO interrupt handler
to ignore all interrupts without even acking them.

If there are any async commands ongoing, it is very likely that interrupts
will be received during this time. Since they are not acked (via the MP reg
read in mwifiex_interrupt_status), it becomes an interrupt storm.

This interrupt storm is undesirable and can cause problems for the
bluetooth driver which also operates the 8787 SDIO card.

Make the driver continue to ack interrupts during shutdown to avoid
this. This is harder than it might sound.

We must be careful not to act upon the interrupt, only ack it.
Otherwise, we end up setting int_status to something. And hw_status is
set to MWIFIEX_HW_STATUS_CLOSING for obvious reasons. We would hit the
following infinite loop in mwifiex_main_process:

	process_start:
	do {
		if ((adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING) ||
		    (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY))
			break;
		[...]
	} while (true);
	if ((adapter->int_status) || IS_CARD_RX_RCVD(adapter))
		goto process_start;

We must also observe that ACKing interrupts involves reading a load
of data into the mp_regs buffer. The driver doesn't do much in the
way of ensuring that interrupts are disabled before freeing buffers
such as mp_regs, but we do need something here to make sure that we
don't get any interrupts after mp_regs is freed.

This whole thing feels rather fragile, but I couldn't see a clean
way to do it, the driver seems a bit disorganised here. I would
welcome a review from the designers.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/mwifiex/init.c |  5 +++++
 drivers/net/wireless/mwifiex/main.h |  1 +
 drivers/net/wireless/mwifiex/sdio.c | 14 ++++++++------
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index caaf4bd..0e656db 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -643,6 +643,11 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 		}
 	}
 
+	/* Must be done before cleanup_if (in mwifiex_free_adapter) and can't
+	 * be done in atomic context. */
+	if (adapter->if_ops.disable_int)
+		adapter->if_ops.disable_int(adapter);
+
 	spin_lock(&adapter->mwifiex_lock);
 
 	if (adapter->if_ops.data_complete) {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 3da73d3..5162e8c 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -601,6 +601,7 @@ struct mwifiex_if_ops {
 	int (*register_dev) (struct mwifiex_adapter *);
 	void (*unregister_dev) (struct mwifiex_adapter *);
 	int (*enable_int) (struct mwifiex_adapter *);
+	int (*disable_int) (struct mwifiex_adapter *);
 	int (*process_int_status) (struct mwifiex_adapter *);
 	int (*host_to_card) (struct mwifiex_adapter *, u8, struct sk_buff *,
 			     struct mwifiex_tx_param *);
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 5ee5ed0..25cfc30 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -948,7 +948,7 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 /*
  * This function reads the interrupt status from card.
  */
-static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
+static void mwifiex_process_interrupt(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	u8 sdio_ireg;
@@ -961,6 +961,9 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 		return;
 	}
 
+	if (adapter->surprise_removed)
+		return;
+
 	sdio_ireg = card->mp_regs[HOST_INTSTATUS_REG];
 	if (sdio_ireg) {
 		/*
@@ -975,6 +978,8 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 		adapter->int_status |= sdio_ireg;
 		spin_unlock_irqrestore(&adapter->int_lock, flags);
 	}
+
+	mwifiex_main_process(adapter);
 }
 
 /*
@@ -997,14 +1002,10 @@ mwifiex_sdio_interrupt(struct sdio_func *func)
 	}
 	adapter = card->adapter;
 
-	if (adapter->surprise_removed)
-		return;
-
 	if (!adapter->pps_uapsd_mode && adapter->ps_state == PS_STATE_SLEEP)
 		adapter->ps_state = PS_STATE_AWAKE;
 
-	mwifiex_interrupt_status(adapter);
-	mwifiex_main_process(adapter);
+	mwifiex_process_interrupt(adapter);
 }
 
 /*
@@ -1957,6 +1958,7 @@ static struct mwifiex_if_ops sdio_ops = {
 	.register_dev = mwifiex_register_dev,
 	.unregister_dev = mwifiex_unregister_dev,
 	.enable_int = mwifiex_sdio_enable_host_int,
+	.disable_int = mwifiex_sdio_disable_host_int,
 	.process_int_status = mwifiex_process_int_status,
 	.host_to_card = mwifiex_sdio_host_to_card,
 	.wakeup = mwifiex_pm_wakeup_card,
-- 
1.8.1.4

