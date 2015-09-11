Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37658 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbbIKHxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2015 03:53:18 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/7] staging: wilc1000: remove useless define PHY_802_11n
Date: Fri, 11 Sep 2015 16:52:58 +0900
Message-ID: <1441957983-17726-3-git-send-email-tony.cho@atmel.com> (sfid-20150911_095320_976786_0D329311)
In-Reply-To: <1441957983-17726-1-git-send-email-tony.cho@atmel.com>
References: <1441957983-17726-1-git-send-email-tony.cho@atmel.com>
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
index f393424..342df2a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -18,7 +18,6 @@
 /* Constants                                                                 */
 /*****************************************************************************/
 #define INLINE static __inline
-#define PHY_802_11n
 #define MAX_CFG_PKTLEN     1450
 #define MSG_HEADER_LEN     4
 #define QUERY_MSG_TYPE     'Q'
@@ -552,7 +551,6 @@ u8 get_current_channel_802_11n(u8 *pu8msa, u16 u16RxLen)
 
 u8 get_current_channel(u8 *pu8msa, u16 u16RxLen)
 {
-#ifdef PHY_802_11n
 #ifdef FIVE_GHZ_BAND
 	/* Get the current channel as its not set in */
 	/* 802.11a beacons/probe response            */
@@ -562,9 +560,6 @@ u8 get_current_channel(u8 *pu8msa, u16 u16RxLen)
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

