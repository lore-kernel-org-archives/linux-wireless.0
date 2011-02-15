Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4626 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab1BOOUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 09:20:51 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] ath5k: move external function definitions to a header file
Date: Tue, 15 Feb 2011 09:19:28 -0500
Message-Id: <1297779568-32166-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes pointed out the mess of external function prototypes in the
mac80211-ops.c file.  Woe to anyone who changes these functions...

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/ath5k/ath5k.h        |   20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |   17 -----------------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index e43175a..70abb61 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1158,6 +1158,26 @@ void ath5k_hw_deinit(struct ath5k_hw *ah);
 int ath5k_sysfs_register(struct ath5k_softc *sc);
 void ath5k_sysfs_unregister(struct ath5k_softc *sc);
 
+/* base.c */
+struct ath5k_buf;
+struct ath5k_txq;
+
+void set_beacon_filter(struct ieee80211_hw *hw, bool enable);
+bool ath_any_vif_assoc(struct ath5k_softc *sc);
+int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
+		   struct ath5k_txq *txq);
+int ath5k_init_hw(struct ath5k_softc *sc);
+int ath5k_stop_hw(struct ath5k_softc *sc);
+void ath5k_mode_setup(struct ath5k_softc *sc, struct ieee80211_vif *vif);
+void ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
+					struct ieee80211_vif *vif);
+int ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan);
+void ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf);
+int ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
+void ath5k_beacon_config(struct ath5k_softc *sc);
+void ath5k_txbuf_free_skb(struct ath5k_softc *sc, struct ath5k_buf *bf);
+void ath5k_rxbuf_free_skb(struct ath5k_softc *sc, struct ath5k_buf *bf);
+
 /*Chip id helper functions */
 const char *ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val);
 int ath5k_hw_read_srev(struct ath5k_hw *ah);
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 36a5199..a60a726 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -48,23 +48,6 @@
 
 extern int ath5k_modparam_nohwcrypt;
 
-/* functions used from base.c */
-void set_beacon_filter(struct ieee80211_hw *hw, bool enable);
-bool ath_any_vif_assoc(struct ath5k_softc *sc);
-int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
-		   struct ath5k_txq *txq);
-int ath5k_init_hw(struct ath5k_softc *sc);
-int ath5k_stop_hw(struct ath5k_softc *sc);
-void ath5k_mode_setup(struct ath5k_softc *sc, struct ieee80211_vif *vif);
-void ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
-					struct ieee80211_vif *vif);
-int ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan);
-void ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf);
-int ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
-void ath5k_beacon_config(struct ath5k_softc *sc);
-void ath5k_txbuf_free_skb(struct ath5k_softc *sc, struct ath5k_buf *bf);
-void ath5k_rxbuf_free_skb(struct ath5k_softc *sc, struct ath5k_buf *bf);
-
 /********************\
 * Mac80211 functions *
 \********************/
-- 
1.5.6.5


