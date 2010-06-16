Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:6270 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758599Ab0FPKMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:16 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-088183134
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:12:14 +0900 (JST)
Subject: [PATCH 09/17] ath5k: move checks and stats into new function
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:11:56 +0900
Message-ID: <20100616101156.10067.88925.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create a new function ath5k_receive_frame_ok() which checks for errors, updates
error statistics and tells us if we want to further "receive" this frame or
not. This way we can avoid a goto and have a cleaner separation between buffer
handling and other things.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |  130 ++++++++++++++++++---------------
 1 files changed, 70 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c54d1fd..a4482b5 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1973,6 +1973,61 @@ ath5k_receive_frame(struct ath5k_softc *sc, struct sk_buff *skb,
 	ieee80211_rx(sc->hw, skb);
 }
 
+/** ath5k_frame_receive_ok() - Do we want to receive this frame or not?
+ *
+ * Check if we want to further process this frame or not. Also update
+ * statistics. Return true if we want this frame, false if not.
+ */
+static bool
+ath5k_receive_frame_ok(struct ath5k_softc *sc, struct ath5k_rx_status *rs)
+{
+	sc->stats.rx_all_count++;
+
+	if (unlikely(rs->rs_status)) {
+		if (rs->rs_status & AR5K_RXERR_CRC)
+			sc->stats.rxerr_crc++;
+		if (rs->rs_status & AR5K_RXERR_FIFO)
+			sc->stats.rxerr_fifo++;
+		if (rs->rs_status & AR5K_RXERR_PHY) {
+			sc->stats.rxerr_phy++;
+			if (rs->rs_phyerr > 0 && rs->rs_phyerr < 32)
+				sc->stats.rxerr_phy_code[rs->rs_phyerr]++;
+			return false;
+		}
+		if (rs->rs_status & AR5K_RXERR_DECRYPT) {
+			/*
+			 * Decrypt error.  If the error occurred
+			 * because there was no hardware key, then
+			 * let the frame through so the upper layers
+			 * can process it.  This is necessary for 5210
+			 * parts which have no way to setup a ``clear''
+			 * key cache entry.
+			 *
+			 * XXX do key cache faulting
+			 */
+			sc->stats.rxerr_decrypt++;
+			if (rs->rs_keyix == AR5K_RXKEYIX_INVALID &&
+			    !(rs->rs_status & AR5K_RXERR_CRC))
+				return true;
+		}
+		if (rs->rs_status & AR5K_RXERR_MIC) {
+			sc->stats.rxerr_mic++;
+			return true;
+		}
+
+		/* let crypto-error packets fall through in MNTR */
+		if ((rs->rs_status & ~(AR5K_RXERR_DECRYPT|AR5K_RXERR_MIC)) ||
+		    sc->opmode != NL80211_IFTYPE_MONITOR)
+			return false;
+	}
+
+	if (unlikely(rs->rs_more)) {
+		sc->stats.rxerr_jumbo++;
+		return false;
+	}
+	return true;
+}
+
 static void
 ath5k_tasklet_rx(unsigned long data)
 {
@@ -2010,70 +2065,27 @@ ath5k_tasklet_rx(unsigned long data)
 			break;
 		}
 
-		sc->stats.rx_all_count++;
-
-		if (unlikely(rs.rs_status)) {
-			if (rs.rs_status & AR5K_RXERR_CRC)
-				sc->stats.rxerr_crc++;
-			if (rs.rs_status & AR5K_RXERR_FIFO)
-				sc->stats.rxerr_fifo++;
-			if (rs.rs_status & AR5K_RXERR_PHY) {
-				sc->stats.rxerr_phy++;
-				if (rs.rs_phyerr > 0 && rs.rs_phyerr < 32)
-					sc->stats.rxerr_phy_code[rs.rs_phyerr]++;
-				goto next;
-			}
-			if (rs.rs_status & AR5K_RXERR_DECRYPT) {
-				/*
-				 * Decrypt error.  If the error occurred
-				 * because there was no hardware key, then
-				 * let the frame through so the upper layers
-				 * can process it.  This is necessary for 5210
-				 * parts which have no way to setup a ``clear''
-				 * key cache entry.
-				 *
-				 * XXX do key cache faulting
-				 */
-				sc->stats.rxerr_decrypt++;
-				if (rs.rs_keyix == AR5K_RXKEYIX_INVALID &&
-				    !(rs.rs_status & AR5K_RXERR_CRC))
-					goto accept;
-			}
-			if (rs.rs_status & AR5K_RXERR_MIC) {
-				sc->stats.rxerr_mic++;
-				goto accept;
-			}
+		if (ath5k_receive_frame_ok(sc, &rs)) {
+			next_skb = ath5k_rx_skb_alloc(sc, &next_skb_addr);
 
-			/* let crypto-error packets fall through in MNTR */
-			if ((rs.rs_status &
-				~(AR5K_RXERR_DECRYPT|AR5K_RXERR_MIC)) ||
-					sc->opmode != NL80211_IFTYPE_MONITOR)
+			/*
+			 * If we can't replace bf->skb with a new skb under
+			 * memory pressure, just skip this packet
+			 */
+			if (!next_skb)
 				goto next;
-		}
-
-		if (unlikely(rs.rs_more)) {
-			sc->stats.rxerr_jumbo++;
-			goto next;
 
-		}
-accept:
-		next_skb = ath5k_rx_skb_alloc(sc, &next_skb_addr);
-
-		/*
-		 * If we can't replace bf->skb with a new skb under memory
-		 * pressure, just skip this packet
-		 */
-		if (!next_skb)
-			goto next;
+			pci_unmap_single(sc->pdev, bf->skbaddr,
+					 common->rx_bufsize,
+					 PCI_DMA_FROMDEVICE);
 
-		pci_unmap_single(sc->pdev, bf->skbaddr, common->rx_bufsize,
-				PCI_DMA_FROMDEVICE);
-		skb_put(skb, rs.rs_datalen);
+			skb_put(skb, rs.rs_datalen);
 
-		ath5k_receive_frame(sc, skb, &rs);
+			ath5k_receive_frame(sc, skb, &rs);
 
-		bf->skb = next_skb;
-		bf->skbaddr = next_skb_addr;
+			bf->skb = next_skb;
+			bf->skbaddr = next_skb_addr;
+		}
 next:
 		list_move_tail(&bf->list, &sc->rxbuf);
 	} while (ath5k_rxbuf_setup(sc, bf) == 0);
@@ -2082,8 +2094,6 @@ unlock:
 }
 
 
-
-
 /*************\
 * TX Handling *
 \*************/

