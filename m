Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:9146 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933305AbeAKPJK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 10:09:10 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 5/6] staging: wilc1000: removed enum typedef BUS_ACQUIRE_T
Date: Thu, 11 Jan 2018 19:42:18 +0530
Message-ID: <1515679939-13202-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180111_160922_896047_876F10F3)
In-Reply-To: <1515679939-13202-1-git-send-email-ajay.kathat@microchip.com>
References: <1515679939-13202-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes enum typedef BUS_ACQUIRE_T and define
enum bus_acquire to use instead of typedef.

checkpatch.pl not to add new typedef warning is fixed with this patch.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c    | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 3a58a62..80a5a0b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -6,7 +6,7 @@
 
 static enum chip_ps_states chip_ps_state = CHIP_WAKEDUP;
 
-static inline void acquire_bus(struct wilc *wilc, BUS_ACQUIRE_T acquire)
+static inline void acquire_bus(struct wilc *wilc, enum bus_acquire acquire)
 {
 	mutex_lock(&wilc->hif_cs);
 	if (acquire == ACQUIRE_AND_WAKEUP)
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index ab12090..2bc500d 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -143,10 +143,10 @@ enum chip_ps_states {
 	CHIP_SLEEPING_MANUAL	= 2
 };
 
-typedef enum {
+enum bus_acquire {
 	ACQUIRE_ONLY            = 0,
 	ACQUIRE_AND_WAKEUP	= 1,
-} BUS_ACQUIRE_T;
+};
 
 typedef enum {
 	RELEASE_ONLY		= 0,
-- 
2.7.4
