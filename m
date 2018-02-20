Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3080 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbeBTO6X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:58:23 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/12] staging: wilc1000: rename pu32InactiveTime to avoid camelCase
Date: Tue, 20 Feb 2018 20:27:53 +0530
Message-ID: <1519138681-1982-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180220_155826_348633_A6237DF8)
In-Reply-To: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
References: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f79618a..fd21765 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3164,7 +3164,7 @@ int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 }
 
 s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
-			   u32 *pu32InactiveTime)
+			   u32 *out_val)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3187,7 +3187,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 	else
 		wait_for_completion(&hif_drv->comp_inactive_time);
 
-	*pu32InactiveTime = inactive_time;
+	*out_val = inactive_time;
 
 	return result;
 }
-- 
2.7.4
