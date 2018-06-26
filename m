Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:31274 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751909AbeFZGHg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:07:36 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/12] staging: wilc1000: handle freeing of key data in wep add key
Date: Tue, 26 Jun 2018 11:37:09 +0530
Message-ID: <1529993234-27294-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180626_080741_986276_E02FD2BF)
In-Reply-To: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
References: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modified the code to free the allocated memory, used to store the key in
wilc_add_wep_key_bss_sta() and wilc_add_wep_key_bss_ap().
After work completion notification is received, free the
memory allocated to avoid missing of free in work function.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6d27a9d..2cc9689 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1551,8 +1551,6 @@ static void handle_key(struct work_struct *work)
 			memcpy(&key_buf[2], hif_key->attr.wep.key,
 			       hif_key->attr.wep.key_len);
 
-			kfree(hif_key->attr.wep.key);
-
 			wid_list[2].id = (u16)WID_WEP_KEY_VALUE;
 			wid_list[2].type = WID_STR;
 			wid_list[2].size = hif_key->attr.wep.key_len + 2;
@@ -1573,7 +1571,6 @@ static void handle_key(struct work_struct *work)
 			memcpy(key_buf + 1, &hif_key->attr.wep.key_len, 1);
 			memcpy(key_buf + 2, hif_key->attr.wep.key,
 			       hif_key->attr.wep.key_len);
-			kfree(hif_key->attr.wep.key);
 
 			wid.id = (u16)WID_ADD_WEP_KEY;
 			wid.type = WID_STR;
@@ -2629,8 +2626,6 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 		goto free_key;
 
 	wait_for_completion(&msg->work_comp);
-	kfree(msg);
-	return 0;
 
 free_key:
 	kfree(msg->body.key_info.attr.wep.key);
@@ -2674,8 +2669,6 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 		goto free_key;
 
 	wait_for_completion(&msg->work_comp);
-	kfree(msg);
-	return 0;
 
 free_key:
 	kfree(msg->body.key_info.attr.wep.key);
-- 
2.7.4
