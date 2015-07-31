Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44151 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbbGaHjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:39:18 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/28] staging: wilc1000: move structure WILC_WFIDrvHandle into wilc_wlan_if.h
Date: Fri, 31 Jul 2015 16:38:11 +0900
Message-ID: <1438328316-30197-4-git-send-email-tony.cho@atmel.com> (sfid-20150731_093921_011413_A2B15267)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch moves the structure WILC_WFIDrvHandle into wilc_wlan_if.h

As all the functions which take drive handler as argument will use WILC_WFIDrvHandle
type instead of u32 type that makes compile warning due to type difference,
move it into wilc_wlan_if which is common wilc header file.

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 3 ---
 drivers/staging/wilc1000/wilc_wlan_if.h   | 4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7699650..617f105 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -212,9 +212,6 @@ typedef void (*tWILCpfRemainOnChanReady)(void *); /*Remain on channel callback f
 #endif
 
 /* typedef u32 WILC_WFIDrvHandle; */
-typedef struct {
-	s32 s32Dummy;
-} *WILC_WFIDrvHandle;
 
 /*!
  *  @struct             tstrRcvdNetworkInfo
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 8735a6a..ba22d30 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -63,6 +63,10 @@
  ********************************************/
 
 typedef struct {
+	s32 s32Dummy;
+} *WILC_WFIDrvHandle;
+
+typedef struct {
 	uint32_t read_write: 1;
 	uint32_t function: 3;
 	uint32_t raw: 1;
-- 
1.9.1

