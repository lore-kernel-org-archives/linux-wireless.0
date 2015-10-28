Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41581 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbbJ1G6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:58:13 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/80] staging: wilc1000: host_interface: removes unused functions
Date: Wed, 28 Oct 2015 15:59:26 +0900
Message-ID: <1446015640-29398-6-git-send-email-glen.lee@atmel.com> (sfid-20151028_075817_423891_FA4C1F17)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes unused functions at host_interface files.
 - host_int_send_join_leave_info_to_host
 - host_int_send_network_info_to_host

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 11 ----------
 drivers/staging/wilc1000/host_interface.h | 34 -------------------------------
 2 files changed, 45 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c3826eb..7f29abd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4037,11 +4037,6 @@ s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
 	return result;
 }
 
-void host_int_send_join_leave_info_to_host
-	(u16 assocId, u8 *stationAddr, bool joining)
-{
-}
-
 static void GetPeriodicRSSI(unsigned long arg)
 {
 	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
@@ -4070,12 +4065,6 @@ static void GetPeriodicRSSI(unsigned long arg)
 	mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 }
 
-
-void host_int_send_network_info_to_host
-	(u8 *macStartAddress, u16 u16RxFrameLen, s8 s8Rssi)
-{
-}
-
 s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 {
 	s32 result = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 0fd2eda..d4fb1d4 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -869,40 +869,6 @@ s32 hif_get_cfg(struct host_if_drv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
 /*							Notification Functions							 */
 /*****************************************************************************/
 /**
- *  @brief              notifies host with join and leave requests
- *  @details    This function prepares an Information frame having the
- *                              information about a joining/leaving station.
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	6 byte Sta Adress
- *                              Join or leave flag:
- *                              Join = 1,
- *                              Leave =0
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-void host_int_send_join_leave_info_to_host
-	(u16 assocId, u8 *stationAddr, bool joining);
-
-/**
- *  @brief              notifies host with stations found in scan
- *  @details    sends the beacon/probe response from scan
- *  @param[in,out] handle to the wifi driver,
- *  @param[in]	Sta Address,
- *                              Frame length,
- *                              Rssi of the Station found
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-void host_int_send_network_info_to_host
-	(u8 *macStartAddress, u16 u16RxFrameLen, s8 s8Rssi);
-
-/**
  *  @brief              host interface initialization function
  *  @details
  *  @param[in,out] handle to the wifi driver,
-- 
1.9.1

