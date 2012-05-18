Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38649 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585Ab2ERAEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 20:04:13 -0400
Received: by wibhn6 with SMTP id hn6so2338458wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 17:04:12 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH] wl1251: fix oops on early interrupt
Date: Fri, 18 May 2012 03:04:08 +0300
Message-Id: <1337299448-31880-1-git-send-email-notasas@gmail.com> (sfid-20120518_020425_290779_15B7F7AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver disables interrupt just after requesting it and enables it
later, after interface is up. However currently there is a time window
between request_irq() and disable_irq() where if interrupt arrives, the
driver oopses because it's not yet ready to process it. This can be
reproduced by inserting the module, associating and removing the module
multiple times.

Eliminate this race by setting IRQF_NOAUTOEN flag before request_irq().

Cc: stable@vger.kernel.org # v2.6.37+
Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl1251/sdio.c |    2 +-
 drivers/net/wireless/wl1251/spi.c  |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl1251/sdio.c b/drivers/net/wireless/wl1251/sdio.c
index 1b851f6..e2750a1 100644
--- a/drivers/net/wireless/wl1251/sdio.c
+++ b/drivers/net/wireless/wl1251/sdio.c
@@ -260,6 +260,7 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 	}
 
 	if (wl->irq) {
+		irq_set_status_flags(wl->irq, IRQ_NOAUTOEN);
 		ret = request_irq(wl->irq, wl1251_line_irq, 0, "wl1251", wl);
 		if (ret < 0) {
 			wl1251_error("request_irq() failed: %d", ret);
@@ -267,7 +268,6 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 		}
 
 		irq_set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
-		disable_irq(wl->irq);
 
 		wl1251_sdio_ops.enable_irq = wl1251_enable_line_irq;
 		wl1251_sdio_ops.disable_irq = wl1251_disable_line_irq;
diff --git a/drivers/net/wireless/wl1251/spi.c b/drivers/net/wireless/wl1251/spi.c
index eaa5f95..134ae9c 100644
--- a/drivers/net/wireless/wl1251/spi.c
+++ b/drivers/net/wireless/wl1251/spi.c
@@ -281,6 +281,7 @@ static int __devinit wl1251_spi_probe(struct spi_device *spi)
 
 	wl->use_eeprom = pdata->use_eeprom;
 
+	irq_set_status_flags(wl->irq, IRQ_NOAUTOEN);
 	ret = request_irq(wl->irq, wl1251_irq, 0, DRIVER_NAME, wl);
 	if (ret < 0) {
 		wl1251_error("request_irq() failed: %d", ret);
@@ -289,8 +290,6 @@ static int __devinit wl1251_spi_probe(struct spi_device *spi)
 
 	irq_set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
 
-	disable_irq(wl->irq);
-
 	ret = wl1251_init_ieee80211(wl);
 	if (ret)
 		goto out_irq;
-- 
1.7.0.4

