Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:51350 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab1JCKaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 06:30:15 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: kgiori@qca.qualcomm.com, rodrigue@qca.qualcomm.com,
	nbd@openwrt.org, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFC 6/6] ath9k: handle pulse data reported by DFS HW
Date: Mon,  3 Oct 2011 12:29:18 +0200
Message-Id: <1317637758-11907-7-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111003_123024_818949_F03E6FE1)
In-Reply-To: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note: calculation of mactime had to be shifted before
ath9k_rx_skb_preprocess() since it is used to time-stamp the
radar pulse.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 02c9f97..f5bb114 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -17,6 +17,10 @@
 #include <linux/dma-mapping.h>
 #include "ath9k.h"
 #include "ar9003_mac.h"
+#ifdef CONFIG_ATH9K_DFS
+#include "dfs.h"
+#endif
+
 
 #define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
 
@@ -1850,11 +1854,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (flush)
 			goto requeue_drop_frag;
 
-		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
-						 rxs, &decrypt_error);
-		if (retval)
-			goto requeue_drop_frag;
-
 		rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
 		if (rs.rs_tstamp > tsf_lower &&
 		    unlikely(rs.rs_tstamp - tsf_lower > 0x10000000))
@@ -1864,6 +1863,19 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
+#ifdef CONFIG_ATH9K_DFS
+		if ((hdr != NULL) && ((rs.rs_status & ATH9K_RXERR_PHY) != 0) &&
+				(rs.rs_phyerr == ATH9K_PHYERR_RADAR)) {
+			/* DFS: feed radar pulse */
+			ath9k_dfs_process_phyerr(sc, hdr, &rs, rxs->mactime);
+		}
+#endif
+
+		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
+						 rxs, &decrypt_error);
+		if (retval)
+			goto requeue_drop_frag;
+
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
 		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
-- 
1.7.4.1

