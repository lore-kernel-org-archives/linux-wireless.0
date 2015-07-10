Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44306 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbbGJF4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 01:56:32 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>, <chris.park@atmel.com>
CC: <johnny.kim@atmel.com>, <rachel.kim@atmel.com>,
	<tony.cho@atmel.com>, <Nicolas.FERRE@atmel.com>,
	<dean.lee@atmel.com>, <austin.shin@atmel.com>
Subject: [PATCH 2/3] staging: wilc1000: wilc_wlan_cfg_get(): replace integer with void pointer
Date: Fri, 10 Jul 2015 14:55:56 +0900
Message-ID: <1436507759-4546-3-git-send-email-johnny.kim@atmel.com> (sfid-20150710_075635_155186_FBBB6A2D)
In-Reply-To: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com>
References: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Last argument of wilc_wlan_cfg_get function is actually structure's address.
This should be changed to be compatible with 64bit machine.
Because wilc_wlan_cfg_get function is mapped by function pointer later,
wilc_wlan_oup_t.wlan_cfg_get should be changed together.

tstrWILC_WFIDrv structure is defined after wilc_wlan_oup_t.wlan_cfg_get
is defined. So, this patch changes the argument to void type pointer.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c        | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index b069614..141d7b4 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -2094,7 +2094,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
 				   (counter == u32WIDsCount - 1));
 			if (!gpstrWlanOps->wlan_cfg_get(!counter,
 							pstrWIDs[counter].u16WIDid,
-							(counter == u32WIDsCount - 1), drvHandler)) {
+							(counter == u32WIDsCount - 1), (void *)drvHandler)) {
 				ret = -1;
 				printk("[Sendconfigpkt]Get Timed out\n");
 				break;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d32e45e..c0a8063 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1938,7 +1938,7 @@ static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t
 
 	return ret_size;
 }
-static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, uint32_t drvHandler)
+static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, void* drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	uint32_t offset;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 8735a6a..8c293ab 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -194,7 +194,7 @@ typedef struct {
 	void (*wlan_handle_rx_isr)(void);
 	void (*wlan_cleanup)(void);
 	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, uint32_t);
-	int (*wlan_cfg_get)(int, uint32_t, int, uint32_t);
+	int (*wlan_cfg_get)(int, uint32_t, int, void *);
 	int (*wlan_cfg_get_value)(uint32_t, uint8_t *, uint32_t);
 	/*Bug3959: transmitting mgmt frames received from host*/
 	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
-- 
1.9.1

