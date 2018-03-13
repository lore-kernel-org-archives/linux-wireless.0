Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35957 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932514AbeCMKxA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 06:53:00 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com
Cc: hariprasath.elango@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: remove unwanted braces and correct code alignment
Date: Tue, 13 Mar 2018 16:22:38 +0530
Message-Id: <20180313105238.12838-1-hariprasath.elango@gmail.com> (sfid-20180313_115315_029920_5433B66D)
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
