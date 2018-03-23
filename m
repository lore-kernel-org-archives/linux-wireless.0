Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:34176 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751777AbeCWPJV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 11:09:21 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 4/9] staging: wilc1000: free memory allocated in add wep key functions
Date: Fri, 23 Mar 2018 20:38:53 +0530
Message-ID: <1521817738-7557-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180323_160925_241863_7C5BE4D4)
In-Reply-To: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
References: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Free memory allocated for wep key when command enqueue is failed.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1cc4c08..c958dd3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2727,8 +2727,10 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 	msg.body.key_info.attr.wep.index = index;
 
 	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "STA - WEP Key\n");
+		kfree(msg.body.key_info.attr.wep.key);
+	}
 	wait_for_completion(&hif_drv->comp_test_key_block);
 
 	return result;
@@ -2763,10 +2765,12 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 
 	result = wilc_enqueue_cmd(&msg);
 
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "AP - WEP Key\n");
-	else
+		kfree(msg.body.key_info.attr.wep.key);
+	} else {
 		wait_for_completion(&hif_drv->comp_test_key_block);
+	}
 
 	return result;
 }
-- 
2.7.4
