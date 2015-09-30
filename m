Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14031 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbbI3Jsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:48:35 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/32] staging: wilc1000: rename struct set_channel
Date: Wed, 30 Sep 2015 18:44:27 +0900
Message-ID: <1443606289-25407-10-git-send-email-tony.cho@atmel.com> (sfid-20150930_114837_599400_EC8473A6)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames struct set_channel to channel_attr to keep the naming
convention such as scan_attr and connect_attr.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e715f54..e66118a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -218,7 +218,7 @@ struct rcvd_async_info {
 };
 
 /*!
- *  @struct             set_channel
+ *  @struct		channel_attr
  *  @brief		Set Channel  message body
  *  @details
  *  @todo
@@ -227,7 +227,7 @@ struct rcvd_async_info {
  *  @date		25 March 2012
  *  @version		1.0
  */
-struct set_channel {
+struct channel_attr {
 	u8 u8SetChan;
 };
 
@@ -406,7 +406,7 @@ union message_body {
 	struct rcvd_async_info async_info;
 	struct key_attr key_info;
 	struct cfg_param_attr cfg_info;
-	struct set_channel strHostIFSetChan;
+	struct channel_attr strHostIFSetChan;
 	struct set_beacon strHostIFSetBeacon;
 	struct del_beacon strHostIFDelBeacon;
 	struct add_sta_param strAddStaParam;
@@ -599,14 +599,14 @@ static tstrWILC_WFIDrv *get_handler_from_id(int id)
 /**
  *  @brief Handle_SetChannel
  *  @details    Sending config packet to firmware to set channel
- *  @param[in]   struct set_channel *pstrHostIFSetChan
+ *  @param[in]   struct channel_attr *pstrHostIFSetChan
  *  @return     Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
 static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler,
-			     struct set_channel *pstrHostIFSetChan)
+			     struct channel_attr *pstrHostIFSetChan)
 {
 
 	s32 s32Error = 0;
-- 
1.9.1

