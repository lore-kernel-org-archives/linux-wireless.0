Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:35075 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbZBPH5L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 02:57:11 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 23:57:11 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18841.7025.875981.934460@gargle.gargle.HOWL> (sfid-20090216_085715_561635_15AA46FF)
Date: Mon, 16 Feb 2009 13:23:21 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/4] ath9k: Fix antenna assignment bug in TX status processing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index a6c2042..f757bc7 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -285,7 +285,7 @@ int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds)
 	ds->ds_txstat.ts_shortretry = MS(ads->ds_txstatus1, AR_RTSFailCnt);
 	ds->ds_txstat.ts_longretry = MS(ads->ds_txstatus1, AR_DataFailCnt);
 	ds->ds_txstat.ts_virtcol = MS(ads->ds_txstatus1, AR_VirtRetryCnt);
-	ds->ds_txstat.ts_antenna = 1;
+	ds->ds_txstat.ts_antenna = 0;
 
 	return 0;
 }
-- 
1.6.1

