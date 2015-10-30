Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:56757 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030650AbbJ3Jph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 05:45:37 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 12/17] staging: wilc1000: chip_sleep_manually: add argument struct net_device
Date: Fri, 30 Oct 2015 18:47:18 +0900
Message-ID: <1446198443-6623-12-git-send-email-glen.lee@atmel.com> (sfid-20151030_104655_212692_210672EC)
In-Reply-To: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
References: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add new argument struct net_device and pass dev to the function
as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.c      | 2 +-
 drivers/staging/wilc1000/wilc_wlan.h      | 1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3a4fdc0..1263b5e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -271,7 +271,6 @@ static struct host_if_drv *join_req_drv;
 
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 
-extern void chip_sleep_manually(u32 u32SleepTime);
 extern int linux_wlan_get_num_conn_ifcs(void);
 
 static int add_handler_in_list(struct host_if_drv *handler)
@@ -2993,7 +2992,8 @@ static int hostIFthread(void *pvArg)
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
 			if (!linux_wlan_get_num_conn_ifcs())
-				chip_sleep_manually(INFINITE_SLEEP_TIME);
+				chip_sleep_manually(hif_drv->priv->dev,
+						    INFINITE_SLEEP_TIME);
 
 			Handle_ScanDone(msg.drv, SCAN_EVENT_DONE);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index e8afa6b..93fae34 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -810,7 +810,7 @@ static inline void chip_wakeup(void)
 	genuChipPSstate = CHIP_WAKEDUP;
 }
 #endif
-void chip_sleep_manually(u32 u32SleepTime)
+void chip_sleep_manually(struct net_device *dev, u32 u32SleepTime)
 {
 	if (genuChipPSstate != CHIP_WAKEDUP) {
 		/* chip is already sleeping. Do nothing */
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 194c24c..c948c25 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -311,4 +311,5 @@ int wilc_wlan_cfg_get(struct net_device *dev, int start, u32 wid, int commit,
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func);
+void chip_sleep_manually(struct net_device *dev, u32 u32SleepTime);
 #endif
-- 
1.9.1

