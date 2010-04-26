Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34498 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab0DZUK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 16:10:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: remove usage of deprecated noise value
Date: Mon, 26 Apr 2010 16:09:19 -0400
Message-Id: <1272312559-22607-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a49ede7..1f3e5b0 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2029,8 +2029,7 @@ accept:
 		rxs->freq = sc->curchan->center_freq;
 		rxs->band = sc->curband->band;
 
-		rxs->noise = sc->ah->ah_noise_floor;
-		rxs->signal = rxs->noise + rs.rs_rssi;
+		rxs->signal = sc->ah->ah_noise_floor + rs.rs_rssi;
 
 		rxs->antenna = rs.rs_antenna;
 
-- 
1.6.6.1

