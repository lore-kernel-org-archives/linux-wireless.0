Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46128 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab0GKKsz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:48:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 6/7] ath9k: validate the TID in the tx status information
Date: Sun, 11 Jul 2010 12:48:44 +0200
Message-Id: <1278845325-62000-6-git-send-email-nbd@openwrt.org>
In-Reply-To: <1278845325-62000-5-git-send-email-nbd@openwrt.org>
References: <1278845325-62000-1-git-send-email-nbd@openwrt.org>
 <1278845325-62000-2-git-send-email-nbd@openwrt.org>
 <1278845325-62000-3-git-send-email-nbd@openwrt.org>
 <1278845325-62000-4-git-send-email-nbd@openwrt.org>
 <1278845325-62000-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Occasionally the hardware can send out tx status information with the wrong
TID. In that case, the BA status cannot be trusted and the aggregate
must be retransmitted.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 05ec36a..bd52ac1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -355,6 +355,14 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	an = (struct ath_node *)sta->drv_priv;
 	tid = ATH_AN_2_TID(an, bf->bf_tidno);
 
+	/*
+	 * The hardware occasionally sends a tx status for the wrong TID.
+	 * In this case, the BA status cannot be considered valid and all
+	 * subframes need to be retransmitted
+	 */
+	if (bf->bf_tidno != ts->tid)
+		txok = false;
+
 	isaggr = bf_isaggr(bf);
 	memset(ba, 0, WME_BA_BMP_SIZE >> 3);
 
-- 
1.6.4.2

