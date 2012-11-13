Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35524 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2KMStN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 13:49:13 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so5218116pad.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 10:49:13 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: ath5k-devel@lists.ath5k.org
Cc: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	me@bobcopeland.com, linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] ath5k: RX timestamp is reported at end of frame
Date: Tue, 13 Nov 2012 10:48:55 -0800
Message-Id: <1352832535-21750-1-git-send-email-thomas@cozybit.com> (sfid-20121113_194934_587280_EBA4C0B6)
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
index 9f31cfa..ae1a2fe 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1335,20 +1335,9 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
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
-	rxs->flag |= RX_FLAG_MACTIME_MPDU;
+	rxs->flag |= RX_FLAG_MACTIME_END;
 
 	rxs->freq = ah->curchan->center_freq;
 	rxs->band = ah->curchan->band;
-- 
1.7.10.4

