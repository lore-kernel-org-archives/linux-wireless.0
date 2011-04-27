Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50121 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1D0LkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 07:40:22 -0400
Received: by pvg12 with SMTP id 12so1117897pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 04:40:21 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19896.320.210604.388400@gargle.gargle.HOWL> (sfid-20110427_134025_676656_A16D9DE2)
Date: Wed, 27 Apr 2011 17:12:56 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 1/4] ath9k_htc: Increase credit size for AR7010 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Bump the firmware version to 1.2

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.h      |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 9a52ccc..2bdcdbc 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -18,7 +18,7 @@
 #define HTC_USB_H
 
 #define MAJOR_VERSION_REQ 1
-#define MINOR_VERSION_REQ 1
+#define MINOR_VERSION_REQ 2
 
 #define IS_AR7010_DEVICE(_v) (((_v) == AR9280_USB) || ((_v) == AR9287_USB))
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index dbf5f95..d2dd5a6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -243,7 +243,7 @@ static int ath9k_init_htc_services(struct ath9k_htc_priv *priv, u16 devid,
 	 */
 
 	if (IS_AR7010_DEVICE(drv_info))
-		priv->htc->credits = 45;
+		priv->htc->credits = 48;
 	else
 		priv->htc->credits = 33;
 
-- 
1.7.4.4

