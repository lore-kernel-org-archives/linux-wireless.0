Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 22/29] ath9k: move the max rx buffer size check to ath9k_rx_accept()
Date: Sat,  7 Nov 2009 15:18:59 -0500
Message-Id: <1257625146-17971-23-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While at it flip the order, seems easier to read and also
add some better description as to why we do this check.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 48ff772..16ed929 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -105,6 +105,13 @@ static bool ath9k_rx_accept(struct ath_common *common,
 
 	if (!rx_stats->rs_datalen)
 		return false;
+        /*
+         * rs_status follows rs_datalen so if rs_datalen is too large
+         * we can take a hint that hardware corrupted it, so ignore
+         * those frames.
+         */
+	if (rx_stats->rs_datalen > common->rx_bufsize)
+		return false;
 
 	if (rx_stats->rs_more) {
 		/*
@@ -801,10 +808,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		if (flush)
 			goto requeue;
 
-		/* The status portion of the descriptor could get corrupted. */
-		if (common->rx_bufsize < rx_stats->rs_datalen)
-			goto requeue;
-
 		if (!ath_rx_prepare(common, hw, skb, rx_stats,
 				    rxs, &decrypt_error))
 			goto requeue;
-- 
1.6.5.2.143.g8cc62

