Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:58440 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755818AbeDYRTg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:36 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 05/21] staging: wicl1000: removed the unsed variables in wilc_parse_network_info()
Date: Wed, 25 Apr 2018 22:48:10 +0530
Message-ID: <1524676706-13179-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_191943_423526_C87066AE)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unused variables in
wilc_parse_network_info(). The value is assinged to these local
variables but assinged value is not used in that function.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index db66b1c..5bc9d78 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -272,10 +272,6 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 {
 	struct network_info *network_info = NULL;
 	u8 msg_type = 0;
-	u8 msg_id = 0;
-	u16 msg_len = 0;
-
-	u16 wid_id = (u16)WID_NIL;
 	u16 wid_len  = 0;
 	u8 *wid_val = NULL;
 
@@ -284,9 +280,6 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 	if ('N' != msg_type)
 		return -EFAULT;
 
-	msg_id = msg_buffer[1];
-	msg_len = MAKE_WORD16(msg_buffer[2], msg_buffer[3]);
-	wid_id = MAKE_WORD16(msg_buffer[4], msg_buffer[5]);
 	wid_len = MAKE_WORD16(msg_buffer[6], msg_buffer[7]);
 	wid_val = &msg_buffer[8];
 
-- 
2.7.4
