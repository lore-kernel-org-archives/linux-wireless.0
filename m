Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21254 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbbIUDS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:18:58 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 14/34] staging: wilc1000: remove typedef from the struct tstrHostIFGetChan
Date: Mon, 21 Sep 2015 12:16:43 +0900
Message-ID: <1442805423-3711-15-git-send-email-tony.cho@atmel.com> (sfid-20150921_054654_608918_8771F5EE)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIFGetChan and renames
it to get_channel in order to comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8058f38..2a971b24b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -229,7 +229,7 @@ struct set_channel {
 };
 
 /*!
- *  @struct             tstrHostIFSetChan
+ *  @struct             get_channel
  *  @brief		Get Channel  message body
  *  @details
  *  @todo
@@ -238,9 +238,9 @@ struct set_channel {
  *  @date		01 Jule 2012
  *  @version		1.0
  */
-typedef struct _tstrHostIFGetChan {
+struct get_channel {
 	u8 u8GetChan;
-} tstrHostIFGetChan;
+};
 
 /*bug3819: Add Scan acomplete notification to host*/
 /*!
@@ -423,7 +423,7 @@ union message_body {
 	struct key_attr strHostIFkeyAttr;                             /*!<>*/
 	struct cfg_param_attr strHostIFCfgParamAttr;            /*! <CFG Parameter message Body> */
 	struct set_channel strHostIFSetChan;
-	tstrHostIFGetChan strHostIFGetChan;
+	struct get_channel strHostIFGetChan;
 	tstrHostIFSetBeacon strHostIFSetBeacon;                 /*!< Set beacon message body */
 	tstrHostIFDelBeacon strHostIFDelBeacon;                 /*!< Del beacon message body */
 	tstrWILC_AddStaParam strAddStaParam;                    /*!< Add station message body */
-- 
1.9.1

