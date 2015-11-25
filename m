Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:10252 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbbKYC5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 21:57:14 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/10] staging: wilc1000: change if with else if
Date: Wed, 25 Nov 2015 11:59:48 +0900
Message-ID: <1448420389-4192-9-git-send-email-glen.lee@atmel.com> (sfid-20151125_035722_797435_859C2A00)
In-Reply-To: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
References: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

The if statement should be else if since it is part of whole if condition.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0b85640..c309deb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1764,9 +1764,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 						strWIDList, 4,
 						get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
-		}
-
-		if (pstrHostIFkeyAttr->action & ADDKEY) {
+		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
 			pu8keybuf = kmalloc(pstrHostIFkeyAttr->attr.wep.key_len + 2, GFP_KERNEL);
 			if (!pu8keybuf) {
@@ -1848,9 +1846,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
-		}
-
-		if (pstrHostIFkeyAttr->action & ADDKEY) {
+		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling group key(Rx) function\n");
 
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
@@ -1921,8 +1917,7 @@ _WPARxGtk_end_case_:
 						get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
-		}
-		if (pstrHostIFkeyAttr->action & ADDKEY) {
+		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
 			if (!pu8keybuf) {
 				PRINT_ER("No buffer to send PTK Key\n");
-- 
1.9.1

