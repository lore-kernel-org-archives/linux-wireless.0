Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14180 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbbI3Jt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:49:27 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 18/32] staging: wilc1000: remove struct timer_cb
Date: Wed, 30 Sep 2015 18:44:35 +0900
Message-ID: <1443606289-25407-18-git-send-email-tony.cho@atmel.com> (sfid-20150930_121656_007460_88E4F8D5)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes struct timer_cb which is not used.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index da8e589..7d51122 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -315,20 +315,6 @@ struct del_sta {
 };
 
 /*!
- *  @struct             timer_cb
- *  @brief		Timer callback message body
- *  @details
- *  @todo
- *  @sa
- *  @author		Mostafa Abu Bakr
- *  @date		25 March 2012
- *  @version		1.0
- */
-struct timer_cb {
-	void *pvUsrArg;                 /*!< Private data passed at timer start */
-};
-
-/*!
  *  @struct     power_mgmt_param
  *  @brief		Power management message body
  *  @details
@@ -395,7 +381,6 @@ union message_body {
 	struct add_sta_param add_sta_info;
 	struct del_sta del_sta_info;
 	struct add_sta_param edit_sta_info;
-	struct timer_cb strTimerCb;
 	struct power_mgmt_param strPowerMgmtparam;
 	struct sta_inactive_t strHostIfStaInactiveT;
 	struct set_ip_addr strHostIfSetIP;
-- 
1.9.1

