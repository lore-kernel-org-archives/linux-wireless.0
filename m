Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:31770 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757486Ab0FPKLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:11:44 -0400
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0576083103
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:11:43 +0900 (JST)
Subject: [PATCH 03/17] ath5k: fix some comment typos
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:11:25 +0900
Message-ID: <20100616101125.10067.81348.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix comment about dma sizes, brackets were missing. Replace 'insure' with
'ensure'.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Acked-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath/ath5k/base.c  |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index cf16318..387c120 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -566,7 +566,7 @@ enum ath5k_pkt_type {
 )
 
 /*
- * DMA size definitions (2^n+2)
+ * DMA size definitions (2^(n+2))
  */
 enum ath5k_dmasize {
 	AR5K_DMASIZE_4B	= 0,
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 8e6b54d..5bd9a39 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1230,13 +1230,13 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	 * not get overrun under high load (as can happen with a
 	 * 5212 when ANI processing enables PHY error frames).
 	 *
-	 * To insure the last descriptor is self-linked we create
+	 * To ensure the last descriptor is self-linked we create
 	 * each descriptor as self-linked and add it to the end.  As
 	 * each additional descriptor is added the previous self-linked
-	 * entry is ``fixed'' naturally.  This should be safe even
+	 * entry is "fixed" naturally.  This should be safe even
 	 * if DMA is happening.  When processing RX interrupts we
 	 * never remove/process the last, self-linked, entry on the
-	 * descriptor list.  This insures the hardware always has
+	 * descriptor list.  This ensures the hardware always has
 	 * someplace to write a new frame.
 	 */
 	ds = bf->desc;

