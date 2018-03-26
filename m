Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:14434 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbeCZLqY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 07:46:24 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 4/9] staging: wilc1000: free memory allocated in add wep key functions
Date: Mon, 26 Mar 2018 17:15:58 +0530
Message-ID: <1522064763-11576-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180326_134627_071701_FD910C2D)
In-Reply-To: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
References: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Free memory allocated for wep key when command enqueue is failed.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1cc4c08..4db15c7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2704,7 +2704,7 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 			     u8 index)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -2727,17 +2727,20 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 	msg.body.key_info.attr.wep.index = index;
 
 	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "STA - WEP Key\n");
-	wait_for_completion(&hif_drv->comp_test_key_block);
+		kfree(msg.body.key_info.attr.wep.key);
+		return result;
+	}
 
-	return result;
+	wait_for_completion(&hif_drv->comp_test_key_block);
+	return 0;
 }
 
 int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 			    u8 index, u8 mode, enum AUTHTYPE auth_type)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -2762,13 +2765,14 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 	msg.body.key_info.attr.wep.auth_type = auth_type;
 
 	result = wilc_enqueue_cmd(&msg);
-
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "AP - WEP Key\n");
-	else
-		wait_for_completion(&hif_drv->comp_test_key_block);
+		kfree(msg.body.key_info.attr.wep.key);
+		return result;
+	}
 
-	return result;
+	wait_for_completion(&hif_drv->comp_test_key_block);
+	return 0;
 }
 
 int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
-- 
2.7.4
