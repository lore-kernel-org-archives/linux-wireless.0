Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2180 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab0HORNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 13:13:16 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 5/6] ath5k: remove all mention of monitor iftype
Date: Sun, 15 Aug 2010 13:03:14 -0400
Message-Id: <1281891795-14718-6-git-send-email-me@bobcopeland.com>
In-Reply-To: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
References: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Monitor interfaces are never seen by the driver so these
cases are never reached.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 03808b8..e60b148 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2325,8 +2325,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 
 	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "in beacon_send\n");
 
-	if (unlikely(bf->skb == NULL || sc->opmode == NL80211_IFTYPE_STATION ||
-			sc->opmode == NL80211_IFTYPE_MONITOR)) {
+	if (unlikely(bf->skb == NULL || sc->opmode == NL80211_IFTYPE_STATION)) {
 		ATH5K_WARN(sc, "bf=%p bf_skb=%p\n", bf, bf ? bf->skb : NULL);
 		return;
 	}
@@ -2900,9 +2899,6 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
 
-	if (sc->opmode == NL80211_IFTYPE_MONITOR)
-		ATH5K_DBG(sc, ATH5K_DEBUG_XMIT, "tx in monitor (scan?)\n");
-
 	/*
 	 * The hardware expects the header padded to 4 byte boundaries.
 	 * If this is not the case, we add the padding after the header.
@@ -3048,7 +3044,6 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
-	case NL80211_IFTYPE_MONITOR:
 		sc->opmode = vif->type;
 		break;
 	default:
@@ -3250,7 +3245,6 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 
 	switch (sc->opmode) {
 	case NL80211_IFTYPE_MESH_POINT:
-	case NL80211_IFTYPE_MONITOR:
 		rfilt |= AR5K_RX_FILTER_CONTROL |
 			 AR5K_RX_FILTER_BEACON |
 			 AR5K_RX_FILTER_PROBEREQ |
-- 
1.7.1.1


