Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12865 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbbJLH6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:58:45 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 20/41] staging: wilc1000: remove typedef from tstrFoundNetworkInfo
Date: Mon, 12 Oct 2015 16:55:54 +0900
Message-ID: <1444636575-2486-20-git-send-email-tony.cho@atmel.com> (sfid-20151012_095857_131443_D34A908E)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
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
index 0460af2..0f5fcca 100644
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

