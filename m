Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:15045 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757792Ab0FPKMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:06 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0578023124
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:12:05 +0900 (JST)
Subject: [PATCH 07/17] ath5k: unify rx descriptor error handling
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:11:46 +0900
Message-ID: <20100616101146.10067.1272.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no reason for a special handling (return) here, just break like we do
with the checks before.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Acked-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 5479f85..d9df114 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1937,8 +1937,7 @@ ath5k_tasklet_rx(unsigned long data)
 		else if (unlikely(ret)) {
 			ATH5K_ERR(sc, "error in processing rx descriptor\n");
 			sc->stats.rxerr_proc++;
-			spin_unlock(&sc->rxbuflock);
-			return;
+			break;
 		}
 
 		sc->stats.rx_all_count++;

