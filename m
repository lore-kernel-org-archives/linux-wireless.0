Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44280 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbbGaHj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:39:58 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/28] staging: wilc1000: change drvHandler type in wlan_cfg_set
Date: Fri, 31 Jul 2015 16:38:17 +0900
Message-ID: <1438328316-30197-10-git-send-email-tony.cho@atmel.com> (sfid-20150731_094000_525989_42747674)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch changes drvHandler of uint32_t type with WILC_WFIDrvHandle type in
wlan_cfg_set and wilc_wlan_cfg_set.

The type of drvHandler which wlan_cfg_set take as argument was changed to WILC_WFIDrvHandle.
So the type needs to be changed to match parameter type.

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c    | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 273073f..d5fc54b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1899,7 +1899,7 @@ static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
 	return 0;
 }
 
-static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t buffer_size, int commit, uint32_t drvHandler)
+static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t buffer_size, int commit, WILC_WFIDrvHandle drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	uint32_t offset;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 6d2d588..d9d592aa 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -197,7 +197,7 @@ typedef struct {
 	void (*wlan_handle_rx_que)(void);
 	void (*wlan_handle_rx_isr)(void);
 	void (*wlan_cleanup)(void);
-	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, uint32_t);
+	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, WILC_WFIDrvHandle);
 	int (*wlan_cfg_get)(int, uint32_t, int, WILC_WFIDrvHandle);
 	int (*wlan_cfg_get_value)(uint32_t, uint8_t *, uint32_t);
 	/*Bug3959: transmitting mgmt frames received from host*/
-- 
1.9.1

