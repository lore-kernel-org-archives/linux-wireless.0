Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43055 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab0EKCli (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 22:41:38 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 10 May 2010 19:41:38 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k: Remove unused rx_edma in ath_rx_addbuffer_edma()
Date: Mon, 10 May 2010 19:41:35 -0700
Message-ID: <1273545695-2987-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1273545695-2987-1-git-send-email-vasanth@atheros.com>
References: <1273545695-2987-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index da54ff5..ba13913 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -150,11 +150,9 @@ static bool ath_rx_edma_buf_link(struct ath_softc *sc,
 static void ath_rx_addbuffer_edma(struct ath_softc *sc,
 				  enum ath9k_rx_qtype qtype, int size)
 {
-	struct ath_rx_edma *rx_edma;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	u32 nbuf = 0;
 
-	rx_edma = &sc->rx.rx_edma[qtype];
 	if (list_empty(&sc->rx.rxbuf)) {
 		ath_print(common, ATH_DBG_QUEUE, "No free rx buf available\n");
 		return;
-- 
1.7.0.4

