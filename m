Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:40753 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbYELPEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 11:04:06 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: mickflemm@gmail.com, mcgrof@gmail.com, jirislaby@gmail.com
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: [PATCH] ath5k: Fix loop variable initializations
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <E1JvZ2x-0005kb-TH@hash.localnet> (sfid-20080512_170411_624425_08F4C334)
Date: Mon, 12 May 2008 10:30:35 -0400
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>
Date: Mon, 12 May 2008 09:25:33 -0400
Subject: [PATCH] ath5k: Fix loop variable initializations

In ath5k_tasklet_rx, both status structures 'rxs' and 'rs' are
initialized at the top of the tasklet, but not within the loop.
If the loop is executed multiple times in the tasklet, then the
variables may see changes from previous packets.

For TKIP, this results in 'Invalid Michael MIC' errors if two packets
are processed in the tasklet: rxs.flag gets set to RX_DECRYPTED by
mac80211 when it decrypts the first encrypted packet.  The subsequent
packet will have RX_DECRYPTED set upon entry to mac80211, so mac80211
will not try to decrypt it.

We currently initialize all but two fields in the structures, so fix
the other two.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    2 +-
 drivers/net/wireless/ath5k/hw.c   |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 4e5c8fc..fd8537e 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1888,7 +1888,7 @@ accept:
 		 * right now, so it's not too bad...
 		 */
 		rxs.mactime = ath5k_extend_tsf(sc->ah, rs.rs_tstamp);
-		rxs.flag |= RX_FLAG_TSFT;
+		rxs.flag = RX_FLAG_TSFT;
 
 		rxs.freq = sc->curchan->center_freq;
 		rxs.band = sc->curband->band;
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 5fb1ae6..8137d82 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -4119,6 +4119,7 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
 		AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
 	rs->rs_status = 0;
+	rs->rs_phyerr = 0;
 
 	/*
 	 * Key table status
@@ -4193,6 +4194,7 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
 		AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
 	rs->rs_status = 0;
+	rs->rs_phyerr = 0;
 
 	/*
 	 * Key table status
-- 
1.5.4.2.182.gb3092

-- 
Bob Copeland %% www.bobcopeland.com


