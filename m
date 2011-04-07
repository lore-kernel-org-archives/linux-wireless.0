Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47134 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab1DGU16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 16:27:58 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so1931585fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 13:27:57 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	anarsoul@gmail.com
Subject: [PATCH RFC 1/3] libertas_spi: cancel packet work on module removal
Date: Thu,  7 Apr 2011 23:25:58 +0300
Message-Id: <1302207960-28536-2-git-send-email-anarsoul@gmail.com>
In-Reply-To: <1302207960-28536-1-git-send-email-anarsoul@gmail.com>
References: <1302207960-28536-1-git-send-email-anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/net/wireless/libertas/if_spi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 078ef43..d893560 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -1195,6 +1195,7 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
 	lbs_remove_card(priv); /* will call free_netdev */
 
 	free_irq(spi->irq, card);
+	cancel_work_sync(&card->packet_work);
 	flush_workqueue(card->workqueue);
 	destroy_workqueue(card->workqueue);
 	if (card->pdata->teardown)
-- 
1.7.4.1

