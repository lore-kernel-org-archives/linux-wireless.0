Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:46645 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbZDBXxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 19:53:02 -0400
Received: by wa-out-1112.google.com with SMTP id j5so606002wah.21
        for <linux-wireless@vger.kernel.org>; Thu, 02 Apr 2009 16:52:59 -0700 (PDT)
Message-ID: <49d54fd9.1aba720a.5b57.ffffe3f6@mx.google.com> (sfid-20090403_015310_279245_629A59BA)
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org, dcbw@redhat.com,
	javier@cozybit.com
From: Anna Neal <anna@cozybit.com>
Date: Thu, 2 Apr 2009 14:44:09 -0700
Subject: [PATCH] libertas: increase spi driver thread priority
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the libertas main thread contends with the spi driver thread
in the TX path.  To improve throughput, ensure that the driver thread
has higher scheduling priority than the libertas main thread.  Do this
by making the libertas spi driver thread a low priority real time
thread.

We measured an average throughput improvement of 13%.

Signed-off-by: Anna Neal <anna@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 drivers/net/wireless/libertas/if_spi.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 07311e7..97493e2 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -1020,6 +1020,7 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 	struct libertas_spi_platform_data *pdata = spi->dev.platform_data;
 	int err = 0;
 	u32 scratch;
+	struct sched_param param = { .sched_priority = 1 };
 
 	lbs_deb_enter(LBS_DEB_SPI);
 
@@ -1123,6 +1124,9 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 		lbs_pr_err("error creating SPI thread: err=%d\n", err);
 		goto remove_card;
 	}
+	if (sched_setscheduler(card->spi_thread, SCHED_FIFO, &param))
+		lbs_pr_err("Error setting scheduler, using default.\n");
+
 	err = request_irq(spi->irq, if_spi_host_interrupt,
 			IRQF_TRIGGER_FALLING, "libertas_spi", card);
 	if (err) {
-- 
1.5.6.3



