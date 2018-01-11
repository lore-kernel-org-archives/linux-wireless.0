Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:9146 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933305AbeAKPJH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 10:09:07 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 4/6] staging: wilc1000: removed enum typedef CHIP_PS_STATE_T
Date: Thu, 11 Jan 2018 19:42:17 +0530
Message-ID: <1515679939-13202-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180111_160922_298727_0C6AF77F)
In-Reply-To: <1515679939-13202-1-git-send-email-ajay.kathat@microchip.com>
References: <1515679939-13202-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes enum typedef CHIP_PS_STATE_T and introduce
enum chip_ps_states to use instead of typedef.

checkpatch.pl not to add new typedef warning is fixed with this patch.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c    | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f49dfa8..3a58a62 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -4,7 +4,7 @@
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
-static CHIP_PS_STATE_T chip_ps_state = CHIP_WAKEDUP;
+static enum chip_ps_states chip_ps_state = CHIP_WAKEDUP;
 
 static inline void acquire_bus(struct wilc *wilc, BUS_ACQUIRE_T acquire)
 {
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index db2dab4..ab12090 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -137,11 +137,11 @@ typedef enum {
 	MAX_PSPOLL_PS		= 4
 } USER_PS_MODE_T;
 
-typedef enum {
+enum chip_ps_states {
 	CHIP_WAKEDUP		= 0,
 	CHIP_SLEEPING_AUTO      = 1,
 	CHIP_SLEEPING_MANUAL	= 2
-} CHIP_PS_STATE_T;
+};
 
 typedef enum {
 	ACQUIRE_ONLY            = 0,
-- 
2.7.4
