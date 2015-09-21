Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21070 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbbIUDR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:17:56 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 05/34] staging: wilc1000 remove typedef from the union
Date: Mon, 21 Sep 2015 12:16:34 +0900
Message-ID: <1442805423-3711-6-git-send-email-tony.cho@atmel.com> (sfid-20150921_051758_766824_C53BF25D)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
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
index d2b0ea6..c4a8481 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -408,7 +408,7 @@ typedef struct {
 } tstrHostIfStaInactiveT;
 /**/
 /*!
- *  @union              tuniHostIFmsgBody
+ *  @union              message_body
  *  @brief		Message body for the Host Interface message_q
  *  @details
  *  @todo
@@ -417,7 +417,7 @@ typedef struct {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef union _tuniHostIFmsgBody {
+union message_body {
 	tstrHostIFscanAttr strHostIFscanAttr;                           /*!< Host IF Scan Request Attributes message body */
 	tstrHostIFconnectAttr strHostIFconnectAttr;     /*!< Host IF Connect Request Attributes message body */
 	tstrRcvdNetworkInfo strRcvdNetworkInfo;                 /*!< Received Asynchronous Network Info message body */
@@ -446,7 +446,7 @@ typedef union _tuniHostIFmsgBody {
 	tstrHostIfRegisterFrame strHostIfRegisterFrame;
 	char *pUserData;
 	tstrHostIFDelAllSta strHostIFDelAllSta;
-} tuniHostIFmsgBody;
+};
 
 /*!
  *  @struct             struct host_if_msg
@@ -460,7 +460,7 @@ typedef union _tuniHostIFmsgBody {
  */
 struct host_if_msg {
 	u16 id;                                           /*!< Message ID */
-	tuniHostIFmsgBody uniHostIFmsgBody;             /*!< Message body */
+	union message_body uniHostIFmsgBody;             /*!< Message body */
 	tstrWILC_WFIDrv *drvHandler;
 };
 
-- 
1.9.1

