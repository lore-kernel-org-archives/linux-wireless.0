Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:47653 "HELO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756679Ab2EXBnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 21:43:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-bluetooth@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <padovan@profusion.mobi>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] Bluetooth: btmrvl: add SD8787 Bluetooth AMP device ID
Date: Wed, 23 May 2012 18:33:20 -0700
Message-Id: <1337823200-1964-1-git-send-email-bzhao@marvell.com> (sfid-20120524_034323_389482_4579C6E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SD8787 SDIO function 3 (device ID 0x911B) is for Bluetooth AMP.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/bluetooth/btmrvl_sdio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index a853244..2867499 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -110,6 +110,9 @@ static const struct sdio_device_id btmrvl_sdio_ids[] = {
 	/* Marvell SD8787 Bluetooth device */
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, 0x911A),
 			.driver_data = (unsigned long) &btmrvl_sdio_sd8787 },
+	/* Marvell SD8787 Bluetooth AMP device */
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, 0x911B),
+			.driver_data = (unsigned long) &btmrvl_sdio_sd8787 },
 	/* Marvell SD8797 Bluetooth device */
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, 0x912A),
 			.driver_data = (unsigned long) &btmrvl_sdio_sd8797 },
-- 
1.7.0.4

