Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41545 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbZBTR3V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 12:29:21 -0500
Subject: [PATCH] libertas: use private SDIO workqueue to avoid scheduling
	latency
From: Dan Williams <dcbw@redhat.com>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	David Anders <dave123_aml@yahoo.com>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 12:27:38 -0500
Message-Id: <1235150858.2859.4.camel@localhost> (sfid-20090220_182933_359418_FC34B07E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The libertas SDIO interface scheduled the packet worker, resulting in
unwanted latency for every data packet or command sent to the firmware.
Fix a bug on the SDIO probe error path too.

Signed-off-by: Dan Williams <dcbw@redhat.com>

---

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 9878368..76f4c65 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -95,6 +95,8 @@ struct if_sdio_card {
 
 	spinlock_t		lock;
 	struct if_sdio_packet	*packets;
+
+	struct workqueue_struct	*workqueue;
 	struct work_struct	packet_worker;
 };
 
@@ -746,7 +748,7 @@ static int if_sdio_host_to_card(struct lbs_private *priv,
 
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	schedule_work(&card->packet_worker);
+	queue_work(card->workqueue, &card->packet_worker);
 
 	ret = 0;
 
@@ -836,6 +838,7 @@ static int if_sdio_probe(struct sdio_func *func,
 	card->func = func;
 	card->model = model;
 	spin_lock_init(&card->lock);
+	card->workqueue = create_workqueue("libertas_sdio");
 	INIT_WORK(&card->packet_worker, if_sdio_host_to_card_worker);
 
 	for (i = 0;i < ARRAY_SIZE(if_sdio_models);i++) {
@@ -933,9 +936,8 @@ out:
 	return ret;
 
 err_activate_card:
-	flush_scheduled_work();
-	free_netdev(priv->dev);
-	kfree(priv);
+	flush_workqueue(card->workqueue);
+	lbs_remove_card(priv);
 reclaim:
 	sdio_claim_host(func);
 release_int:
@@ -945,6 +947,7 @@ disable:
 release:
 	sdio_release_host(func);
 free:
+	destroy_workqueue(card->workqueue);
 	while (card->packets) {
 		packet = card->packets;
 		card->packets = card->packets->next;
@@ -971,7 +974,8 @@ static void if_sdio_remove(struct sdio_func *func)
 	lbs_stop_card(card->priv);
 	lbs_remove_card(card->priv);
 
-	flush_scheduled_work();
+	flush_workqueue(card->workqueue);
+	destroy_workqueue(card->workqueue);
 
 	sdio_claim_host(func);
 	sdio_release_irq(func);


