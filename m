Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:57876 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab1J1NXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 09:23:35 -0400
Subject: [PATCH] ath6kl: change name of sdio driver to ath6kl
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Oct 2011 16:23:26 +0300
Message-ID: <20111028132326.31841.70943.stgit@localhost6.localdomain6> (sfid-20111028_152338_775594_06B55624)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the name of the driver in struct sdio_driver is "ath6kl_sdio",
this is for example what uevent advertises. This is wrong as the module
is named as ath6kl.ko. Change it to "ath6kl" so that the names match.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 682c47c..56f83c4 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -914,7 +914,7 @@ static const struct sdio_device_id ath6kl_sdio_devices[] = {
 MODULE_DEVICE_TABLE(sdio, ath6kl_sdio_devices);
 
 static struct sdio_driver ath6kl_sdio_driver = {
-	.name = "ath6kl_sdio",
+	.name = "ath6kl",
 	.id_table = ath6kl_sdio_devices,
 	.probe = ath6kl_sdio_probe,
 	.remove = ath6kl_sdio_remove,

