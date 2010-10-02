Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48776 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0JBL5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 07:57:41 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Nicolas Pitre <nico@fluxnic.net>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 11/11] wl1271: sdio: add suspend/resume support
Date: Sat,  2 Oct 2010 13:54:15 +0200
Message-Id: <1286020455-28946-12-git-send-email-ohad@wizery.com>
In-Reply-To: <1286020455-28946-1-git-send-email-ohad@wizery.com>
References: <1286020455-28946-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add required suspend/resume support to prevent the SDIO
core from removing our card completely during system suspend.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index f7bef32..784ef34 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -290,11 +290,31 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 	wl1271_free_hw(wl);
 }
 
+static int wl1271_suspend(struct device *dev)
+{
+	/* Tell MMC/SDIO core it's OK to power down the card
+	 * (if it isn't already), but not to remove it completely */
+	return 0;
+}
+
+static int wl1271_resume(struct device *dev)
+{
+	return 0;
+}
+
+static const struct dev_pm_ops wl1271_sdio_pm_ops = {
+	.suspend	= wl1271_suspend,
+	.resume		= wl1271_resume,
+};
+
 static struct sdio_driver wl1271_sdio_driver = {
 	.name		= "wl1271_sdio",
 	.id_table	= wl1271_devices,
 	.probe		= wl1271_probe,
 	.remove		= __devexit_p(wl1271_remove),
+	.drv = {
+		.pm = &wl1271_sdio_pm_ops,
+	},
 };
 
 static int __init wl1271_init(void)
-- 
1.7.0.4

