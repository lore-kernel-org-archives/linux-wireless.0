Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44258 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbbGaHjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:39:51 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/28] staging: wilc1000: change drvHandler type in wlan_cfg_get
Date: Fri, 31 Jul 2015 16:38:16 +0900
Message-ID: <1438328316-30197-9-git-send-email-tony.cho@atmel.com> (sfid-20150731_093954_284854_A12E1B42)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch changes drvHandler of uint32_t type with WILC_WFIDrvHandle type in
wlan_cfg_get and wilc_wlan_cfg_get.

The type of drvHandler which wlan_cfg_get take as argument was changed to WILC_WFIDrvHandle.
So the type needs to be changed to match parameter type.

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c    | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index def72fd..273073f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1938,7 +1938,7 @@ static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t
 
 	return ret_size;
 }
-static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, uint32_t drvHandler)
+static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, WILC_WFIDrvHandle drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	uint32_t offset;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index ba22d30..6d2d588 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -198,7 +198,7 @@ typedef struct {
 	void (*wlan_handle_rx_isr)(void);
 	void (*wlan_cleanup)(void);
 	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, uint32_t);
-	int (*wlan_cfg_get)(int, uint32_t, int, uint32_t);
+	int (*wlan_cfg_get)(int, uint32_t, int, WILC_WFIDrvHandle);
 	int (*wlan_cfg_get_value)(uint32_t, uint8_t *, uint32_t);
 	/*Bug3959: transmitting mgmt frames received from host*/
 	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
-- 
1.9.1

