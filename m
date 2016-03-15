Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:41737 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbcCOJvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 05:51:04 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/7] staging: wilc1000: removes function 'init_tcp_tracking()'
Date: Tue, 15 Mar 2016 18:48:08 +0900
Message-ID: <1458035294-13001-1-git-send-email-leo.kim@atmel.com> (sfid-20160315_105109_399044_64FF6D70)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function 'init_tcp_tracking()'.
The function is an unnecessary return.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index fd938fb..ca9054a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -150,11 +150,6 @@ static u32 pending_base;
 static u32 tcp_session;
 static u32 pending_acks;
 
-static inline int init_tcp_tracking(void)
-{
-	return 0;
-}
-
 static inline int add_tcp_session(u32 src_prt, u32 dst_prt, u32 seq)
 {
 	if (tcp_session < 2 * MAX_TCP_SESSION) {
@@ -1440,7 +1435,6 @@ int wilc_wlan_init(struct net_device *dev)
 		ret = -EIO;
 		goto _fail_;
 	}
-	init_tcp_tracking();
 
 	return 1;
 
-- 
1.9.1

