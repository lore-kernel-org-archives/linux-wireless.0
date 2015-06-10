Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34967 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbbFJS6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 14:58:00 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH v5 2/3] staging: wilc1000: coreconfigurator: Change return(X) to return X
Date: Wed, 10 Jun 2015 21:57:25 +0300
Message-Id: <1433962646-4278-2-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20150610_205825_882868_07DBABB9)
In-Reply-To: <1433962646-4278-1-git-send-email-kholmanskikh.s.s@gmail.com>
References: <1433962646-4278-1-git-send-email-kholmanskikh.s.s@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changed 'return(X)' to 'return X' in coreconfigurator.c
to satisfy checkpatch.pl warning:

ERROR: return is not a function, parentheses are not required

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index b54e43a..b90eaf1 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -710,13 +710,13 @@ u8 *get_tim_elm(u8 *pu8msa, WILC_Uint16 u16RxLen, WILC_Uint16 u16TagParamOffset)
 	/* Search for the TIM Element Field and return if the element is found */
 	while (u16index < (u16RxLen - FCS_LEN)) {
 		if (pu8msa[u16index] == ITIM) {
-			return(&pu8msa[u16index]);
+			return &pu8msa[u16index];
 		} else {
 			u16index += (IE_HDR_LEN + pu8msa[u16index + 1]);
 		}
 	}
 
-	return(0);
+	return 0;
 }
 
 /* This function gets the current channel information from
@@ -728,7 +728,7 @@ u8 get_current_channel_802_11n(u8 *pu8msa, WILC_Uint16 u16RxLen)
 	index = TAG_PARAM_OFFSET;
 	while (index < (u16RxLen - FCS_LEN)) {
 		if (pu8msa[index] == IDSPARMS)
-			return (pu8msa[index + 2]);
+			return pu8msa[index + 2];
 		else
 			/* Increment index by length information and header */
 			index += pu8msa[index + 1] + IE_HDR_LEN;
@@ -750,7 +750,7 @@ u8 get_current_channel(u8 *pu8msa, WILC_Uint16 u16RxLen)
 #else /* FIVE_GHZ_BAND */
 	/* Extract current channel information from */
 	/* the beacon/probe response frame          */
-	return (get_current_channel_802_11n(pu8msa, u16RxLen));
+	return get_current_channel_802_11n(pu8msa, u16RxLen);
 #endif /* FIVE_GHZ_BAND */
 #else
 	return 0;
-- 
1.9.1

