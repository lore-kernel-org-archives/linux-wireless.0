Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45022 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbbIRJMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:12:21 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/34] staging: wilc1000 remove typedef from the union
Date: Fri, 18 Sep 2015 18:11:07 +0900
Message-ID: <1442567496-29331-5-git-send-email-tony.cho@atmel.com> (sfid-20150918_111225_815352_3D6C6AE9)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch gets rid of typedef from the union and renames tuniHostIFmsgBody
with simply message_body because the Linux coding style does not recommend
camelcase notation and typedef for structure, enmu and also union.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d215b12..6cb35aa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -409,7 +409,7 @@ typedef struct {
 } tstrHostIfStaInactiveT;
 /**/
 /*!
- *  @union              tuniHostIFmsgBody
+ *  @union              message_body
  *  @brief		Message body for the Host Interface message_q
  *  @details
  *  @todo
@@ -418,7 +418,7 @@ typedef struct {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef union _tuniHostIFmsgBody {
+union message_body {
 	tstrHostIFscanAttr strHostIFscanAttr;                           /*!< Host IF Scan Request Attributes message body */
 	tstrHostIFconnectAttr strHostIFconnectAttr;     /*!< Host IF Connect Request Attributes message body */
 	tstrRcvdNetworkInfo strRcvdNetworkInfo;                 /*!< Received Asynchronous Network Info message body */
@@ -447,7 +447,7 @@ typedef union _tuniHostIFmsgBody {
 	tstrHostIfRegisterFrame strHostIfRegisterFrame;
 	char *pUserData;
 	tstrHostIFDelAllSta strHostIFDelAllSta;
-} tuniHostIFmsgBody;
+};
 
 /*!
  *  @struct             struct host_if_msg
@@ -461,7 +461,7 @@ typedef union _tuniHostIFmsgBody {
  */
 struct host_if_msg {
 	u16 id;                                           /*!< Message ID */
-	tuniHostIFmsgBody uniHostIFmsgBody;             /*!< Message body */
+	union message_body uniHostIFmsgBody;             /*!< Message body */
 	tstrWILC_WFIDrv *drvHandler;
 };
 
-- 
1.9.1

