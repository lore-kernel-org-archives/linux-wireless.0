Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:32552 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbbJHBtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 21:49:45 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/14] staging: wilc1000: remove typedef from tstrWILC_UsrConnReq
Date: Thu, 8 Oct 2015 10:49:09 +0900
Message-ID: <1444268961-7551-2-git-send-email-tony.cho@atmel.com> (sfid-20151008_034948_846049_344E13B2)
In-Reply-To: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
References: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrWILC_UsrConnReq with the
related comments and renames it to user_conn_req.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 0b3b4dc..73d9509 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -236,7 +236,7 @@ struct user_scan_req {
 	tstrFoundNetworkInfo astrFoundNetworkInfo[MAX_NUM_SCANNED_NETWORKS];
 };
 
-typedef struct {
+struct user_conn_req {
 	u8 *pu8bssid;
 	u8 *pu8ssid;
 	u8 u8security;
@@ -249,7 +249,7 @@ typedef struct {
 	bool IsHTCapable;
 	/* User specific parameter to be delivered through the Connect User Callback function */
 	void *u32UserConnectPvoid;
-} tstrWILC_UsrConnReq;
+};
 
 struct drv_handler {
 	u32 u32Address;
@@ -305,9 +305,7 @@ enum p2p_listen_state {
 
 struct host_if_drv {
 	struct user_scan_req strWILC_UsrScanReq;
-
-	/* Connect User structure */
-	tstrWILC_UsrConnReq strWILC_UsrConnReq;
+	struct user_conn_req strWILC_UsrConnReq;
 
 	/*Remain on channel struvture*/
 	struct remain_ch strHostIfRemainOnChan;
-- 
1.9.1

