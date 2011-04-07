Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47134 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab1DGU2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 16:28:02 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so1931585fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 13:28:01 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	anarsoul@gmail.com
Subject: [PATCH RFC 3/3] libertas_spi: introduce set_power callback
Date: Thu,  7 Apr 2011 23:26:00 +0300
Message-Id: <1302207960-28536-4-git-send-email-anarsoul@gmail.com>
In-Reply-To: <1302207960-28536-1-git-send-email-anarsoul@gmail.com>
References: <1302207960-28536-1-git-send-email-anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce set_power callback for spi cards, it makes driver a bit
powersave friendlier.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/net/wireless/libertas/if_spi.c |   54 ++++++++++++-------------------
 1 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index d893560..1e629b3 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -1068,18 +1068,25 @@ static void if_spi_resume_worker(struct work_struct *work)
 	card = container_of(work, struct if_spi_card, resume_work);
 
 	if (card->suspended) {
-		if (card->pdata->setup)
-			card->pdata->setup(card->spi);
+		lbs_resume(card->priv);
 
-		/* Init card ... */
-		if_spi_init_card(card);
+		card->suspended = 0;
+	}
+}
 
-		enable_irq(card->spi->irq);
+static void if_spi_set_power(struct lbs_private *priv, int enable)
+{
+	struct if_spi_card *card = priv->card;
 
-		/* And resume it ... */
-		lbs_resume(card->priv);
+	if (enable) {
+		card->pdata->setup(card->spi);
+		if_spi_init_card(card);
+		enable_irq(card->spi->irq);
 
-		card->suspended = 0;
+	} else {
+		flush_workqueue(card->workqueue);
+		disable_irq(card->spi->irq);
+		card->pdata->teardown(card->spi);
 	}
 }
 
@@ -1097,17 +1104,11 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 		goto out;
 	}
 
-	if (pdata->setup) {
-		err = pdata->setup(spi);
-		if (err)
-			goto out;
-	}
-
 	/* Allocate card structure to represent this specific device */
 	card = kzalloc(sizeof(struct if_spi_card), GFP_KERNEL);
 	if (!card) {
 		err = -ENOMEM;
-		goto teardown;
+		goto out;
 	}
 	spi_set_drvdata(spi, card);
 	card->pdata = pdata;
@@ -1118,13 +1119,6 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 	INIT_LIST_HEAD(&card->data_packet_list);
 	spin_lock_init(&card->buffer_lock);
 
-	/* Initialize the SPI Interface Unit */
-
-	/* Firmware load */
-	err = if_spi_init_card(card);
-	if (err)
-		goto free_card;
-
 	/* Register our card with libertas.
 	 * This will call alloc_etherdev */
 	priv = lbs_add_card(card, &spi->dev);
@@ -1133,9 +1127,10 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 		goto free_card;
 	}
 	card->priv = priv;
-	priv->setup_fw_on_resume = 1;
 	priv->card = card;
 	priv->hw_host_to_card = if_spi_host_to_card;
+	if (pdata->setup && pdata->teardown)
+		priv->set_power = if_spi_set_power;
 	priv->enter_deep_sleep = NULL;
 	priv->exit_deep_sleep = NULL;
 	priv->reset_deep_sleep_wakeup = NULL;
@@ -1153,6 +1148,9 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 		goto terminate_workqueue;
 	}
 
+	/* Disable IRQ, hw is not ready yet */
+	disable_irq(spi->irq);
+
 	/* Start the card.
 	 * This will call register_netdev, and we'll start
 	 * getting interrupts... */
@@ -1173,9 +1171,6 @@ terminate_workqueue:
 	lbs_remove_card(priv); /* will call free_netdev */
 free_card:
 	free_if_spi_card(card);
-teardown:
-	if (pdata->teardown)
-		pdata->teardown(spi);
 out:
 	lbs_deb_leave_args(LBS_DEB_SPI, "err %d\n", err);
 	return err;
@@ -1198,8 +1193,6 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
 	cancel_work_sync(&card->packet_work);
 	flush_workqueue(card->workqueue);
 	destroy_workqueue(card->workqueue);
-	if (card->pdata->teardown)
-		card->pdata->teardown(spi);
 	free_if_spi_card(card);
 	lbs_deb_leave(LBS_DEB_SPI);
 	return 0;
@@ -1212,11 +1205,6 @@ static int if_spi_suspend(struct device *dev)
 
 	if (!card->suspended) {
 		lbs_suspend(card->priv);
-		flush_workqueue(card->workqueue);
-		disable_irq(spi->irq);
-
-		if (card->pdata->teardown)
-			card->pdata->teardown(spi);
 		card->suspended = 1;
 	}
 
-- 
1.7.4.1

