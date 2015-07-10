Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44330 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbbGJF4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 01:56:39 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>, <chris.park@atmel.com>
CC: <johnny.kim@atmel.com>, <rachel.kim@atmel.com>,
	<tony.cho@atmel.com>, <Nicolas.FERRE@atmel.com>,
	<dean.lee@atmel.com>, <austin.shin@atmel.com>
Subject: [PATCH 3/3] staging: wilc1000: wilc_wlan_cfg_set(): replace integer with void pointer
Date: Fri, 10 Jul 2015 14:55:57 +0900
Message-ID: <1436507759-4546-4-git-send-email-johnny.kim@atmel.com> (sfid-20150710_075642_086051_BB6A16F8)
In-Reply-To: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com>
References: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Last argument of wilc_wlan_cfg_set function is actually structure's address.
This should be changed to be compatible with 64bit machine.
Because wilc_wlan_cfg_set function is mapped by function pointer later,
wilc_wlan_oup_t.wlan_cfg_set should be changed together.

tstrWILC_WFIDrv structure is defined after wilc_wlan_oup_t.wlan_cfg_set
is defined. So, this patch changes the argument to void type pointer.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 drivers/staging/wilc1000/linux_wlan.c       | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c        | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 141d7b4..5c1096d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -2117,7 +2117,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
 			if (!gpstrWlanOps->wlan_cfg_set(!counter,
 							pstrWIDs[counter].u16WIDid, pstrWIDs[counter].ps8WidVal,
 							pstrWIDs[counter].s32ValueSize,
-							(counter == u32WIDsCount - 1), drvHandler)) {
+							(counter == u32WIDsCount - 1), (void *)drvHandler)) {
 				ret = -1;
 				printk("[Sendconfigpkt]Set Timed out\n");
 				break;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 5a794df..eadc500 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1340,7 +1340,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 		goto _fail_;
 
 	c_val[0] = 1; /* Enable N with immediate block ack. */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, (u32)pstrWFIDrv))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, (void *)pstrWFIDrv))
 		goto _fail_;
 
 	return 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c0a8063..f9dbd40 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1899,7 +1899,7 @@ static int wilc_wlan_cfg_commit(int type, tstrWILC_WFIDrv *drvHandler)
 	return 0;
 }
 
-static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t buffer_size, int commit, uint32_t drvHandler)
+static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t buffer_size, int commit, void *drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	uint32_t offset;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 8c293ab..9d42bd8 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -193,7 +193,7 @@ typedef struct {
 	void (*wlan_handle_rx_que)(void);
 	void (*wlan_handle_rx_isr)(void);
 	void (*wlan_cleanup)(void);
-	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, uint32_t);
+	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, void *);
 	int (*wlan_cfg_get)(int, uint32_t, int, void *);
 	int (*wlan_cfg_get_value)(uint32_t, uint8_t *, uint32_t);
 	/*Bug3959: transmitting mgmt frames received from host*/
-- 
1.9.1

