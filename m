Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753121AbeBSPaY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:24 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 05/14] staging: wilc1000: rename pstrHostIfRegisterFrame to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:35 +0530
Message-ID: <1519054184-14301-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163029_394070_E1C1D95C)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 11e4737..eda395d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2290,7 +2290,7 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 }
 
 static int Handle_RegisterFrame(struct wilc_vif *vif,
-				struct reg_frame *pstrHostIfRegisterFrame)
+				struct reg_frame *hif_reg_frame)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2304,9 +2304,9 @@ static int Handle_RegisterFrame(struct wilc_vif *vif,
 
 	cur_byte = wid.val;
 
-	*cur_byte++ = pstrHostIfRegisterFrame->reg;
-	*cur_byte++ = pstrHostIfRegisterFrame->reg_id;
-	memcpy(cur_byte, &pstrHostIfRegisterFrame->frame_type, sizeof(u16));
+	*cur_byte++ = hif_reg_frame->reg;
+	*cur_byte++ = hif_reg_frame->reg_id;
+	memcpy(cur_byte, &hif_reg_frame->frame_type, sizeof(u16));
 
 	wid.size = sizeof(u16) + 2;
 
-- 
2.7.4
