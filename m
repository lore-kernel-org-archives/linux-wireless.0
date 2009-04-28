Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3944 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZD1CSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2009 22:18:55 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] ath5k: correct interrupt storm warning
Date: Mon, 27 Apr 2009 22:18:10 -0400
Message-Id: <1240885090-16390-2-git-send-email-me@bobcopeland.com> (sfid-20090428_041857_765216_ACEDA878)
In-Reply-To: <1240885090-16390-1-git-send-email-me@bobcopeland.com>
References: <1240885090-16390-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear points out that the "too many interrupts" message will
never print in the intended case since the interrupt counter
will be -1 after the loop.  Change it to pre-decrement so it will
be 0 on the thousandth iteration.

Cc: Ben Greear <greearb@candelatech.com>

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index ff05ee9..a546465 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2525,7 +2525,7 @@ ath5k_intr(int irq, void *dev_id)
 				ath5k_hw_update_mib_counters(ah, &sc->ll_stats);
 			}
 		}
-	} while (ath5k_hw_is_intr_pending(ah) && counter-- > 0);
+	} while (ath5k_hw_is_intr_pending(ah) && --counter > 0);
 
 	if (unlikely(!counter))
 		ATH5K_WARN(sc, "too many interrupts, giving up for now\n");
-- 
1.6.0.6


