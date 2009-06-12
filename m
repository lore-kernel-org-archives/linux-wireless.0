Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:64343 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbZFLLOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:14:47 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 03/33] wl12xx: fix error handling in wl12xx_probe()
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:14:34 +0300
Message-ID: <20090612111434.8877.19671.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Resources were not freed properly in some cases.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index c6a4544..6d27cd6 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1274,13 +1274,15 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	wl->set_power = pdata->set_power;
 	if (!wl->set_power) {
 		wl12xx_error("set power function missing in platform data");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_free;
 	}
 
 	wl->irq = spi->irq;
 	if (wl->irq < 0) {
 		wl12xx_error("irq missing in platform data");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_free;
 	}
 
 	ret = request_irq(wl->irq, wl12xx_irq, 0, DRIVER_NAME, wl);

