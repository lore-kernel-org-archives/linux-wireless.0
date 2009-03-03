Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40020 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758073AbZCCEu4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 23:50:56 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 20:50:55 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18860.46659.598795.680527@gargle.gargle.HOWL> (sfid-20090303_055114_836085_2D692BD2)
Date: Tue, 3 Mar 2009 10:16:59 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 7/7] ath9k: Remove unused variables in struct ath_beacon_config
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't store the beacon timestamp internally, nor
do we do any TIM handling in ath9k.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index a4f195b..9174e2a 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -426,11 +426,6 @@ struct ath_beacon_config {
 	u16 dtim_period;
 	u16 bmiss_timeout;
 	u8 dtim_count;
-	u8 tim_offset;
-	union {
-		u64 last_tsf;
-		u8 last_tstamp[8];
-	} u; /* last received beacon/probe response timestamp of this BSS. */
 };
 
 struct ath_beacon {
-- 
1.6.1

