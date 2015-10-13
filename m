Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2948 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbbJMKxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:53:00 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 22/54] staging: wilc1000: fix "ERROR: do not initialise globals to 0 or NULL"
Date: Tue, 13 Oct 2015 19:49:47 +0900
Message-ID: <1444733419-17679-22-git-send-email-tony.cho@atmel.com> (sfid-20151013_125303_836818_553FEC09)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checkpatch.pl error to host_interface.c.
 - ERROR: do not initialise globals to 0 or NULL

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 506c73f..0296bd9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -239,7 +239,7 @@ enum scan_conn_timer {
 static struct host_if_drv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
 struct host_if_drv *terminated_handle;
 struct host_if_drv *gWFiDrvHandle;
-bool g_obtainingIP = false;
+bool g_obtainingIP;
 u8 P2P_LISTEN_STATE;
 static struct task_struct *HostIFthreadHandler;
 static WILC_MsgQueueHandle gMsgQHostIF;
@@ -256,7 +256,7 @@ u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
 static u8 gapu8RcvdAssocResp[MAX_ASSOC_RESP_FRAME_SIZE];
 
-bool gbScanWhileConnected = false;
+bool gbScanWhileConnected;
 
 static s8 gs8Rssi;
 static s8 gs8lnkspd;
-- 
1.9.1

