Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:41709 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757561AbYARMuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 07:50:54 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 2/4] ath5k: always extend rx timestamp with tsf
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Fri, 18 Jan 2008 21:50:59 +0900
Message-ID: <20080118125059.6342.18514.stgit@one> (sfid-20080118_125058_002033_B2C26779)
In-Reply-To: <20080118125018.6342.94435.stgit@one>
References: <20080118125018.6342.94435.stgit@one>
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
index 6bbee64..bb1745f 100644
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
+		 * 32.768usec = 32ms. it might be necessary to move this to the
+		 * interrupt handler, like it is done in madwifi.
+		 */
+		rxs.mactime = ath5k_extend_tsf(sc->ah, ds->ds_rxstat.rs_tstamp);
+		rxs.flag |= RX_FLAG_TSFT;
+
 		rxs.freq = sc->curchan->freq;
 		rxs.channel = sc->curchan->chan;
 		rxs.phymode = sc->curmode;

