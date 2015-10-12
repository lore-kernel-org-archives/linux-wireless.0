Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12755 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbbJLH6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:58:25 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 17/41] staging: wilc1000: remove typedef from tstrWILC_UsrScanReq
Date: Mon, 12 Oct 2015 16:55:51 +0900
Message-ID: <1444636575-2486-17-git-send-email-tony.cho@atmel.com> (sfid-20151012_095829_358314_53659FDD)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrWILC_UsrScanReq with
related comments and renames it to user_scan_req.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 3ab9220..b718598 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -225,7 +225,7 @@ struct hidden_network {
 	u8 u8ssidnum;
 };
 
-typedef struct {
+struct user_scan_req {
 	/* Scan user call back function */
 	wilc_scan_result pfUserScanResult;
 
@@ -234,7 +234,7 @@ typedef struct {
 
 	u32 u32RcvdChCount;
 	tstrFoundNetworkInfo astrFoundNetworkInfo[MAX_NUM_SCANNED_NETWORKS];
-} tstrWILC_UsrScanReq;
+};
 
 typedef struct {
 	u8 *pu8bssid;
@@ -304,8 +304,7 @@ enum p2p_listen_state {
 };
 
 struct host_if_drv {
-	/* Scan user structure */
-	tstrWILC_UsrScanReq strWILC_UsrScanReq;
+	struct user_scan_req strWILC_UsrScanReq;
 
 	/* Connect User structure */
 	tstrWILC_UsrConnReq strWILC_UsrConnReq;
-- 
1.9.1

