Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36897 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0GNB10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 21:27:26 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/3] ath9k: implement mac80211 flush op
Date: Tue, 13 Jul 2010 21:27:23 -0400
Message-Id: <1279070845-29442-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1279070845-29442-1-git-send-email-lrodriguez@atheros.com>
References: <1279070845-29442-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements the mac80211 flush callback to let mac80211
flush the hardware queues when it deems appropriate.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4c0831f..46a6543 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2031,6 +2031,24 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 	mutex_unlock(&sc->mutex);
 }
 
+static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+
+	mutex_lock(&sc->mutex);
+
+	if ((sc->sc_flags & SC_OP_INVALID))
+		goto out;
+
+	ath9k_ps_wakeup(sc);
+	ath_drain_all_txq(sc, !drop);
+	ath9k_ps_restore(sc);
+
+out:
+	mutex_unlock(&sc->mutex);
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2053,4 +2071,5 @@ struct ieee80211_ops ath9k_ops = {
 	.sw_scan_complete   = ath9k_sw_scan_complete,
 	.rfkill_poll        = ath9k_rfkill_poll_state,
 	.set_coverage_class = ath9k_set_coverage_class,
+	.flush		    = ath9k_flush,
 };
-- 
1.7.0.4

