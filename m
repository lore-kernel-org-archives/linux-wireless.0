Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:57920 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbaIECdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 22:33:25 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v3 11/11] ath9k: Fix interface accounting
Date: Fri,  5 Sep 2014 08:03:19 +0530
Message-Id: <1409884399-32289-12-git-send-email-sujith@msujith.org> (sfid-20140905_043333_046881_5880B8A6)
In-Reply-To: <1409884399-32289-1-git-send-email-sujith@msujith.org>
References: <1409884399-32289-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Currently, the interface count is maintained globally,
but this causes problems in RX filter calculation.
Make the interface count a per-channel-context variable
to fix this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  | 2 +-
 drivers/net/wireless/ath/ath9k/beacon.c | 2 +-
 drivers/net/wireless/ath/ath9k/debug.c  | 2 +-
 drivers/net/wireless/ath/ath9k/main.c   | 6 +++---
 drivers/net/wireless/ath/ath9k/recv.c   | 4 ++--
 drivers/net/wireless/ath/ath9k/tx99.c   | 2 +-
 drivers/net/wireless/ath/ath9k/wow.c    | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4f3da18..46a1d2e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -350,6 +350,7 @@ struct ath_chanctx {
 	bool assigned;
 	bool switch_after_beacon;
 
+	short nvifs;
 	unsigned int rxfilter;
 };
 
@@ -963,7 +964,6 @@ struct ath_softc {
 	bool ps_enabled;
 	bool ps_idle;
 	short nbcnvifs;
-	short nvifs;
 	unsigned long ps_usecount;
 
 	struct ath_rx rx;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 83f2f2f..a6af855 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -183,7 +183,7 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 	spin_unlock_bh(&cabq->axq_lock);
 
 	if (skb && cabq_depth) {
-		if (sc->nvifs > 1) {
+		if (sc->cur_chan->nvifs > 1) {
 			ath_dbg(common, BEACON,
 				"Flushing previous cabq traffic\n");
 			ath_draintxq(sc, cabq);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index d227936..5d8b5ea 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -838,7 +838,7 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 			iter_data.nmeshes, iter_data.nwds);
 		len += scnprintf(buf + len, sizeof(buf) - len,
 			" ADHOC: %i TOTAL: %hi BEACON-VIF: %hi\n",
-			iter_data.nadhocs, sc->nvifs, sc->nbcnvifs);
+			iter_data.nadhocs, sc->cur_chan->nvifs, sc->nbcnvifs);
 	}
 
 	if (len > sizeof(buf))
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a202859..cdf1e7d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1117,7 +1117,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 
 	if (config_enabled(CONFIG_ATH9K_TX99)) {
-		if (sc->nvifs >= 1) {
+		if (sc->cur_chan->nvifs >= 1) {
 			mutex_unlock(&sc->mutex);
 			return -EOPNOTSUPP;
 		}
@@ -1125,7 +1125,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	}
 
 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
-	sc->nvifs++;
+	sc->cur_chan->nvifs++;
 
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_assign_slot(sc, vif);
@@ -1207,7 +1207,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	ath9k_p2p_remove_vif(sc, vif);
 
-	sc->nvifs--;
+	sc->cur_chan->nvifs--;
 	sc->tx99_vif = NULL;
 	if (!ath9k_is_chanctx_enabled())
 		list_del(&avp->list);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 68e56d6..957a877 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -404,7 +404,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
-	    (sc->nvifs <= 1) &&
+	    (sc->cur_chan->nvifs <= 1) &&
 	    !(sc->cur_chan->rxfilter & FIF_BCN_PRBRESP_PROMISC))
 		rfilt |= ATH9K_RX_FILTER_MYBEACON;
 	else
@@ -417,7 +417,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->cur_chandef.width != NL80211_CHAN_WIDTH_20_NOHT)
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
 
-	if (sc->nvifs > 1 || (sc->cur_chan->rxfilter & FIF_OTHER_BSS)) {
+	if (sc->cur_chan->nvifs > 1 || (sc->cur_chan->rxfilter & FIF_OTHER_BSS)) {
 		/* This is needed for older chips */
 		if (sc->sc_ah->hw_version.macVersion <= AR_SREV_VERSION_9160)
 			rfilt |= ATH9K_RX_FILTER_PROM;
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index 2397292..8a69d08 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -174,7 +174,7 @@ static ssize_t write_file_tx99(struct file *file, const char __user *user_buf,
 	ssize_t len;
 	int r;
 
-	if (sc->nvifs > 1)
+	if (sc->cur_chan->nvifs > 1)
 		return -EOPNOTSUPP;
 
 	len = min(count, sizeof(buf) - 1);
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 33531d9..5f30e58 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -232,7 +232,7 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 		goto fail_wow;
 	}
 
-	if (sc->nvifs > 1) {
+	if (sc->cur_chan->nvifs > 1) {
 		ath_dbg(common, WOW, "WoW for multivif is not yet supported\n");
 		ret = 1;
 		goto fail_wow;
-- 
2.1.0

