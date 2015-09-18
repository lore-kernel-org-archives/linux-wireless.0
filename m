Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45444 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbbIRJNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:13:48 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 18/34] staging: wilc1000: remove typedef from the struct tstrTimerCb
Date: Fri, 18 Sep 2015 18:11:20 +0900
Message-ID: <1442567496-29331-18-git-send-email-tony.cho@atmel.com> (sfid-20150918_111357_857451_58F367EF)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the tstrTimerCb and renames it to
timer_cb in order to comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0308421..5f546e5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -346,7 +346,7 @@ typedef struct {
 } tstrHostIFDelSta;
 
 /*!
- *  @struct             tstrTimerCb
+ *  @struct             timer_cb
  *  @brief		Timer callback message body
  *  @details
  *  @todo
@@ -355,9 +355,9 @@ typedef struct {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef struct _tstrTimerCb {
+struct timer_cb {
 	void *pvUsrArg;                 /*!< Private data passed at timer start */
-} tstrTimerCb;
+};
 
 /*!
  *  @struct     tstrHostIfPowerMgmtParam
@@ -431,7 +431,7 @@ union message_body {
 	tstrHostIFDelSta strDelStaParam;                                /*!< Del Station message body */
 	struct add_sta_param strEditStaParam;                           /*!< Edit station message body */
 	/* tstrScanComplete		strScanComplete;		/ *Received Async. Scan Complete message body* / */
-	tstrTimerCb strTimerCb;                                                 /*!< Timer callback message body */
+	struct timer_cb strTimerCb;                                                 /*!< Timer callback message body */
 	tstrHostIfPowerMgmtParam strPowerMgmtparam;     /*!< Power Management message body */
 	tstrHostIfStaInactiveT strHostIfStaInactiveT;
 	tstrHostIFSetIPAddr strHostIfSetIP;
-- 
1.9.1

