Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45978 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbbIRJPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:15:22 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 32/34] staging: wilc1000: remove unnecessary global variable
Date: Fri, 18 Sep 2015 18:11:34 +0900
Message-ID: <1442567496-29331-32-git-send-email-tony.cho@atmel.com> (sfid-20150918_111536_128683_4486C9EA)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The global variable msgQ_created is removed because it is not necessary.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5d72246..1be1a9c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6394,7 +6394,6 @@ void host_int_send_network_info_to_host
  *  @version		1.0
  */
 static u32 u32Intialized;
-static u32 msgQ_created;
 static u32 clients_count;
 
 s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
@@ -6468,7 +6467,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 			PRINT_ER("Failed to creat MQ\n");
 			goto _fail_;
 		}
-		msgQ_created = 1;
 		HostIFthreadHandler = kthread_run(hostIFthread, NULL, "WILC_kthread");
 		if (IS_ERR(HostIFthreadHandler)) {
 			PRINT_ER("Failed to creat Thread\n");
@@ -6637,7 +6635,6 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 		down(&hSemHostIFthrdEnd);
 
 		wilc_mq_destroy(&gMsgQHostIF);
-		msgQ_created = 0;
 	}
 
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
-- 
1.9.1

