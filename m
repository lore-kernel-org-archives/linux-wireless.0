Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:4749 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbbJMLCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 07:02:40 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 48/54] staging: wilc1000: rename au8MacAddr of struct del_sta
Date: Tue, 13 Oct 2015 20:02:06 +0900
Message-ID: <1444734132-17858-3-git-send-email-tony.cho@atmel.com> (sfid-20151013_130243_231456_99B69E9F)
In-Reply-To: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
References: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames au8MacAddr of struct del_sta to mac_addr to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9cd42f7..4f7ebdc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -150,7 +150,7 @@ struct del_all_sta {
 };
 
 struct del_sta {
-	u8 au8MacAddr[ETH_ALEN];
+	u8 mac_addr[ETH_ALEN];
 };
 
 struct power_mgmt_param {
@@ -2544,7 +2544,7 @@ static void Handle_DelStation(struct host_if_drv *hif_drv,
 
 	pu8CurrByte = strWID.val;
 
-	memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
+	memcpy(pu8CurrByte, pstrDelStaParam->mac_addr, ETH_ALEN);
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
@@ -4758,9 +4758,9 @@ s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 	msg.drv = hif_drv;
 
 	if (pu8MacAddr == NULL)
-		memset(pstrDelStationMsg->au8MacAddr, 255, ETH_ALEN);
+		memset(pstrDelStationMsg->mac_addr, 255, ETH_ALEN);
 	else
-		memcpy(pstrDelStationMsg->au8MacAddr, pu8MacAddr, ETH_ALEN);
+		memcpy(pstrDelStationMsg->mac_addr, pu8MacAddr, ETH_ALEN);
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
-- 
1.9.1

