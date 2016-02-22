Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:31622 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbcBVEoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2016 23:44:12 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 04/10] staging: wilc1000: removes unnecessary wilc_debug print log
Date: Mon, 22 Feb 2016 13:41:13 +0900
Message-ID: <1456116079-7161-4-git-send-email-leo.kim@atmel.com> (sfid-20160222_054415_869422_0C2474CF)
In-Reply-To: <1456116079-7161-1-git-send-email-leo.kim@atmel.com>
References: <1456116079-7161-1-git-send-email-leo.kim@atmel.com>
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
index f0ac47f..34018a1 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -502,9 +502,7 @@ void chip_wakeup(struct wilc *wilc)
 
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

