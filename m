Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15565 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbcDAIrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 04:47:24 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/7] staging: wilc1000: removes duplicate del_timer_sync
Date: Fri, 1 Apr 2016 17:44:14 +0900
Message-ID: <1459500259-27873-2-git-send-email-leo.kim@atmel.com> (sfid-20160401_104727_986365_47C30260)
In-Reply-To: <1459500259-27873-1-git-send-email-leo.kim@atmel.com>
References: <1459500259-27873-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes del_timer_sync(&periodic_rssi) which was
already performed this action.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 12f1630..936c04a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3498,7 +3498,6 @@ int wilc_deinit(struct wilc_vif *vif)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	if (clients_count == 1)	{
-		del_timer_sync(&periodic_rssi);
 		msg.id = HOST_IF_MSG_EXIT;
 		msg.vif = vif;
 
-- 
1.9.1

