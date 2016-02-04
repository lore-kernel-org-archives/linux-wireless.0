Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:9935 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965823AbcBDJZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:25:21 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 24/70] staging: wilc1000: wilc_parse_network_info(): renames function variables
Date: Thu, 4 Feb 2016 18:15:41 +0900
Message-ID: <1454577387-509-25-git-send-email-glen.lee@atmel.com> (sfid-20160204_103015_164476_3F249B0A)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames to avoid camelcase, changes follow are:
 - pu8MsgBuffer to msg_buffer
 - ppstrNetworkInfo to ret_network_info

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 16 ++++++++--------
 drivers/staging/wilc1000/coreconfigurator.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 6f17e2b..43f0a29 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -270,7 +270,7 @@ static u8 get_current_channel_802_11n(u8 *pu8msa, u16 rx_len)
 	return 0;
 }
 
-s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
+s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
 {
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 	u8 u8MsgType = 0;
@@ -281,18 +281,18 @@ s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo
 	u16 u16WidLen  = 0;
 	u8  *pu8WidVal = NULL;
 
-	u8MsgType = pu8MsgBuffer[0];
+	u8MsgType = msg_buffer[0];
 
 	if ('N' != u8MsgType) {
 		PRINT_ER("Received Message format incorrect.\n");
 		return -EFAULT;
 	}
 
-	u8MsgID = pu8MsgBuffer[1];
-	u16MsgLen = MAKE_WORD16(pu8MsgBuffer[2], pu8MsgBuffer[3]);
-	u16WidID = MAKE_WORD16(pu8MsgBuffer[4], pu8MsgBuffer[5]);
-	u16WidLen = MAKE_WORD16(pu8MsgBuffer[6], pu8MsgBuffer[7]);
-	pu8WidVal  = &pu8MsgBuffer[8];
+	u8MsgID = msg_buffer[1];
+	u16MsgLen = MAKE_WORD16(msg_buffer[2], msg_buffer[3]);
+	u16WidID = MAKE_WORD16(msg_buffer[4], msg_buffer[5]);
+	u16WidLen = MAKE_WORD16(msg_buffer[6], msg_buffer[7]);
+	pu8WidVal = &msg_buffer[8];
 
 	{
 		u8  *pu8msa = NULL;
@@ -350,7 +350,7 @@ s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo
 
 	}
 
-	*ppstrNetworkInfo = pstrNetworkInfo;
+	*ret_network_info = pstrNetworkInfo;
 
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index ee107ac..aec0779 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -120,7 +120,7 @@ typedef struct {
 	size_t ie_len;
 } tstrDisconnectNotifInfo;
 
-s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
+s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info);
 s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo);
 
 s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
-- 
1.9.1

