Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14161 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbbI3JtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:49:20 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 17/32] staging: wilc1000: rename strEditStaParam
Date: Wed, 30 Sep 2015 18:44:34 +0900
Message-ID: <1443606289-25407-17-git-send-email-tony.cho@atmel.com> (sfid-20150930_121655_192504_87277FEF)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strEditStaParam to edit_sta_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 94559bd..da8e589 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -394,7 +394,7 @@ union message_body {
 	struct beacon_attr beacon_info;
 	struct add_sta_param add_sta_info;
 	struct del_sta del_sta_info;
-	struct add_sta_param strEditStaParam;
+	struct add_sta_param edit_sta_info;
 	struct timer_cb strTimerCb;
 	struct power_mgmt_param strPowerMgmtparam;
 	struct sta_inactive_t strHostIfStaInactiveT;
@@ -4150,7 +4150,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_EDIT_STATION:
-			Handle_EditStation(msg.drvHandler, &msg.body.strEditStaParam);
+			Handle_EditStation(msg.drvHandler, &msg.body.edit_sta_info);
 			break;
 
 		case HOST_IF_MSG_GET_INACTIVETIME:
-- 
1.9.1

