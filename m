Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:42486 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752357AbeEKINy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:13:54 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 01/30] staging: wilc1000: added complete() call for error scenario in handle_key()
Date: Fri, 11 May 2018 13:43:02 +0530
Message-ID: <1526026411-11058-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_101358_176853_77F277C2)
In-Reply-To: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
References: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During memory allocation failure in handle_key() the complete() was not
called for comp_test_key_block event. So now added the code to call
complete() for event during error scenario.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b5f3829..652f51c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1513,8 +1513,10 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 
 			key_buf = kmalloc(hif_key->attr.wep.key_len + 2,
 					  GFP_KERNEL);
-			if (!key_buf)
-				return -ENOMEM;
+			if (!key_buf) {
+				result = -ENOMEM;
+				goto out_wep;
+			}
 
 			key_buf[0] = hif_key->attr.wep.index;
 			key_buf[1] = hif_key->attr.wep.key_len;
@@ -1535,8 +1537,10 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 			kfree(key_buf);
 		} else if (hif_key->action & ADDKEY) {
 			key_buf = kmalloc(hif_key->attr.wep.key_len + 2, GFP_KERNEL);
-			if (!key_buf)
-				return -ENOMEM;
+			if (!key_buf) {
+				result = -ENOMEM;
+				goto out_wep;
+			}
 			key_buf[0] = hif_key->attr.wep.index;
 			memcpy(key_buf + 1, &hif_key->attr.wep.key_len, 1);
 			memcpy(key_buf + 2, hif_key->attr.wep.key,
@@ -1573,6 +1577,7 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
 		}
+out_wep:
 		complete(&hif_drv->comp_test_key_block);
 		break;
 
@@ -1607,7 +1612,6 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 						      wilc_get_vif_idx(vif));
 
 			kfree(key_buf);
-			complete(&hif_drv->comp_test_key_block);
 		} else if (hif_key->action & ADDKEY) {
 			key_buf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (!key_buf) {
@@ -1636,9 +1640,9 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 						      wilc_get_vif_idx(vif));
 
 			kfree(key_buf);
-			complete(&hif_drv->comp_test_key_block);
 		}
 out_wpa_rx_gtk:
+		complete(&hif_drv->comp_test_key_block);
 		kfree(hif_key->attr.wpa.key);
 		kfree(hif_key->attr.wpa.seq);
 		if (ret)
@@ -1674,7 +1678,6 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 						      wid_list, 2,
 						      wilc_get_vif_idx(vif));
 			kfree(key_buf);
-			complete(&hif_drv->comp_test_key_block);
 		} else if (hif_key->action & ADDKEY) {
 			key_buf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
 			if (!key_buf) {
@@ -1696,10 +1699,10 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
 			kfree(key_buf);
-			complete(&hif_drv->comp_test_key_block);
 		}
 
 out_wpa_ptk:
+		complete(&hif_drv->comp_test_key_block);
 		kfree(hif_key->attr.wpa.key);
 		if (ret)
 			return ret;
-- 
2.7.4
