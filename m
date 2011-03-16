Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39821 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab1CPOpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 10:45:23 -0400
Received: by fxm17 with SMTP id 17so1725745fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 07:45:22 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Marek Vasut <marek.vasut@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Colin McCabe <colin@cozybit.com>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH RESEND] libertas_spi: Add support for suspend/resume
Date: Wed, 16 Mar 2011 16:41:46 +0200
Message-Id: <1300286506-13318-1-git-send-email-anarsoul@gmail.com>
In-Reply-To: <20110315204155.GE2542@tuxdriver.com>
References: <20110315204155.GE2542@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for suspend/resume in if_spi.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/net/wireless/libertas/if_spi.c |   65 ++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index f6c2cd6..078ef43 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -57,6 +57,7 @@ struct if_spi_card {
 	/* Handles all SPI communication (except for FW load) */
 	struct workqueue_struct		*workqueue;
 	struct work_struct		packet_work;
+	struct work_struct		resume_work;
 
 	u8				cmd_buffer[IF_SPI_CMD_BUF_SIZE];
 
@@ -68,6 +69,9 @@ struct if_spi_card {
 
 	/* Protects cmd_packet_list and data_packet_list */
 	spinlock_t			buffer_lock;
+
+	/* True is card suspended */
+	u8				suspended;
 };
 
 static void free_if_spi_card(struct if_spi_card *card)
@@ -1057,6 +1061,28 @@ out:
 	return err;
 }
 
+static void if_spi_resume_worker(struct work_struct *work)
+{
+	struct if_spi_card *card;
+
+	card = container_of(work, struct if_spi_card, resume_work);
+
+	if (card->suspended) {
+		if (card->pdata->setup)
+			card->pdata->setup(card->spi);
+
+		/* Init card ... */
+		if_spi_init_card(card);
+
+		enable_irq(card->spi->irq);
+
+		/* And resume it ... */
+		lbs_resume(card->priv);
+
+		card->suspended = 0;
+	}
+}
+
 static int __devinit if_spi_probe(struct spi_device *spi)
 {
 	struct if_spi_card *card;
@@ -1107,6 +1133,7 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 		goto free_card;
 	}
 	card->priv = priv;
+	priv->setup_fw_on_resume = 1;
 	priv->card = card;
 	priv->hw_host_to_card = if_spi_host_to_card;
 	priv->enter_deep_sleep = NULL;
@@ -1117,6 +1144,7 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 	/* Initialize interrupt handling stuff. */
 	card->workqueue = create_workqueue("libertas_spi");
 	INIT_WORK(&card->packet_work, if_spi_host_to_card_worker);
+	INIT_WORK(&card->resume_work, if_spi_resume_worker);
 
 	err = request_irq(spi->irq, if_spi_host_interrupt,
 			IRQF_TRIGGER_FALLING, "libertas_spi", card);
@@ -1161,6 +1189,8 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
 	lbs_deb_spi("libertas_spi_remove\n");
 	lbs_deb_enter(LBS_DEB_SPI);
 
+	cancel_work_sync(&card->resume_work);
+
 	lbs_stop_card(priv);
 	lbs_remove_card(priv); /* will call free_netdev */
 
@@ -1174,6 +1204,40 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
 	return 0;
 }
 
+static int if_spi_suspend(struct device *dev)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct if_spi_card *card = spi_get_drvdata(spi);
+
+	if (!card->suspended) {
+		lbs_suspend(card->priv);
+		flush_workqueue(card->workqueue);
+		disable_irq(spi->irq);
+
+		if (card->pdata->teardown)
+			card->pdata->teardown(spi);
+		card->suspended = 1;
+	}
+
+	return 0;
+}
+
+static int if_spi_resume(struct device *dev)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct if_spi_card *card = spi_get_drvdata(spi);
+
+	/* Schedule delayed work */
+	schedule_work(&card->resume_work);
+
+	return 0;
+}
+
+static const struct dev_pm_ops if_spi_pm_ops = {
+	.suspend	= if_spi_suspend,
+	.resume		= if_spi_resume,
+};
+
 static struct spi_driver libertas_spi_driver = {
 	.probe	= if_spi_probe,
 	.remove = __devexit_p(libertas_spi_remove),
@@ -1181,6 +1245,7 @@ static struct spi_driver libertas_spi_driver = {
 		.name	= "libertas_spi",
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
+		.pm	= &if_spi_pm_ops,
 	},
 };
 
-- 
1.7.4.1

