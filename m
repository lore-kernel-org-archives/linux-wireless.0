Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:41096 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbeAIJiN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 04:38:13 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH] staging: wilc1000: removed enum typedef BUS_ACQUIRE_T
Date: Tue, 9 Jan 2018 15:07:50 +0530
Message-ID: <1515490670-11274-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180109_103821_856136_EE1C066D)
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
index 70e3558..65cb53d 100644
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
