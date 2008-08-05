Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:6320 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759447AbYHERcp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 13:32:45 -0400
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH] ath5k: set short preamble flag for rx
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Tue, 05 Aug 2008 19:32:23 +0200
Message-ID: <20080805173223.13155.82266.stgit@void> (sfid-20080805_193255_761808_85555313)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set the short preamble flag in ieee80211_rx_status for frames received with a
short preamble.

drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

 drivers/net/wireless/ath5k/base.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index b362c48..40cc6ca 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1767,12 +1767,10 @@ accept:
 		rxs.rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);
 		rxs.flag |= ath5k_rx_decrypted(sc, ds, skb, &rs);
 
-#if 0		/* add rxs.flag SHORTPRE once it is in mac80211 */
-		if (rs.rs_rate >= ATH5K_RATE_CODE_2M &&
-		    rs.rs_rate <= ATH5K_RATE_CODE_11M &&
-		    rs.rs_rate & AR5K_SET_SHORT_PREAMBLE)
+		if (rxs.rate_idx >= 0 && rs.rs_rate ==
+		    sc->curband->bitrates[rxs.rate_idx].hw_value_short)
 			rxs.flag |= RX_FLAG_SHORTPRE;
-#endif
+
 		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
 
 		/* check beacons in IBSS mode */

