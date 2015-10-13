Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3540 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbbJMKza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:55:30 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 45/54] staging: wilc1000: rename u8Num_AssocSta of struct del_all_sta
Date: Tue, 13 Oct 2015 19:50:10 +0900
Message-ID: <1444733419-17679-45-git-send-email-tony.cho@atmel.com> (sfid-20151013_125533_070954_7841DC02)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8Num_AssocSta of struct del_all_sta to assoc_sta to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5ee8d54..42f59fa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -146,7 +146,7 @@ struct set_multicast {
 
 struct del_all_sta {
 	u8 del_all_sta[MAX_NUM_STA][ETH_ALEN];
-	u8 u8Num_AssocSta;
+	u8 assoc_sta;
 };
 
 struct del_sta {
@@ -2493,17 +2493,17 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 
 	strWID.id = (u16)WID_DEL_ALL_STA;
 	strWID.type = WID_STR;
-	strWID.size = (pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1;
+	strWID.size = (pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1;
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
-	strWID.val = kmalloc((pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1, GFP_KERNEL);
+	strWID.val = kmalloc((pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1, GFP_KERNEL);
 	if (strWID.val == NULL)
 		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.val;
 
-	*(pu8CurrByte++) = pstrDelAllStaParam->u8Num_AssocSta;
+	*(pu8CurrByte++) = pstrDelAllStaParam->assoc_sta;
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
 		if (memcmp(pstrDelAllStaParam->del_all_sta[i], au8Zero_Buff, ETH_ALEN))
@@ -4809,7 +4809,7 @@ s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 		return s32Error;
 	}
 
-	pstrDelAllStationMsg->u8Num_AssocSta = u8AssocNumb;
+	pstrDelAllStationMsg->assoc_sta = u8AssocNumb;
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
 
-- 
1.9.1

