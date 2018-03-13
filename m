Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:41131 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbeCMMtw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 08:49:52 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com
Cc: hariprasath.elango@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: use kmemdup to replace kmalloc/memcpy
Date: Tue, 13 Mar 2018 18:19:32 +0530
Message-Id: <20180313124932.15038-1-hariprasath.elango@gmail.com> (sfid-20180313_135013_537077_FEFAD571)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

kmalloc followed by memcpy can be replaced by kmemdup.Also added the
related error handling part

Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0fac8e1..4ae2da6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -992,9 +992,13 @@ static s32 handle_connect(struct wilc_vif *vif,
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
 		info_element_size = hif_drv->usr_conn_req.ies_len;
-		info_element = kmalloc(info_element_size, GFP_KERNEL);
-		memcpy(info_element, hif_drv->usr_conn_req.ies,
-				info_element_size);
+		info_element = kmemdup(hif_drv->usr_conn_req.ies,
+				       info_element_size,
+				       GFP_KERNEL);
+		if (!info_element) {
+			result = -ENOMEM;
+			goto ERRORHANDLER;
+		}
 	}
 
 	wid_list[wid_cnt].id = (u16)WID_11I_MODE;
-- 
2.10.0.GIT
