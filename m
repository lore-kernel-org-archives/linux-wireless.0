Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out-061.synserver.de ([212.40.185.61]:1035 "EHLO
	smtp-out-061.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbbCONdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 09:33:18 -0400
From: Lars-Peter Clausen <lars@metafoo.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Solomon Peachy <pizza@shaftnet.org>,
	linux-wireless@vger.kernel.org,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] wireless: cw1200: Fix suspend
Date: Sun, 15 Mar 2015 14:26:20 +0100
Message-Id: <1426425980-21743-1-git-send-email-lars@metafoo.de> (sfid-20150315_143323_560394_6CABB443)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cw1200 driver implements suspend and resume callbacks and assigns them
to the suspend and resume fields of the device_driver struct. These
callbacks are never actually called by anything though.

Modify the driver to properly use dev_pm_ops so that the suspend function
is actually executed upon suspend and drop the empty resume function.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/net/wireless/cw1200/cw1200_spi.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 964b64a..7603546 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -447,7 +447,7 @@ static int cw1200_spi_disconnect(struct spi_device *func)
 }
 
 #ifdef CONFIG_PM
-static int cw1200_spi_suspend(struct device *dev, pm_message_t state)
+static int cw1200_spi_suspend(struct device *dev)
 {
 	struct hwbus_priv *self = spi_get_drvdata(to_spi_device(dev));
 
@@ -458,10 +458,8 @@ static int cw1200_spi_suspend(struct device *dev, pm_message_t state)
 	return 0;
 }
 
-static int cw1200_spi_resume(struct device *dev)
-{
-	return 0;
-}
+static SIMPLE_DEV_PM_OPS(cw1200_pm_ops, cw1200_spi_suspend, NULL);
+
 #endif
 
 static struct spi_driver spi_driver = {
@@ -472,8 +470,7 @@ static struct spi_driver spi_driver = {
 		.bus            = &spi_bus_type,
 		.owner          = THIS_MODULE,
 #ifdef CONFIG_PM
-		.suspend        = cw1200_spi_suspend,
-		.resume         = cw1200_spi_resume,
+		.pm		= &cw1200_pm_ops,
 #endif
 	},
 };
-- 
1.8.0

