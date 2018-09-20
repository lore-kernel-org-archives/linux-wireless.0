Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:40789 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731752AbeITMHV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:07:21 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 27/29] staging: wilc1000: use usleep_range() in place of udelay()
Date: Thu, 20 Sep 2018 11:53:38 +0530
Message-ID: <1537424620-6982-28-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_082631_362127_07700D1C)
In-Reply-To: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes to avoid the below checkpatch warning:

'usleep_range is preferred over udelay; see
Documentation/timers/timers-howto.txt;'

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 0ec0d9b..a48c906 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -412,7 +412,7 @@ void chip_wakeup(struct wilc *wilc)
 		} while (wilc_get_chipid(wilc, true) == 0);
 	} else if ((wilc->io_type & 0x1) == HIF_SDIO) {
 		wilc->hif_func->hif_write_reg(wilc, 0xfa, 1);
-		udelay(200);
+		usleep_range(200, 400);
 		wilc->hif_func->hif_read_reg(wilc, 0xf0, &reg);
 		do {
 			wilc->hif_func->hif_write_reg(wilc, 0xf0,
-- 
2.7.4
