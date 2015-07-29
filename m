Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35430 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbbG2Gx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 02:53:29 -0400
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH] Staging : wilc1000: Remove braces for single statement blocks
Date: Wed, 29 Jul 2015 12:18:58 +0530
Message-Id: <1438152538-9161-1-git-send-email-shraddha.6596@gmail.com> (sfid-20150729_085401_999292_926AA103)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following checkpatch.pl warning:

WARNING: braces {} are not necessary for single statement blocks
Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index ed6ac45..eb1b8f2 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -855,9 +855,8 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 
 		/* Get DTIM Period */
 		pu8TimElm = get_tim_elm(pu8msa, (u16RxLen + FCS_LEN), u8index);
-		if (pu8TimElm != 0) {
+		if (pu8TimElm != 0)
 			pstrNetworkInfo->u8DtimPeriod = pu8TimElm[3];
-		}
 		pu8IEs = &pu8msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN];
 		u16IEsLen = u16RxLen - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
 
-- 
2.1.0

