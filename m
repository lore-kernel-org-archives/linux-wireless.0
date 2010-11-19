Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22578 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab0KSLQT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 06:16:19 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 03:16:06 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 3/4] ath9k_hw: Fix eeprom offset for AR9287 devices (PCI/USB)
Date: Fri, 19 Nov 2010 16:53:21 +0530
Message-ID: <1290165802-3566-3-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1290165802-3566-1-git-send-email-rmanoharan@atheros.com>
References: <1290165802-3566-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9287 devices (PCI/USB) use different eeprom start location
to read nvram. New devices might endup with same devid. So use
driver_info to set offset, instead of devid. driver_info is
valid for HTC devices alone which is filled in usb_device_id.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    6 +++---
 drivers/net/wireless/ath/ath9k/reg.h         |    4 ----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 3ad1de2..353085b 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -37,10 +37,10 @@ static bool ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 	int addr, eep_start_loc;
 	eep_data = (u16 *)eep;
 
-	if (AR9287_HTC_DEVID(ah))
-		eep_start_loc = AR9287_HTC_EEP_START_LOC;
-	else
+	if (!common->driver_info)
 		eep_start_loc = AR9287_EEP_START_LOC;
+	else
+		eep_start_loc = AR9287_HTC_EEP_START_LOC;
 
 	if (!ath9k_hw_use_flash(ah)) {
 		ath_print(common, ATH_DBG_EEPROM,
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 443407d..f444a37 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -870,10 +870,6 @@
 	 ((_ah)->hw_version.devid == 0xA704) || \
 	 ((_ah)->hw_version.devid == 0x1200))
 
-#define AR9287_HTC_DEVID(_ah) \
-	(((_ah)->hw_version.devid == 0x7015) || \
-	 ((_ah)->hw_version.devid == 0x1200))
-
 #define AR_RADIO_SREV_MAJOR                   0xf0
 #define AR_RAD5133_SREV_MAJOR                 0xc0
 #define AR_RAD2133_SREV_MAJOR                 0xd0
-- 
1.7.3.2

