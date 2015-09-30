Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13644 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbbI3Jpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:45:51 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/32] staging: wilc1000: remove AGING_ALG
Date: Wed, 30 Sep 2015 18:44:19 +0900
Message-ID: <1443606289-25407-2-git-send-email-tony.cho@atmel.com> (sfid-20150930_114558_408890_BE9E1B20)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes AGING_ALG from the Makefile because it is always in
use.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/Makefile           | 1 -
 drivers/staging/wilc1000/coreconfigurator.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index d226ebe..f495061 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -9,7 +9,6 @@ ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
 		-DP2P_CONCURRENCY_FIRMWARE=\"atmel/wilc1000_p2p_fw.bin\"
 
 ccflags-y += -I$(src)/ -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 \
-		-DAGING_ALG \
 		-Wno-unused-function -DWILC_DEBUGFS
 #ccflags-y += -DTCP_ACK_FILTER
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 253c7f0..58aa13c 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -96,9 +96,7 @@ typedef struct {
 	unsigned long u32TimeRcvdInScanCached;
 	unsigned long u32TimeRcvdInScan;
 	bool bNewNetwork;
-#ifdef AGING_ALG
 	u8 u8Found;
-#endif
 	u32 u32Tsf;
 	u8 *pu8IEs;
 	u16 u16IEsLen;
-- 
1.9.1

