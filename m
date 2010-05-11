Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43053 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab0EKClh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 22:41:37 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 10 May 2010 19:41:37 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: Fix bug in handling rx frames with invalid descriptor content
Date: Mon, 10 May 2010 19:41:34 -0700
Message-ID: <1273545695-2987-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't send them for further processing.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ac60c4e..da54ff5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -718,6 +718,7 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
 		__skb_unlink(skb, &rx_edma->rx_fifo);
 		list_add_tail(&bf->list, &sc->rx.rxbuf);
 		ath_rx_edma_buf_link(sc, qtype);
+		return true;
 	}
 	skb_queue_tail(&rx_edma->rx_buffers, skb);
 
-- 
1.7.0.4

