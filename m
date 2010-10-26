Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19180 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab0JZOgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 10:36:42 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 07:36:31 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: Set proper firmware offset for AR7010 devices
Date: Tue, 26 Oct 2010 20:12:44 +0530
Message-ID: <1288104164-18940-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch handles the firmware loading properly for
AR7010 HTC devices.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 728d904..6576f68 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -801,10 +801,16 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 	}
 	kfree(buf);
 
-	if ((hif_dev->device_id == 0x7010) || (hif_dev->device_id == 0x7015))
+	switch (hif_dev->device_id) {
+	case 0x7010:
+	case 0x7015:
+	case 0x9018:
 		firm_offset = AR7010_FIRMWARE_TEXT;
-	else
+		break;
+	default:
 		firm_offset = AR9271_FIRMWARE_TEXT;
+		break;
+	}
 
 	/*
 	 * Issue FW download complete command to firmware.
-- 
1.7.3.2

