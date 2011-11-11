Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:51398 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1KKKSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 05:18:18 -0500
Subject: [PATCH 06/10] ath6kl: AR6004 SDIO support
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Nov 2011 12:18:14 +0200
Message-ID: <20111111101814.12075.83587.stgit@localhost6.localdomain6> (sfid-20111111_111820_668430_7C64E731)
In-Reply-To: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
References: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naveen Gangadharan <ngangadh@qca.qualcomm.com>

Add support for AR6004 SDIO. Tested scan, association (open mode) and
ping.

kvalo: change commit log a bit, drop board address changes

Signed-off-by: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif.h  |    1 +
 drivers/net/wireless/ath/ath6kl/sdio.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 15b5d98..699a036 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -35,6 +35,7 @@
 #define MAX_SCATTER_REQ_TRANSFER_SIZE    (32 * 1024)
 
 #define MANUFACTURER_ID_AR6003_BASE        0x300
+#define MANUFACTURER_ID_AR6004_BASE        0x400
     /* SDIO manufacturer ID and Codes */
 #define MANUFACTURER_ID_ATH6KL_BASE_MASK     0xFF00
 #define MANUFACTURER_CODE                  0x271	/* Atheros */
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 14e2590..3ae7582 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1290,6 +1290,8 @@ static void ath6kl_sdio_remove(struct sdio_func *func)
 static const struct sdio_device_id ath6kl_sdio_devices[] = {
 	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6003_BASE | 0x0))},
 	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6003_BASE | 0x1))},
+	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x0))},
+	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x1))},
 	{},
 };
 

