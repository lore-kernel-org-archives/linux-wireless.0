Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:32596 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbbJHBt7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 21:49:59 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/14] staging: wilc1000: remove typedef from tstrFoundNetworkInfo
Date: Thu, 8 Oct 2015 10:49:11 +0900
Message-ID: <1444268961-7551-4-git-send-email-tony.cho@atmel.com> (sfid-20151008_035002_792520_E194FDC4)
In-Reply-To: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
References: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrFoundNetworkInfo and
rename it to found_net_info.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5026500..408bd48 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -155,10 +155,10 @@ typedef enum {
 	HT_ENABLE		= BIT(18),
 } tenuCfgParam;
 
-typedef struct {
+struct found_net_info {
 	u8 au8bssid[6];
 	s8 s8rssi;
-} tstrFoundNetworkInfo;
+};
 
 typedef enum {SCAN_EVENT_NETWORK_FOUND  = 0,
 	      SCAN_EVENT_DONE = 1,
@@ -232,7 +232,7 @@ struct user_scan_req {
 	void *u32UserScanPvoid;
 
 	u32 u32RcvdChCount;
-	tstrFoundNetworkInfo astrFoundNetworkInfo[MAX_NUM_SCANNED_NETWORKS];
+	struct found_net_info astrFoundNetworkInfo[MAX_NUM_SCANNED_NETWORKS];
 };
 
 struct user_conn_req {
-- 
1.9.1

