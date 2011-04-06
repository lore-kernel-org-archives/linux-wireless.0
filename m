Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51356 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab1DFGLW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 02:11:22 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 23:10:57 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k: Implement dev_tx_frames_pending callback.
Date: Wed, 6 Apr 2011 11:41:11 +0530
Message-ID: <1302070271-8343-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1302070271-8343-1-git-send-email-vnatarajan@atheros.com>
References: <1302070271-8343-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function returns true if there is atleast one frame
in any one of the tx queues.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6a41302..4506968 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2186,6 +2186,21 @@ out:
 	ath9k_ps_restore(sc);
 }
 
+static bool ath9k_tx_frames_pending(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+	int i;
+
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+		if (!ATH_TXQ_SETUP(sc, i))
+			continue;
+
+		if (ath9k_has_pending_frames(sc, &sc->tx.txq[i]))
+			return true;
+	}
+	return false;
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2208,4 +2223,5 @@ struct ieee80211_ops ath9k_ops = {
 	.rfkill_poll        = ath9k_rfkill_poll_state,
 	.set_coverage_class = ath9k_set_coverage_class,
 	.flush		    = ath9k_flush,
+	.tx_frames_pending  = ath9k_tx_frames_pending,
 };
-- 
1.6.3.3

