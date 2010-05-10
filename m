Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0EJT03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 15:26:29 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH] ath5k: drop warning on jumbo frames
Date: Mon, 10 May 2010 15:26:27 -0400
Message-Id: <1273519587-25740-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jumbo frames are not supported, and if they are seen it is likely
a bogus frame so just silently discard them instead of warning on
them all time. Also, instead of dropping them immediately though
move the check *after* we check for all sort of frame errors. This
should enable us to discard these frames if the hardware picks
other bogus items first. Lets see if we still get those jumbo
counters increasing still with this.

Jumbo frames would happen if we tell hardware we can support
a small 802.11 chunks of DMA'd frame, hardware would split RX'd
frames into parts and we'd have to reconstruct them in software.
This is done with USB due to the bulk size but with ath5k we
already provide a good limit to hardware and this should not be
happening.

This is reported quite often and if it fills the logs then this
needs to be addressed and to avoid spurious reports.

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3cf35c4..9c27623 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1932,12 +1932,6 @@ ath5k_tasklet_rx(unsigned long data)
 
 		sc->stats.rx_all_count++;
 
-		if (unlikely(rs.rs_more)) {
-			ATH5K_WARN(sc, "unsupported jumbo\n");
-			sc->stats.rxerr_jumbo++;
-			goto next;
-		}
-
 		if (unlikely(rs.rs_status)) {
 			if (rs.rs_status & AR5K_RXERR_CRC)
 				sc->stats.rxerr_crc++;
@@ -1977,6 +1971,12 @@ ath5k_tasklet_rx(unsigned long data)
 					sc->opmode != NL80211_IFTYPE_MONITOR)
 				goto next;
 		}
+
+		if (unlikely(rs.rs_more)) {
+			sc->stats.rxerr_jumbo++;
+			goto next;
+
+		}
 accept:
 		next_skb = ath5k_rx_skb_alloc(sc, &next_skb_addr);
 
-- 
1.6.3.3

