Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:21595 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932620Ab0I0DW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Sep 2010 23:22:29 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0744407746
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 12:22:27 +0900 (JST)
Subject: [PATCH 3/4] ath5k: Increase "fudge" for beacon timers
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 27 Sep 2010 12:22:26 +0900
Message-ID: <20100927032226.8754.82461.stgit@tt-desk>
In-Reply-To: <20100927032211.8754.49870.stgit@tt-desk>
References: <20100927032211.8754.49870.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use FUDGE to make sure the next TBTT is ahead of the current TU.
Since we later substract AR5K_TUNE_SW_BEACON_RESP (10) in the timer
configuration we need to make sure it is bigger than that.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 4103765..94cc335 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1886,8 +1886,11 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
 	hw_tsf = ath5k_hw_get_tsf64(ah);
 	hw_tu = TSF_TO_TU(hw_tsf);
 
-#define FUDGE 3
-	/* we use FUDGE to make sure the next TBTT is ahead of the current TU */
+#define FUDGE AR5K_TUNE_SW_BEACON_RESP + 3
+	/* We use FUDGE to make sure the next TBTT is ahead of the current TU.
+	 * Since we later substract AR5K_TUNE_SW_BEACON_RESP (10) in the timer
+	 * configuration we need to make sure it is bigger than that. */
+
 	if (bc_tsf == -1) {
 		/*
 		 * no beacons received, called internally.

