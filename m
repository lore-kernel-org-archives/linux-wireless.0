Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:3189 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867Ab0KXQCE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 11:02:04 -0500
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
Cc: s.neumann@raumfeld.com
Cc: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Cc: andrey@cozybit.com
Subject: [PATCH 2/2] libertas: fix invalid access
Message-Id: <20101124160200.294D79D401B@zog.reactivated.net>
Date: Wed, 24 Nov 2010 16:02:00 +0000 (GMT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sven Neumann <s.neumann@raumfeld.com>

card->priv must not be accessed after lbs_remove_card() was called
as lbs_remove_card() frees card->priv via free_netdev().

For libertas_sdio this is a regression introduced by 23b149c1890f9.
The correct fix to the issue described there is simply to remove the
assignment. This flag is set at the appropriate time inside
lbs_remove_card anyway.

Reported-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/if_sdio.c |    1 -
 drivers/net/wireless/libertas/if_spi.c  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

Please apply for 2.6.37

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index e5685dc..b4de0ca 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -1170,7 +1170,6 @@ static void if_sdio_remove(struct sdio_func *func)
 	lbs_deb_sdio("call remove card\n");
 	lbs_stop_card(card->priv);
 	lbs_remove_card(card->priv);
-	card->priv->surpriseremoved = 1;
 
 	flush_workqueue(card->workqueue);
 	destroy_workqueue(card->workqueue);
diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 79bcb4e..ecd4d04 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -1055,7 +1055,6 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
 	lbs_stop_card(priv);
 	lbs_remove_card(priv); /* will call free_netdev */
 
-	priv->surpriseremoved = 1;
 	free_irq(spi->irq, card);
 	if_spi_terminate_spi_thread(card);
 	if (card->pdata->teardown)
-- 
1.7.3.2

