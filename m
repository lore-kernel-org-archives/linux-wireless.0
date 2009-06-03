Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4741 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZFCDEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 23:04:09 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, henk@god.dyndns.org
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: disable beacon interrupt when interface is down
Date: Tue,  2 Jun 2009 23:03:06 -0400
Message-Id: <1243998186-9200-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we remove the active interface, there's no need to continue
sending beacons; doing so would cause a null pointer deref in
ieee80211_beacon_get().  Disable the interrupt in remove_interface
and add a WARN_ON(!vif) in case there are other instances lurking.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index ab2048b..85a00db 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2070,6 +2070,13 @@ err_unmap:
 	return ret;
 }
 
+static void ath5k_beacon_disable(struct ath5k_softc *sc)
+{
+	sc->imask &= ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
+	ath5k_hw_set_imr(sc->ah, sc->imask);
+	ath5k_hw_stop_tx_dma(sc->ah, sc->bhalq);
+}
+
 /*
  * Transmit a beacon frame at SWBA.  Dynamic updates to the
  * frame contents are done as needed and the slot time is
@@ -2757,6 +2764,7 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
 		goto end;
 
 	ath5k_hw_set_lladdr(sc->ah, mac);
+	ath5k_beacon_disable(sc);
 	sc->vif = NULL;
 end:
 	mutex_unlock(&sc->lock);
@@ -3060,7 +3068,14 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	int ret;
 	struct ath5k_softc *sc = hw->priv;
-	struct sk_buff *skb = ieee80211_beacon_get(hw, vif);
+	struct sk_buff *skb;
+
+	if (WARN_ON(!vif)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	skb = ieee80211_beacon_get(hw, vif);
 
 	if (!skb) {
 		ret = -ENOMEM;
-- 
1.6.0.6


