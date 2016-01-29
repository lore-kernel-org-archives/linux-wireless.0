Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:40530 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbcA2Gyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 01:54:40 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 4/6] staging: wilc1000: remove unnecessary braces
Date: Fri, 29 Jan 2016 15:51:36 +0900
Message-ID: <1454050298-25815-4-git-send-email-leo.kim@atmel.com> (sfid-20160129_075445_563525_8C7F5BB9)
In-Reply-To: <1454050298-25815-1-git-send-email-leo.kim@atmel.com>
References: <1454050298-25815-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch remove warnings reported by checkpatch.pl
for unnecessary braces

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7b3a260..63b7492 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -984,15 +984,15 @@ void wilc_handle_isr(struct wilc *wilc)
 	if (int_status & PLL_INT_EXT)
 		wilc_pllupdate_isr_ext(wilc, int_status);
 
-	if (int_status & DATA_INT_EXT) {
+	if (int_status & DATA_INT_EXT)
 		wilc_wlan_handle_isr_ext(wilc, int_status);
-	}
+
 	if (int_status & SLEEP_INT_EXT)
 		wilc_sleeptimer_isr_ext(wilc, int_status);
 
-	if (!(int_status & (ALL_INT_EXT))) {
+	if (!(int_status & (ALL_INT_EXT)))
 		wilc_unknown_isr_ext(wilc);
-	}
+
 	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 }
 EXPORT_SYMBOL_GPL(wilc_handle_isr);
-- 
1.9.1

