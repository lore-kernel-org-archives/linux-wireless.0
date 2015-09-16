Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5585 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbbIPBoJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 21:44:09 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 02/10] staging: wilc1000: remove useless define PHY_802_11n
Date: Wed, 16 Sep 2015 10:43:47 +0900
Message-ID: <1442367835-30733-3-git-send-email-tony.cho@atmel.com> (sfid-20150916_034413_450865_A28F984D)
In-Reply-To: <1442367835-30733-1-git-send-email-tony.cho@atmel.com>
References: <1442367835-30733-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

The define PHY_802_11n is useless because wilc1000 support 802.11n as always.
Remove PHY_802_11n and it related code.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 8164a33..c46fe9f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -17,7 +17,6 @@
 /* Constants                                                                 */
 /*****************************************************************************/
 #define INLINE static __inline
-#define PHY_802_11n
 #define MAX_CFG_PKTLEN     1450
 #define MSG_HEADER_LEN     4
 #define QUERY_MSG_TYPE     'Q'
@@ -551,7 +550,6 @@ u8 get_current_channel_802_11n(u8 *pu8msa, u16 u16RxLen)
 
 u8 get_current_channel(u8 *pu8msa, u16 u16RxLen)
 {
-#ifdef PHY_802_11n
 #ifdef FIVE_GHZ_BAND
 	/* Get the current channel as its not set in */
 	/* 802.11a beacons/probe response            */
@@ -561,9 +559,6 @@ u8 get_current_channel(u8 *pu8msa, u16 u16RxLen)
 	/* the beacon/probe response frame          */
 	return get_current_channel_802_11n(pu8msa, u16RxLen);
 #endif /* FIVE_GHZ_BAND */
-#else
-	return 0;
-#endif /* PHY_802_11n */
 }
 
 /**
-- 
1.9.1

