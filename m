Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:34669 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbeHCMwS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 08:52:18 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 2/3] staging: wilc1000: replace ISWILC1000() macro with inline function
Date: Fri, 3 Aug 2018 16:26:14 +0530
Message-ID: <1533293775-22456-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180803_125635_227348_FAEAECB7)
In-Reply-To: <1533293775-22456-1-git-send-email-ajay.kathat@microchip.com>
References: <1533293775-22456-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to avoid below checkpatch issue by replacing the macro
with inline function.

Macro argument 'id' may be better as '(id)' to avoid precedence issues.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 9 +++++++--
 drivers/staging/wilc1000/wilc_wlan.h | 2 --
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index cd27352..6787b6e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -11,6 +11,11 @@
 
 static enum chip_ps_states chip_ps_state = CHIP_WAKEDUP;
 
+static inline bool is_wilc1000(u32 id)
+{
+	return ((id & 0xfffff000) == 0x100000 ? true : false);
+}
+
 static inline void acquire_bus(struct wilc *wilc, enum bus_acquire acquire)
 {
 	mutex_lock(&wilc->hif_cs);
@@ -794,7 +799,7 @@ static void wilc_pllupdate_isr_ext(struct wilc *wilc, u32 int_stats)
 	else
 		mdelay(WILC_PLL_TO_SPI);
 
-	while (!(ISWILC1000(wilc_get_chipid(wilc, true)) && --trials))
+	while (!(is_wilc1000(wilc_get_chipid(wilc, true)) && --trials))
 		mdelay(1);
 }
 
@@ -1294,7 +1299,7 @@ u32 wilc_get_chipid(struct wilc *wilc, bool update)
 	if (chipid == 0 || update) {
 		wilc->hif_func->hif_read_reg(wilc, 0x1000, &tempchipid);
 		wilc->hif_func->hif_read_reg(wilc, 0x13f4, &rfrevid);
-		if (!ISWILC1000(tempchipid)) {
+		if (!is_wilc1000(tempchipid)) {
 			chipid = 0;
 			return chipid;
 		}
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 1a4ac49..7467188 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -9,8 +9,6 @@
 
 #include <linux/types.h>
 
-#define ISWILC1000(id)			((id & 0xfffff000) == 0x100000 ? 1 : 0)
-
 /********************************************
  *
  *      Mac eth header length
-- 
2.7.4
