Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:8865 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348Ab1FGRQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 13:16:03 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Cc: linux-mmc@vger.kernel.org
Subject: [PATCH] libertas: add sd8686 reset_card support
Message-Id: <20110607171557.7F65D9D401C@zog.reactivated.net> (sfid-20110607_191607_586415_4C7B2140)
Date: Tue,  7 Jun 2011 18:15:57 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At http://dev.laptop.org/ticket/10748 we are seeing a case of the
libertas firmware randomly stopping responding to commands after
resume. Careful monitoring of communications indicates a firmware or
hardware bug, which has been reported to Marvell.

Work around this issue by adding a reset_card method; this is
automatically called when command timeouts are detected and provides an
instant recovery to this situation.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/if_sdio.c |   34 +++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

linux-mmc: any comments on this? is there a better way to do it?
We do want a full card reset where everything is properly removed and
re-probed, so that userspace knows to reprogram wifi security keys,
re-establish connections, etc.

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index a7b5cb0..13c9dbe 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -892,6 +892,37 @@ static int if_sdio_reset_deep_sleep_wakeup(struct lbs_private *priv)
 
 }
 
+static struct mmc_host *reset_host;
+
+static void if_sdio_reset_card_worker(struct work_struct *work)
+{
+	/*
+	 * The actual reset operation must be run outside of lbs_thread. This
+	 * is because mmc_remove_host() will cause the device to be instantly
+	 * destroyed, and the libertas driver then needs to end lbs_thread,
+	 * leading to a deadlock.
+	 *
+	 * We run it in a workqueue totally independent from the if_sdio_card
+	 * instance for that reason.
+	 */
+
+	lbs_pr_info("Resetting card...");
+	mmc_remove_host(reset_host);
+	mmc_add_host(reset_host);
+}
+static DECLARE_WORK(card_reset_work, if_sdio_reset_card_worker);
+
+static void if_sdio_reset_card(struct lbs_private *priv)
+{
+	struct if_sdio_card *card = priv->card;
+
+	if (work_pending(&card_reset_work))
+		return;
+
+	reset_host = card->func->card->host;
+	schedule_work(&card_reset_work);
+}
+
 /*******************************************************************/
 /* SDIO callbacks                                                  */
 /*******************************************************************/
@@ -1069,6 +1100,7 @@ static int if_sdio_probe(struct sdio_func *func,
 	priv->enter_deep_sleep = if_sdio_enter_deep_sleep;
 	priv->exit_deep_sleep = if_sdio_exit_deep_sleep;
 	priv->reset_deep_sleep_wakeup = if_sdio_reset_deep_sleep_wakeup;
+	priv->reset_card = if_sdio_reset_card;
 
 	sdio_claim_host(func);
 
@@ -1290,6 +1322,8 @@ static void __exit if_sdio_exit_module(void)
 	/* Set the flag as user is removing this module. */
 	user_rmmod = 1;
 
+	cancel_work_sync(&card_reset_work);
+
 	sdio_unregister_driver(&if_sdio_driver);
 
 	lbs_deb_leave(LBS_DEB_SDIO);
-- 
1.7.5.2

