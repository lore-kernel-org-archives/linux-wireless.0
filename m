Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45692 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbIGKJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 06:09:18 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/3] staging: wilc1000: remove unused preprocessor definition
Date: Mon, 7 Sep 2015 19:09:30 +0900
Message-ID: <1441620571-23033-2-git-send-email-tony.cho@atmel.com> (sfid-20150907_120921_045467_8A52AB70)
In-Reply-To: <1441620571-23033-1-git-send-email-tony.cho@atmel.com>
References: <1441620571-23033-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes a preprocessor definition, SWITCH_LOG_TERMINAL,
which is not used. Enabling this definition affects the performance.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c    | 6 ------
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 8 --------
 2 files changed, 14 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4187c7c..59c9b44 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -926,12 +926,6 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
 		goto _fail_;
 
-#ifdef SWITCH_LOG_TERMINAL
-	c_val[0] = AUTO_PROT;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_LOGTerminal_Switch, c_val, 1, 0, 0))
-		goto _fail_;
-#endif
-
 	c_val[0] = ACTIVE_SCAN;
 	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SCAN_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index d503799..21ed14d 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -534,14 +534,6 @@ static int wilc_wlan_cfg_indicate_rx(uint8_t *frame, int size, wilc_cfg_rsp_t *r
 		GnrlAsyncInfoReceived(frame - 4, size + 4);
 		break;
 
-	case 'L':
-#ifndef SWITCH_LOG_TERMINAL
-		PRINT_ER("Unexpected firmware log message received\n");
-#else
-		PRINT_D(FIRM_DBG, "\nFIRMWARE LOGS :\n<<\n%s\n>>\n", frame);
-		break;
-
-#endif
 #if 1
 	case 'N':
 		NetworkInfoReceived(frame - 4, size + 4);
-- 
1.9.1

