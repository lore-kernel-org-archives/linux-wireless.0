Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:41833 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752212AbeCNMpu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 08:45:50 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com
Cc: hariprasath.elango@gmail.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] staging: wilc1000: remove unwanted braces and correct code alignment
Date: Wed, 14 Mar 2018 18:15:04 +0530
Message-Id: <31227bdc32df8b76d6a81ca224e1381020f681df.1521030891.git.hariprasath.elango@gmail.com> (sfid-20180314_134600_999017_C38FBCAF)
In-Reply-To: <cover.1521030891.git.hariprasath.elango@gmail.com>
References: <cover.1521030891.git.hariprasath.elango@gmail.com>
In-Reply-To: <cover.1521030891.git.hariprasath.elango@gmail.com>
References: <cover.1521030891.git.hariprasath.elango@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

Remove the unwated brace and corrected the code block alignment
accordingly

Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a4ee175..0fac8e1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -984,20 +984,19 @@ static s32 handle_connect(struct wilc_vif *vif,
 	wid_list[wid_cnt].val = (s8 *)(&(dummyval));
 	wid_cnt++;
 
-	{
-		wid_list[wid_cnt].id = WID_INFO_ELEMENT_ASSOCIATE;
-		wid_list[wid_cnt].type = WID_BIN_DATA;
-		wid_list[wid_cnt].val = hif_drv->usr_conn_req.ies;
-		wid_list[wid_cnt].size = hif_drv->usr_conn_req.ies_len;
-		wid_cnt++;
-
-		if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
-			info_element_size = hif_drv->usr_conn_req.ies_len;
-			info_element = kmalloc(info_element_size, GFP_KERNEL);
-			memcpy(info_element, hif_drv->usr_conn_req.ies,
-			       info_element_size);
-		}
+	wid_list[wid_cnt].id = WID_INFO_ELEMENT_ASSOCIATE;
+	wid_list[wid_cnt].type = WID_BIN_DATA;
+	wid_list[wid_cnt].val = hif_drv->usr_conn_req.ies;
+	wid_list[wid_cnt].size = hif_drv->usr_conn_req.ies_len;
+	wid_cnt++;
+
+	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
+		info_element_size = hif_drv->usr_conn_req.ies_len;
+		info_element = kmalloc(info_element_size, GFP_KERNEL);
+		memcpy(info_element, hif_drv->usr_conn_req.ies,
+				info_element_size);
 	}
+
 	wid_list[wid_cnt].id = (u16)WID_11I_MODE;
 	wid_list[wid_cnt].type = WID_CHAR;
 	wid_list[wid_cnt].size = sizeof(char);
-- 
2.10.0.GIT
