Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45571 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbbIRJOI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:14:08 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 21/34] staging: wilc1000: remove typedef from the struct tstrHostIFSetIPAddr
Date: Fri, 18 Sep 2015 18:11:23 +0900
Message-ID: <1442567496-29331-21-git-send-email-tony.cho@atmel.com> (sfid-20150918_111414_468227_233EC6C2)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIFSetIPAddr and
renames it to set_ip_addr in order to comply with the Linux coding
style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8fc9186..8b995c3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -376,7 +376,7 @@ struct power_mgmt_param {
 };
 
 /*!
- *  @struct             tstrHostIFSetIPAddr
+ *  @struct             set_ip_addr
  *  @brief		set IP Address message body
  *  @details
  *  @todo
@@ -385,11 +385,10 @@ struct power_mgmt_param {
  *  @date		30 August 2013
  *  @version		1.0 Description
  */
-
-typedef struct {
+struct set_ip_addr {
 	u8 *au8IPAddr;
 	u8 idx;
-} tstrHostIFSetIPAddr;
+};
 
 /*!
  *  @struct     sta_inactive_t
@@ -433,7 +432,7 @@ union message_body {
 	struct timer_cb strTimerCb;                                                 /*!< Timer callback message body */
 	struct power_mgmt_param strPowerMgmtparam;     /*!< Power Management message body */
 	struct sta_inactive_t strHostIfStaInactiveT;
-	tstrHostIFSetIPAddr strHostIfSetIP;
+	struct set_ip_addr strHostIfSetIP;
 	tstrHostIfSetDrvHandler strHostIfSetDrvHandler;
 	tstrHostIFSetMulti strHostIfSetMulti;
 	tstrHostIfSetOperationMode strHostIfSetOperationMode;
-- 
1.9.1

