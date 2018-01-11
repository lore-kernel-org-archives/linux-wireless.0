Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:9146 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933305AbeAKPJN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 10:09:13 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 6/6] staging: wilc1000: removed enum typedef BUS_RELEASE_T
Date: Thu, 11 Jan 2018 19:42:19 +0530
Message-ID: <1515679939-13202-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180111_160923_473631_5C26E258)
In-Reply-To: <1515679939-13202-1-git-send-email-ajay.kathat@microchip.com>
References: <1515679939-13202-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes enum typedef BUS_RELEASE_T and define
"enum bus_release" to use instead of typedef.

checkpatch.pl not to add new typedef warning is fixed with this patch.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c    | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 80a5a0b..a2b26ec 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -13,7 +13,7 @@ static inline void acquire_bus(struct wilc *wilc, enum bus_acquire acquire)
 		chip_wakeup(wilc);
 }
 
-static inline void release_bus(struct wilc *wilc, BUS_RELEASE_T release)
+static inline void release_bus(struct wilc *wilc, enum bus_release release)
 {
 	if (release == RELEASE_ALLOW_SLEEP)
 		chip_allow_sleep(wilc);
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 2bc500d..1641ddb 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -148,10 +148,10 @@ enum bus_acquire {
 	ACQUIRE_AND_WAKEUP	= 1,
 };
 
-typedef enum {
+enum bus_release {
 	RELEASE_ONLY		= 0,
 	RELEASE_ALLOW_SLEEP	= 1,
-} BUS_RELEASE_T;
+};
 
 typedef enum {
 	NO_SECURITY		= 0,
-- 
2.7.4
