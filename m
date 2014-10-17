Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:55840 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaJQCKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:10:04 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 08/23] ath9k: Use configurable timeout for flush
Date: Fri, 17 Oct 2014 07:40:15 +0530
Message-Id: <1413511830-5536-9-git-send-email-sujith@msujith.org> (sfid-20141017_041008_363187_68880DBD)
In-Reply-To: <1413511830-5536-1-git-send-email-sujith@msujith.org>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The timeout value for flushing the TX queues
is hardcoded at 200ms right now. Use a channel
context-specific value instead to allow adjustments
to the timeout in case MCC is enabled.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 1 +
 drivers/net/wireless/ath/ath9k/channel.c | 1 +
 drivers/net/wireless/ath/ath9k/main.c    | 9 ++++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index bc90fab..43c1987 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -345,6 +345,7 @@ struct ath_chanctx {
 	u64 tsf_val;
 	u32 last_beacon;
 
+	int flush_timeout;
 	u16 txpower;
 	bool offchannel;
 	bool stopped;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 74a5c27..5045b10 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -117,6 +117,7 @@ void ath_chanctx_init(struct ath_softc *sc)
 		cfg80211_chandef_create(&ctx->chandef, chan, NL80211_CHAN_HT20);
 		INIT_LIST_HEAD(&ctx->vifs);
 		ctx->txpower = ATH_TXPOWER_MAX;
+		ctx->flush_timeout = HZ / 5; /* 200ms */
 		for (j = 0; j < ARRAY_SIZE(ctx->acq); j++)
 			INIT_LIST_HEAD(&ctx->acq[j]);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5d54f39..81a20de 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2034,7 +2034,7 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	int timeout = HZ / 5; /* 200 ms */
+	int timeout;
 	bool drain_txq;
 
 	cancel_delayed_work_sync(&sc->tx_complete_work);
@@ -2049,6 +2049,13 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 		return;
 	}
 
+	spin_lock_bh(&sc->chan_lock);
+	timeout = sc->cur_chan->flush_timeout;
+	spin_unlock_bh(&sc->chan_lock);
+
+	ath_dbg(common, CHAN_CTX,
+		"Flush timeout: %d\n", jiffies_to_msecs(timeout));
+
 	if (wait_event_timeout(sc->tx_wait, !ath9k_has_tx_pending(sc),
 			       timeout) > 0)
 		drop = false;
-- 
2.1.2

