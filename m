Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab0FOWfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 18:35:09 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: stable@kernel.org, greg@kroah.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2.6.32..2.6.33] ath5k: drop warning on jumbo frames
Date: Tue, 15 Jun 2010 18:35:07 -0400
Message-Id: <1276641307-10287-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 9637e516d16a58b13f6098cfe899e22963132be3 upstream.

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
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---

Greg, here's a stable ath5k patch which required some manual
backport. The backported was needed since the sc->stats.rxerr_jumbo
counter was not available until 2.6.34 and it was used on the upstream
commit. This goes only compile tested against 2.6.32.y and 2.6.33.y.

 drivers/net/wireless/ath/ath5k/base.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 6313788..9846e8b 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1818,11 +1818,6 @@ ath5k_tasklet_rx(unsigned long data)
 			return;
 		}
 
-		if (unlikely(rs.rs_more)) {
-			ATH5K_WARN(sc, "unsupported jumbo\n");
-			goto next;
-		}
-
 		if (unlikely(rs.rs_status)) {
 			if (rs.rs_status & AR5K_RXERR_PHY)
 				goto next;
@@ -1852,6 +1847,8 @@ ath5k_tasklet_rx(unsigned long data)
 					sc->opmode != NL80211_IFTYPE_MONITOR)
 				goto next;
 		}
+		if (unlikely(rs.rs_more))
+			goto next;
 accept:
 		next_skb = ath5k_rx_skb_alloc(sc, &next_skb_addr);
 
-- 
1.6.3.3

