Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:39425 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752172AbeEGInu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:43:50 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 03/30] staging: wilc1000: fix line over 80 chars in handle_key()
Date: Mon, 7 May 2018 14:13:07 +0530
Message-ID: <1525682614-3824-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104354_757902_CA230ECB)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch reported issue of line over 80 char in handle_key().
Introduced new functions by spliting existing function to address the
checkpatch issue.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 59 +++++++++++++++++++------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4ba868c..29f9907 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1498,12 +1498,45 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 	return result;
 }
 
+static int wilc_pmksa_key_copy(struct wilc_vif *vif, struct key_attr *hif_key)
+{
+	int i;
+	int ret;
+	struct wid wid;
+	u8 *key_buf;
+
+	key_buf = kmalloc((hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1,
+			  GFP_KERNEL);
+	if (!key_buf)
+		return -ENOMEM;
+
+	key_buf[0] = hif_key->attr.pmkid.numpmkid;
+
+	for (i = 0; i < hif_key->attr.pmkid.numpmkid; i++) {
+		memcpy(key_buf + ((PMKSA_KEY_LEN * i) + 1),
+		       hif_key->attr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
+		memcpy(key_buf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1),
+		       hif_key->attr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
+	}
+
+	wid.id = (u16)WID_PMKID_INFO;
+	wid.type = WID_STR;
+	wid.val = (s8 *)key_buf;
+	wid.size = (hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
+
+	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+				   wilc_get_vif_idx(vif));
+
+	kfree(key_buf);
+
+	return ret;
+}
+
 static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 {
 	int result = 0;
 	struct wid wid;
 	struct wid wid_list[5];
-	u8 i;
 	u8 *key_buf;
 	s8 s8idxarray[1];
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -1547,7 +1580,8 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 						      wilc_get_vif_idx(vif));
 			kfree(key_buf);
 		} else if (hif_key->action & ADDKEY) {
-			key_buf = kmalloc(hif_key->attr.wep.key_len + 2, GFP_KERNEL);
+			key_buf = kmalloc(hif_key->attr.wep.key_len + 2,
+					  GFP_KERNEL);
 			if (!key_buf) {
 				result = -ENOMEM;
 				goto out_wep;
@@ -1715,26 +1749,7 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 		break;
 
 	case PMKSA:
-		key_buf = kmalloc((hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
-		if (!key_buf)
-			return -ENOMEM;
-
-		key_buf[0] = hif_key->attr.pmkid.numpmkid;
-
-		for (i = 0; i < hif_key->attr.pmkid.numpmkid; i++) {
-			memcpy(key_buf + ((PMKSA_KEY_LEN * i) + 1), hif_key->attr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
-			memcpy(key_buf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), hif_key->attr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
-		}
-
-		wid.id = (u16)WID_PMKID_INFO;
-		wid.type = WID_STR;
-		wid.val = (s8 *)key_buf;
-		wid.size = (hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
-
-		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-					      wilc_get_vif_idx(vif));
-
-		kfree(key_buf);
+		result = wilc_pmksa_key_copy(vif, hif_key);
 		break;
 	}
 
-- 
2.7.4
