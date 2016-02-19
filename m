Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:47935 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947157AbcBSIkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 03:40:05 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 4/6] staging: wilc1000: removes unnecessary wilc_debug print log
Date: Fri, 19 Feb 2016 17:37:10 +0900
Message-ID: <1455871032-7625-4-git-send-email-leo.kim@atmel.com> (sfid-20160219_094017_110520_5F0E836D)
In-Reply-To: <1455871032-7625-1-git-send-email-leo.kim@atmel.com>
References: <1455871032-7625-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary wilc_debug print log.
The print log was written when if condition fail.
The condition is chip-id check function.
Also, replaces this condition with normal function.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a51c66b..4873106 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -508,9 +508,7 @@ void chip_wakeup(struct wilc *wilc)
 
 			do {
 				usleep_range(2 * 1000, 2 * 1000);
-				if ((wilc_get_chipid(wilc, true) == 0))
-					wilc_debug(N_ERR, "Couldn't read chip id. Wake up failed\n");
-
+				wilc_get_chipid(wilc, true);
 			} while ((wilc_get_chipid(wilc, true) == 0) && ((++trials % 3) == 0));
 
 		} while (wilc_get_chipid(wilc, true) == 0);
-- 
1.9.1

