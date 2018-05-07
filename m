Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:24730 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752172AbeEGInq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:43:46 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 02/30] staging: wilc1000: remove 'ret' variable in handle_key()
Date: Mon, 7 May 2018 14:13:06 +0530
Message-ID: <1525682614-3824-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104351_306322_5B1355BF)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the use of unnecessary 'ret' variable and use existing 'result'
variable to hold the status. Also changed type of 'result' from s32 to
int to confirm with the function return type.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d903ae5..4ba868c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1500,13 +1500,12 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 
 static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 {
-	s32 result = 0;
+	int result = 0;
 	struct wid wid;
 	struct wid wid_list[5];
 	u8 i;
 	u8 *key_buf;
 	s8 s8idxarray[1];
-	s8 ret = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	switch (hif_key->type) {
@@ -1597,7 +1596,7 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 		if (hif_key->action & ADDKEY_AP) {
 			key_buf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (!key_buf) {
-				ret = -ENOMEM;
+				result = -ENOMEM;
 				goto out_wpa_rx_gtk;
 			}
 
@@ -1627,7 +1626,7 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 		} else if (hif_key->action & ADDKEY) {
 			key_buf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (!key_buf) {
-				ret = -ENOMEM;
+				result = -ENOMEM;
 				goto out_wpa_rx_gtk;
 			}
 
@@ -1657,16 +1656,13 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 		complete(&hif_drv->comp_test_key_block);
 		kfree(hif_key->attr.wpa.key);
 		kfree(hif_key->attr.wpa.seq);
-		if (ret)
-			return ret;
-
 		break;
 
 	case WPA_PTK:
 		if (hif_key->action & ADDKEY_AP) {
 			key_buf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
 			if (!key_buf) {
-				ret = -ENOMEM;
+				result = -ENOMEM;
 				goto out_wpa_ptk;
 			}
 
@@ -1693,7 +1689,7 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 		} else if (hif_key->action & ADDKEY) {
 			key_buf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
 			if (!key_buf) {
-				ret = -ENOMEM;
+				result = -ENOMEM;
 				goto out_wpa_ptk;
 			}
 
@@ -1716,9 +1712,6 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 out_wpa_ptk:
 		complete(&hif_drv->comp_test_key_block);
 		kfree(hif_key->attr.wpa.key);
-		if (ret)
-			return ret;
-
 		break;
 
 	case PMKSA:
-- 
2.7.4
