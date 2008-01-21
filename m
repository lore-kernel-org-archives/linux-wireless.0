Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:20795 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756464AbYAUCJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 21:09:59 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 2/2] ath5k: always extend rx timestamp with tsf
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Mon, 21 Jan 2008 11:09:46 +0900
Message-ID: <20080121020945.3818.74270.stgit@one> (sfid-20080121_021006_068308_36C84F67)
In-Reply-To: <20080121020924.3818.46553.stgit@one>
References: <20080121020924.3818.46553.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

always extend the rx timestamp with the local TSF, since this information is
also needed for proper IBSS merging. this is done in the tasklet for now, maybe
has to be moved to the interrupt handler like in madwifi.

drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 drivers/net/wireless/ath5k/base.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)


diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 6bbee64..d7d274f 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1725,11 +1725,18 @@ accept:
 			skb_pull(skb, pad);
 		}
 
-		if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
-			rxs.mactime = ath5k_extend_tsf(sc->ah,
-					ds->ds_rxstat.rs_tstamp);
-		else
-			rxs.mactime = ds->ds_rxstat.rs_tstamp;
+		/*
+		 * always extend the mac timestamp, since this information is
+		 * also needed for proper IBSS merging.
+		 *
+		 * XXX: it might be too late to do it here, since rs_tstamp is
+		 * 15bit only. that means TSF extension has to be done within
+		 * 32768usec (about 32ms). it might be necessary to move this to
+		 * the interrupt handler, like it is done in madwifi.
+		 */
+		rxs.mactime = ath5k_extend_tsf(sc->ah, ds->ds_rxstat.rs_tstamp);
+		rxs.flag |= RX_FLAG_TSFT;
+
 		rxs.freq = sc->curchan->freq;
 		rxs.channel = sc->curchan->chan;
 		rxs.phymode = sc->curmode;

