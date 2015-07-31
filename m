Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44175 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbGaHjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:39:25 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/28] staging: wilc1000: change type of argument 5 in SendConfigPkt
Date: Fri, 31 Jul 2015 16:38:12 +0900
Message-ID: <1438328316-30197-5-git-send-email-tony.cho@atmel.com> (sfid-20150731_093927_983361_E68C920B)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch changes drvHandler of u32 type with WILC_WFIDrvHandle type since
SendConfigPkt function gets WILC_WFIDrvHandle type driver Handler pointer as
argument which makes compile warning.

As the type of parameter changed, associate code will be changed in the next
patches.

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 drivers/staging/wilc1000/coreconfigurator.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 342a336..e1928cc 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1986,7 +1986,7 @@ extern wilc_wlan_oup_t *gpstrWlanOps;
  *  @version	1.0
  */
 s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-			  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler)
+			  u32 u32WIDsCount, bool bRespRequired, WILC_WFIDrvHandle drvHandler)
 {
 	s32 counter = 0, ret = 0;
 	if (gpstrWlanOps == NULL) {
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 56ff2ba..98b5c49 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -167,7 +167,7 @@ extern s32 CoreConfiguratorInit(void);
 extern s32 CoreConfiguratorDeInit(void);
 
 extern s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-			 u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
+			 u32 u32WIDsCount, bool bRespRequired, WILC_WFIDrvHandle drvHandler);
 extern s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 extern s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
-- 
1.9.1

