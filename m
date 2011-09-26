Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59815 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1IZQqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 12:46:16 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: Remove redundant my beacon check at ath_rx_ps_beacon
Date: Mon, 26 Sep 2011 22:16:56 +0530
Message-ID: <1317055616-11729-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110926_184619_836687_41F542FC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make use of the rx status's is_mybeacon in order to avoid
redundant memcmp.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index bcc0b22..655d0b2 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -578,22 +578,11 @@ static bool ath_beacon_dtim_pending_cab(struct sk_buff *skb)
 
 static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 {
-	struct ieee80211_mgmt *mgmt;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	if (skb->len < 24 + 8 + 2 + 2)
 		return;
 
-	mgmt = (struct ieee80211_mgmt *)skb->data;
-	if (memcmp(common->curbssid, mgmt->bssid, ETH_ALEN) != 0) {
-		/* TODO:  This doesn't work well if you have stations
-		 * associated to two different APs because curbssid
-		 * is just the last AP that any of the stations associated
-		 * with.
-		 */
-		return; /* not from our current AP */
-	}
-
 	sc->ps_flags &= ~PS_WAIT_FOR_BEACON;
 
 	if (sc->ps_flags & PS_BEACON_SYNC) {
@@ -629,7 +618,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 	}
 }
 
-static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
+static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb, bool mybeacon)
 {
 	struct ieee80211_hdr *hdr;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -638,7 +627,7 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 
 	/* Process Beacon and CAB receive in PS state */
 	if (((sc->ps_flags & PS_WAIT_FOR_BEACON) || ath9k_check_auto_sleep(sc))
-	    && ieee80211_is_beacon(hdr->frame_control))
+	    && mybeacon)
 		ath_rx_ps_beacon(sc, skb);
 	else if ((sc->ps_flags & PS_WAIT_FOR_CAB) &&
 		 (ieee80211_is_data(hdr->frame_control) ||
@@ -1944,10 +1933,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		spin_lock_irqsave(&sc->sc_pm_lock, flags);
 
 		if ((sc->ps_flags & (PS_WAIT_FOR_BEACON |
-					      PS_WAIT_FOR_CAB |
-					      PS_WAIT_FOR_PSPOLL_DATA)) ||
-						ath9k_check_auto_sleep(sc))
-			ath_rx_ps(sc, skb);
+				     PS_WAIT_FOR_CAB |
+				     PS_WAIT_FOR_PSPOLL_DATA)) ||
+		    ath9k_check_auto_sleep(sc))
+			ath_rx_ps(sc, skb, rs.is_mybeacon);
 		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
 		if ((ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) && sc->ant_rx == 3)
-- 
1.7.6.4

