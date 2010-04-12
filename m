Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:45666 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751969Ab0DLHiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 03:38:52 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-028257931
	for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 16:38:51 +0900 (JST)
Subject: [PATCH 2/2] ath5k: treat RXORN as non-fatal
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 12 Apr 2010 16:38:52 +0900
Message-ID: <20100412073852.28215.40002.stgit@tt-desk>
In-Reply-To: <20100412073847.28215.87571.stgit@tt-desk>
References: <20100412073847.28215.87571.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We get RXORN interrupts when all receive buffers are full. This is not
necessarily a fatal situation. It can also happen when the bus is busy or the
CPU is not fast enough to process all frames.

Older chipsets apparently need a reset to come out of this situration, but on
newer chips we can treat RXORN like RX, as going thru a full reset does more
harm than good, there.

The exact chip revisions which need a reset are unknown - this guess
AR5K_SREV_AR5212 ("venice") is copied from the HAL.

Inspired by openwrt 413-rxorn.patch:
"treat rxorn like rx, reset after rxorn seems to do more harm than good"

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   15 ++++++++++++++-
 drivers/net/wireless/ath/ath5k/base.h |    1 +
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3f59bc2..9232742 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2705,7 +2705,20 @@ ath5k_intr(int irq, void *dev_id)
 			 */
 			tasklet_schedule(&sc->restq);
 		} else if (unlikely(status & AR5K_INT_RXORN)) {
-			tasklet_schedule(&sc->restq);
+			/*
+			 * Receive buffers are full. Either the bus is busy or
+			 * the CPU is not fast enough to process all received
+			 * frames.
+			 * Older chipsets need a reset to come out of this
+			 * condition, but we treat it as RX for newer chips.
+			 * We don't know exactly which versions need a reset -
+			 * this guess is copied from the HAL.
+			 */
+			sc->stats.rxorn_intr++;
+			if (ah->ah_mac_srev < AR5K_SREV_AR5212)
+				tasklet_schedule(&sc->restq);
+			else
+				tasklet_schedule(&sc->rxtq);
 		} else {
 			if (status & AR5K_INT_SWBA) {
 				tasklet_hi_schedule(&sc->beacontq);
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 53a5651..56221bc 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -135,6 +135,7 @@ struct ath5k_statistics {
 	unsigned int beacons;
 
 	unsigned int mib_intr;
+	unsigned int rxorn_intr;
 };
 
 #if CHAN_DEBUG

