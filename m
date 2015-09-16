Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5608 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbbIPBoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 21:44:17 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 03/10] staging: wilc1000: remove unnecessary define FIVE_GHZ_BAND
Date: Wed, 16 Sep 2015 10:43:48 +0900
Message-ID: <1442367835-30733-4-git-send-email-tony.cho@atmel.com> (sfid-20150916_034419_699395_287710D8)
In-Reply-To: <1442367835-30733-1-git-send-email-tony.cho@atmel.com>
References: <1442367835-30733-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

wilc1000 driver does not support five Ghz band. Remove FIVE_GHZ_BAND and
it's related code.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index c46fe9f..ac3da88 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -550,15 +550,9 @@ u8 get_current_channel_802_11n(u8 *pu8msa, u16 u16RxLen)
 
 u8 get_current_channel(u8 *pu8msa, u16 u16RxLen)
 {
-#ifdef FIVE_GHZ_BAND
-	/* Get the current channel as its not set in */
-	/* 802.11a beacons/probe response            */
-	return (get_rf_channel() + 1);
-#else /* FIVE_GHZ_BAND */
 	/* Extract current channel information from */
 	/* the beacon/probe response frame          */
 	return get_current_channel_802_11n(pu8msa, u16RxLen);
-#endif /* FIVE_GHZ_BAND */
 }
 
 /**
-- 
1.9.1

