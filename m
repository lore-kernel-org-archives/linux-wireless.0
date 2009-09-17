Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21644 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758379AbZIQD5F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:57:05 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 20:57:09 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19121.45974.436688.925055@gargle.gargle.HOWL>
Date: Thu, 17 Sep 2009 09:27:10 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/12] ath9k: Do a full reset for AR9280
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

AR9280 requires a full reset during channel change and HW reset.
Currently, a fast channel change is done. This patch fixes
this bug.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2c904c6..323df96 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2366,8 +2366,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	    (chan->channel != ah->curchan->channel) &&
 	    ((chan->channelFlags & CHANNEL_ALL) ==
 	     (ah->curchan->channelFlags & CHANNEL_ALL)) &&
-	    (!AR_SREV_9280(ah) || (!IS_CHAN_A_5MHZ_SPACED(chan) &&
-				   !IS_CHAN_A_5MHZ_SPACED(ah->curchan)))) {
+	     !(AR_SREV_9280(ah) || IS_CHAN_A_5MHZ_SPACED(chan) ||
+	     IS_CHAN_A_5MHZ_SPACED(ah->curchan))) {
 
 		if (ath9k_hw_channel_change(ah, chan, sc->tx_chan_width)) {
 			ath9k_hw_loadnf(ah, ah->curchan);
-- 
1.6.4.3

