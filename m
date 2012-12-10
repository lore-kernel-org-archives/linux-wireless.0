Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59991 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2LJWs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:48:28 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so2223709pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 14:48:28 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 3/3] ath5k: RX timestamp is reported at end of frame
Date: Mon, 10 Dec 2012 14:48:03 -0800
Message-Id: <1355179683-24846-3-git-send-email-thomas@cozybit.com> (sfid-20121210_234831_175017_544FCF0F)
In-Reply-To: <1355179683-24846-1-git-send-email-thomas@cozybit.com>
References: <1355179683-24846-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is true for at least AR5213, and shouldn't be different for other
ath5k PHYs. Tested on AR2413 and AR5414.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Tested-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 4ad40cf..30ca0a6 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1336,20 +1336,9 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 	 * 15bit only. that means TSF extension has to be done within
 	 * 32768usec (about 32ms). it might be necessary to move this to
 	 * the interrupt handler, like it is done in madwifi.
-	 *
-	 * Unfortunately we don't know when the hardware takes the rx
-	 * timestamp (beginning of phy frame, data frame, end of rx?).
-	 * The only thing we know is that it is hardware specific...
-	 * On AR5213 it seems the rx timestamp is at the end of the
-	 * frame, but I'm not sure.
-	 *
-	 * NOTE: mac80211 defines mactime at the beginning of the first
-	 * data symbol. Since we don't have any time references it's
-	 * impossible to comply to that. This affects IBSS merge only
-	 * right now, so it's not too bad...
 	 */
 	rxs->mactime = ath5k_extend_tsf(ah, rs->rs_tstamp);
-	rxs->flag |= RX_FLAG_MACTIME_START;
+	rxs->flag |= RX_FLAG_MACTIME_END;
 
 	rxs->freq = ah->curchan->center_freq;
 	rxs->band = ah->curchan->band;
-- 
1.7.10.4

