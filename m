Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:4727 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbbJMLCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 07:02:34 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 47/54] staging: wilc1000: rename u32count of struct set_multicast
Date: Tue, 13 Oct 2015 20:02:05 +0900
Message-ID: <1444734132-17858-2-git-send-email-tony.cho@atmel.com> (sfid-20151013_130236_994923_2DB749FF)
In-Reply-To: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
References: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32count of struct set_multicast to cnt to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7ea9e01..9cd42f7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -141,7 +141,7 @@ struct beacon_attr {
 
 struct set_multicast {
 	bool enabled;
-	u32 u32count;
+	u32 cnt;
 };
 
 struct del_all_sta {
@@ -2790,7 +2790,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 
 	strWID.id = (u16)WID_SETUP_MULTICAST_FILTER;
 	strWID.type = WID_BIN;
-	strWID.size = sizeof(struct set_multicast) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
+	strWID.size = sizeof(struct set_multicast) + ((strHostIfSetMulti->cnt) * ETH_ALEN);
 	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
 	if (strWID.val == NULL)
 		goto ERRORHANDLER;
@@ -2801,13 +2801,13 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
 	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 24) & 0xFF);
 
-	*pu8CurrByte++ = (strHostIfSetMulti->u32count & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->u32count >> 8) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->u32count >> 16) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->u32count >> 24) & 0xFF);
+	*pu8CurrByte++ = (strHostIfSetMulti->cnt & 0xFF);
+	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 8) & 0xFF);
+	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 16) & 0xFF);
+	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 24) & 0xFF);
 
-	if ((strHostIfSetMulti->u32count) > 0)
-		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
+	if ((strHostIfSetMulti->cnt) > 0)
+		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
@@ -4913,7 +4913,7 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
 	msg.drv = hif_drv;
 
 	pstrMulticastFilterParam->enabled = bIsEnabled;
-	pstrMulticastFilterParam->u32count = u32count;
+	pstrMulticastFilterParam->cnt = u32count;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
-- 
1.9.1

