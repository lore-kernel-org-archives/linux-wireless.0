Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:43637 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZFOW2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 18:28:06 -0400
Received: by pxi27 with SMTP id 27so502030pxi.33
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2009 15:28:09 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org, dcbw@redhat.com,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] libertas: Fix interface driver unload with PS mode
Date: Mon, 15 Jun 2009 15:29:20 -0700
Message-Id: <1245104960-2199-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When IEEE PS mode is enabled, lbs_remove_card needs to exit PS mode
before returning.  It will then set surpriseremoved=1, which blocks any
further attempts to issue commands.  In the SDIO, SPI, and USB drivers,
lbs_remove_card is called with surpriseremoved already set, which makes
it impossible to exit PS mode.  As a result, reloading the driver while
PS mode is enabled does not work.

This patch removes the setting of surpriseremoved in the interface
drivers and corrects the order in which lbs_stop_card and
lbs_remove_card are called.  Tested on SPI with V9 firmware.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 drivers/net/wireless/libertas/if_sdio.c |    2 --
 drivers/net/wireless/libertas/if_spi.c  |    4 ++--
 drivers/net/wireless/libertas/if_usb.c  |    1 -
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 8cdb88c..6bb95ce 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -1096,8 +1096,6 @@ static void if_sdio_remove(struct sdio_func *func)
 			lbs_pr_alert("CMD_FUNC_SHUTDOWN cmd failed\n");
 	}
 
-	card->priv->surpriseremoved = 1;
-
 	lbs_deb_sdio("call remove card\n");
 	lbs_stop_card(card->priv);
 	lbs_remove_card(card->priv);
diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 923ed58..757352c 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -1171,12 +1171,12 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
 
 	lbs_deb_spi("libertas_spi_remove\n");
 	lbs_deb_enter(LBS_DEB_SPI);
-	priv->surpriseremoved = 1;
 
 	lbs_stop_card(priv);
+	lbs_remove_card(priv); /* will call free_netdev */
+
 	free_irq(spi->irq, card);
 	if_spi_terminate_spi_thread(card);
-	lbs_remove_card(priv); /* will call free_netdev */
 	if (card->pdata->teardown)
 		card->pdata->teardown(spi);
 	free_if_spi_card(card);
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index ea3dc03..7e03f0e 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -357,7 +357,6 @@ static void if_usb_disconnect(struct usb_interface *intf)
 	cardp->surprise_removed = 1;
 
 	if (priv) {
-		priv->surpriseremoved = 1;
 		lbs_stop_card(priv);
 		lbs_remove_card(priv);
 	}
-- 
1.5.6.3

