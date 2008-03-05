Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:1026 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758722AbYCEJg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:36:27 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 3/4] ath5k: add notes about rx timestamp
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 05 Mar 2008 18:36:05 +0900
Message-ID: <20080305093605.5670.61791.stgit@one> (sfid-20080305_093711_111839_51970CD4)
In-Reply-To: <20080305091347.5670.40944.stgit@one>
References: <20080305091347.5670.40944.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add comments about the fact that we don't know when exactly the atheros
hardware takes the RX timestamp.

drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 drivers/net/wireless/ath5k/base.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)


diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 777bc4a..03e05fe 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1841,6 +1841,17 @@ accept:
 		 * 15bit only. that means TSF extension has to be done within
 		 * 32768usec (about 32ms). it might be necessary to move this to
 		 * the interrupt handler, like it is done in madwifi.
+		 *
+		 * Unfortunately we don't know when the hardware takes the rx
+		 * timestamp (beginning of phy frame, data frame, end of rx?).
+		 * The only thing we know is that it is hardware specific...
+		 * On AR5213 it seems the rx timestamp is at the end of the
+		 * frame, but i'm not sure.
+		 *
+		 * NOTE: mac80211 defines mactime at the beginning of the first
+		 * data symbol. Since we don't have any time references it's
+		 * impossible to comply to that. This affects IBSS merge only
+		 * right now, so it's not too bad...
 		 */
 		rxs.mactime = ath5k_extend_tsf(sc->ah, rs.rs_tstamp);
 		rxs.flag |= RX_FLAG_TSFT;

