Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:56619 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbbIOCxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 22:53:49 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/7] staging: wilc1000: remove definition WILC_IS_ERR
Date: Tue, 15 Sep 2015 11:53:35 +0900
Message-ID: <1442285621-29457-2-git-send-email-tony.cho@atmel.com> (sfid-20150915_045352_394325_3A13DDCC)
In-Reply-To: <1442285621-29457-1-git-send-email-tony.cho@atmel.com>
References: <1442285621-29457-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the definition WILC_IS_ERR which is not used anymore.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_errorsupport.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_errorsupport.h b/drivers/staging/wilc1000/wilc_errorsupport.h
index 6012ec4..8eb8150 100644
--- a/drivers/staging/wilc1000/wilc_errorsupport.h
+++ b/drivers/staging/wilc1000/wilc_errorsupport.h
@@ -37,10 +37,9 @@
 
 
 
-#define WILC_IS_ERR(__status__) (__status__ < WILC_SUCCESS)
 
 #define WILC_ERRORCHECK(__status__) do { \
-		if (WILC_IS_ERR(__status__)) { \
+		if (__status__ < WILC_SUCCESS) { \
 			PRINT_ER("PRINT_ER(%d)\n", __status__);	\
 			goto ERRORHANDLER; \
 		} \
@@ -60,6 +59,6 @@
 
 #define WILC_CATCH(__status__) \
 ERRORHANDLER: \
-	if (WILC_IS_ERR(__status__)) \
+	if (__status__ < WILC_SUCCESS) \
 
 #endif
-- 
1.9.1

