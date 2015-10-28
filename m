Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41702 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbbJ1G6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:58:49 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/80] staging: wilc1000: rename u8MacAddress of struct get_mac_addr
Date: Wed, 28 Oct 2015 15:59:32 +0900
Message-ID: <1446015640-29398-12-git-send-email-glen.lee@atmel.com> (sfid-20151028_081658_525624_BBD4B953)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8MacAddress of struct get_mac_addr to mac_addr
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2d12672..ab1617f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -503,7 +503,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 
 	wid.id = (u16)WID_MAC_ADDR;
 	wid.type = WID_STR;
-	wid.val = pstrHostIfGetMacAddress->u8MacAddress;
+	wid.val = pstrHostIfGetMacAddress->mac_addr;
 	wid.size = ETH_ALEN;
 
 	result = send_config_pkt(GET_CFG, &wid, 1,
@@ -3377,7 +3377,7 @@ s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_MAC_ADDRESS;
-	msg.body.get_mac_info.u8MacAddress = pu8MacAddress;
+	msg.body.get_mac_info.mac_addr = pu8MacAddress;
 	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c2f21a9..7fb1551 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -252,7 +252,7 @@ struct set_mac_addr {
 };
 
 struct get_mac_addr {
-	u8 *u8MacAddress;
+	u8 *mac_addr;
 };
 
 struct ba_session_info {
-- 
1.9.1

