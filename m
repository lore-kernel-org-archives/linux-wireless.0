Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60135 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab2KVUyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 15:54:07 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so6079058pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 12:54:06 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: ath5k-devel@lists.ath5k.org
Cc: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	me@bobcopeland.com, linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2] ath5k: RX timestamp is reported at end of frame
Date: Wed, 21 Nov 2012 18:08:19 -0800
Message-Id: <1353550099-24919-1-git-send-email-thomas@cozybit.com> (sfid-20121122_215414_786455_FAB69A30)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is true for at least AR5213, and shouldn't be different for other
ath5k PHYs. Tested on AR2413 and AR5414.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Tested-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
---

v2:
	rebase on wt, which already contains the mac80211 code

 drivers/net/wireless/ath/ath5k/base.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 2fd5bab..16feb5e 100644
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

