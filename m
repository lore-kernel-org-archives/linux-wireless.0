Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34591 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbbDMJSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 05:18:35 -0400
Received: by widjs5 with SMTP id js5so59666519wid.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 02:18:34 -0700 (PDT)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH 2/2] mwifiex: sdio: bug: dead-lock in card reset
Date: Mon, 13 Apr 2015 11:18:24 +0200
Message-Id: <1428916704-9635-2-git-send-email-afenkart@gmail.com> (sfid-20150413_111838_817357_248A3345)
In-Reply-To: <1428916704-9635-1-git-send-email-afenkart@gmail.com>
References: <1428916704-9635-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Card reset is implemented by removing/re-adding the adapter instance.
This is implemented by removing the mmc host, which will then trigger
a cascade of removal callbacks including mwifiex_sdio_remove.
The dead-lock results in the latter function, trying to cancel the work
item executing the mmc host removal. This patch adds a driver level,
not adapter level, work struct to break the dead-lock

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/mwifiex/main.h |  1 -
 drivers/net/wireless/mwifiex/sdio.c | 63 +++++++++++++++++++++++++++++--------
 2 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index f0a6af1..702f348 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -437,7 +437,6 @@ enum rdwr_status {
 
 enum mwifiex_iface_work_flags {
 	MWIFIEX_IFACE_WORK_FW_DUMP,
-	MWIFIEX_IFACE_WORK_CARD_RESET,
 };
 
 struct mwifiex_adapter;
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index a70e114..0996b0e 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -75,6 +75,19 @@ static LIST_HEAD(cards);
 static DEFINE_MUTEX(cards_mutex);
 
 /*
+ * Card removal will remove the interface then re-add it
+ * Hence the work_struct can't be part of the adapter
+ * otherwise there will be deadlock when we remove the
+ * adapter, and cancel the work struct executing the reset
+ */
+static struct
+{
+	struct work_struct work;
+	struct sdio_mmc_card *card;
+} s_card_reset;
+static DEFINE_SEMAPHORE(s_card_reset_sem);
+
+/*
  * SDIO probe.
  *
  * This function probes an mwifiex device and registers it. It allocates
@@ -1964,10 +1977,36 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 		port, card->mp_data_port_mask);
 }
 
-static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
+static void mwifiex_sdio_card_reset_work(struct work_struct *work)
 {
-	struct sdio_mmc_card *card = adapter->card;
-	struct mmc_host *target = card->func->card->host;
+	struct sdio_mmc_card *card = NULL;
+	struct mmc_host *target;
+	struct list_head *cur;
+
+	WARN_ON(work != &s_card_reset.work);
+
+	/* adapter pointer might have been invalidated
+	 * e.g. card removed from slot
+	 */
+	mutex_lock(&cards_mutex);
+	list_for_each_prev(cur, &cards) {
+		card = list_entry(cur, struct sdio_mmc_card, next);
+		if (card == s_card_reset.card)
+			break;
+	}
+	if (!card || card != s_card_reset.card) {
+		pr_err("card was removed, cancel card reset\n");
+		mutex_unlock(&cards_mutex);
+		return;
+	}
+
+	/* card pointer still valid inc ref in host, it's all we need */
+	target = card->func->card->host;
+	mmc_claim_host(target);
+	mutex_unlock(&cards_mutex);
+
+	/* release the work struct, we are done with it */
+	up(&s_card_reset_sem);
 
 	/* The actual reset operation must be run outside of driver thread.
 	 * This is because mmc_remove_host() will cause the device to be
@@ -1976,13 +2015,14 @@ static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 	 *
 	 * We run it in a totally independent workqueue.
 	 */
-
 	pr_err("Resetting card...\n");
 	mmc_remove_host(target);
 	/* 200ms delay is based on experiment with sdhci controller */
 	mdelay(200);
 	target->rescan_entered = 0; /* rescan non-removable cards */
 	mmc_add_host(target);
+
+	mmc_release_host(target);
 }
 
 /* This function read/write firmware */
@@ -2160,9 +2200,6 @@ static void mwifiex_sdio_work(struct work_struct *work)
 	struct mwifiex_adapter *adapter =
 			container_of(work, struct mwifiex_adapter, iface_work);
 
-	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET,
-			       &adapter->iface_work_flags))
-		mwifiex_sdio_card_reset_work(adapter);
 	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_FW_DUMP,
 			       &adapter->iface_work_flags))
 		mwifiex_sdio_fw_dump_work(work);
@@ -2171,12 +2208,9 @@ static void mwifiex_sdio_work(struct work_struct *work)
 /* This function resets the card */
 static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
 {
-	if (test_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &adapter->iface_work_flags))
-		return;
-
-	set_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &adapter->iface_work_flags);
-
-	schedule_work(&adapter->iface_work);
+	down(&s_card_reset_sem);
+	s_card_reset.card = adapter->card;
+	schedule_work(&s_card_reset.work);
 }
 
 /* This function dumps FW information */
@@ -2317,6 +2351,7 @@ static int
 mwifiex_sdio_init_module(void)
 {
 	sema_init(&add_remove_card_sem, 1);
+	INIT_WORK(&s_card_reset.work, mwifiex_sdio_card_reset_work);
 
 	/* Clear the flag in case user removes the card. */
 	user_rmmod = 0;
@@ -2339,6 +2374,8 @@ mwifiex_sdio_cleanup_module(void)
 	if (!down_interruptible(&add_remove_card_sem))
 		up(&add_remove_card_sem);
 
+	cancel_work_sync(&s_card_reset.work);
+
 	/* Set the flag as user is removing this module. */
 	user_rmmod = 1;
 
-- 
2.1.4

