Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:23940 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757742Ab0FPKLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:11:50 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0977723108
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:11:48 +0900 (JST)
Subject: [PATCH 04/17] ath5k: fix rx descriptor debugging
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:11:30 +0900
Message-ID: <20100616101130.10067.99750.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the debug ouptut rx_status_0 was printed twice instead of rx_status_1. Also
make the debug message more clear.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Acked-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/debug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 5984edc..02db66e 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -925,7 +925,7 @@ ath5k_debug_printrxbuf(struct ath5k_buf *bf, int done,
 		ds, (unsigned long long)bf->daddr,
 		ds->ds_link, ds->ds_data,
 		rd->rx_ctl.rx_control_0, rd->rx_ctl.rx_control_1,
-		rd->u.rx_stat.rx_status_0, rd->u.rx_stat.rx_status_0,
+		rd->u.rx_stat.rx_status_0, rd->u.rx_stat.rx_status_1,
 		!done ? ' ' : (rs->rs_status == 0) ? '*' : '!');
 }
 
@@ -940,7 +940,7 @@ ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
 	if (likely(!(sc->debug.level & ATH5K_DEBUG_RESET)))
 		return;
 
-	printk(KERN_DEBUG "rx queue %x, link %p\n",
+	printk(KERN_DEBUG "rxdp %x, rxlink %p\n",
 		ath5k_hw_get_rxdp(ah), sc->rxlink);
 
 	spin_lock_bh(&sc->rxbuflock);

