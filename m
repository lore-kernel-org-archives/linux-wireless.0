Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56149 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 19/29] ath9k: move the rx_stats->rs_datalen check to ath9k_rx_accept()
Date: Sat,  7 Nov 2009 15:18:56 -0500
Message-Id: <1257625146-17971-20-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0793614..4420a58 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -100,6 +100,9 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	hdr = (struct ieee80211_hdr *) skb->data;
 	fc = hdr->frame_control;
 
+	if (!rx_stats->rs_datalen)
+		return false;
+
 	if (rx_stats->rs_more) {
 		/*
 		 * Frame spans multiple descriptors; this cannot happen yet
@@ -793,9 +796,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		if (flush)
 			goto requeue;
 
-		if (!rx_stats->rs_datalen)
-			goto requeue;
-
 		/* The status portion of the descriptor could get corrupted. */
 		if (sc->rx.bufsize < rx_stats->rs_datalen)
 			goto requeue;
-- 
1.6.5.2.143.g8cc62

