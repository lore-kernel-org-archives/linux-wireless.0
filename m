Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:52090 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZFSKRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 06:17:46 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] ath9k: remove ath_rx_ps_back_to_sleep helper
Date: Fri, 19 Jun 2009 12:17:48 +0200
Message-Id: <1245406668-4715-2-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1245406668-4715-1-git-send-email-juhosg@openwrt.org>
References: <1245406668-4715-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helper only clears the SC_OP_WAIT_FOR_{BEACON,CAB} flags.
Remove it and clear these flags directly in the approptiate
places instead.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a681f88..065aa0f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -505,11 +505,6 @@ static bool ath_beacon_dtim_pending_cab(struct sk_buff *skb)
 	return false;
 }
 
-static void ath_rx_ps_back_to_sleep(struct ath_softc *sc)
-{
-	sc->sc_flags &= ~(SC_OP_WAIT_FOR_BEACON | SC_OP_WAIT_FOR_CAB);
-}
-
 static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt;
@@ -521,6 +516,8 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 	if (memcmp(sc->curbssid, mgmt->bssid, ETH_ALEN) != 0)
 		return; /* not from our current AP */
 
+	sc->sc_flags &= ~SC_OP_WAIT_FOR_BEACON;
+
 	if (sc->sc_flags & SC_OP_BEACON_SYNC) {
 		sc->sc_flags &= ~SC_OP_BEACON_SYNC;
 		DPRINTF(sc, ATH_DBG_PS, "Reconfigure Beacon timers based on "
@@ -545,11 +542,9 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		 * fails to send a frame indicating that all CAB frames have
 		 * been delivered.
 		 */
+		sc->sc_flags &= ~SC_OP_WAIT_FOR_CAB;
 		DPRINTF(sc, ATH_DBG_PS, "PS wait for CAB frames timed out\n");
 	}
-
-	/* No more broadcast/multicast frames to be received at this point. */
-	ath_rx_ps_back_to_sleep(sc);
 }
 
 static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
@@ -567,13 +562,13 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 		  ieee80211_is_action(hdr->frame_control)) &&
 		 is_multicast_ether_addr(hdr->addr1) &&
 		 !ieee80211_has_moredata(hdr->frame_control)) {
-		DPRINTF(sc, ATH_DBG_PS, "All PS CAB frames received, back to "
-			"sleep\n");
 		/*
 		 * No more broadcast/multicast frames to be received at this
 		 * point.
 		 */
-		ath_rx_ps_back_to_sleep(sc);
+		sc->sc_flags &= ~SC_OP_WAIT_FOR_CAB;
+		DPRINTF(sc, ATH_DBG_PS, "All PS CAB frames received, back to "
+			"sleep\n");
 	} else if ((sc->sc_flags & SC_OP_WAIT_FOR_PSPOLL_DATA) &&
 		   !is_multicast_ether_addr(hdr->addr1) &&
 		   !ieee80211_has_morefrags(hdr->frame_control)) {
-- 
1.5.3.2

