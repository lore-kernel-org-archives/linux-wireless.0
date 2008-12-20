Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33823 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYLTF4D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:56:03 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 21:56:03 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 14/16] ath9k: remove ath9k_hw_check_chan()
Date: Fri, 19 Dec 2008 21:55:20 -0800
Message-ID: <1229752522-1917-15-git-send-email-lrodriguez@atheros.com> (sfid-20081220_065612_357522_B62826E6)
In-Reply-To: <1229752522-1917-14-git-send-email-lrodriguez@atheros.com>
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-3-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-4-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-5-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-6-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-7-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-8-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-9-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-10-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-11-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-12-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-13-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-14-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only check we care about in ath9k_hw_check_chan() is
the internal regulatory check so use that.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |   30 +++---------------------------
 1 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 436fbc8..7d5ca81 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1627,30 +1627,6 @@ static bool ath9k_hw_chip_reset(struct ath_hal *ah,
 	return true;
 }
 
-static struct ath9k_channel *ath9k_hw_check_chan(struct ath_hal *ah,
-						 struct ath9k_channel *chan)
-{
-	if (!(IS_CHAN_2GHZ(chan) ^ IS_CHAN_5GHZ(chan))) {
-		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			"invalid channel %u/0x%x; not marked as "
-			"2GHz or 5GHz\n", chan->channel, chan->channelFlags);
-		return NULL;
-	}
-
-	if (!IS_CHAN_OFDM(chan) &&
-	    !IS_CHAN_B(chan) &&
-	    !IS_CHAN_HT20(chan) &&
-	    !IS_CHAN_HT40(chan)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			"invalid channel %u/0x%x; not marked as "
-			"OFDM or CCK or HT20 or HT40PLUS or HT40MINUS\n",
-			chan->channel, chan->channelFlags);
-		return NULL;
-	}
-
-	return ath9k_regd_check_channel(ah, chan);
-}
-
 static bool ath9k_hw_channel_change(struct ath_hal *ah,
 				    struct ath9k_channel *chan,
 				    enum ath9k_ht_macmode macmode)
@@ -2203,10 +2179,10 @@ int ath9k_hw_reset(struct ath_hal *ah, bool bChannelChange)
 		ahp->ah_rxchainmask &= 0x3;
 	}
 
-	if (ath9k_hw_check_chan(ah, chan) == NULL) {
+	if (ath9k_regd_check_channel(ah, chan) == NULL) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			"invalid channel %u/0x%x; no mapping\n",
-			chan->channel, chan->channelFlags);
+			"invalid channel %u; no mapping\n",
+			channel->center_freq);
 		return -EINVAL;
 	}
 
-- 
1.5.6.rc2.15.g457bb.dirty

