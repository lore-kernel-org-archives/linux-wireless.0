Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:43100 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab1AIQw2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 11:52:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 09 Jan 2011 08:52:11 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>, Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: [PATCH] ath9k: set hw opmode while changing interface type
Date: Sun, 9 Jan 2011 22:21:28 +0530
Message-ID: <1294591888-16625-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k: Add change_interface callback" is
failed to set hw opmode while changing interface type
on runtime. Not setting opmode fails to generate
beacons on changing to AP mode.

Cc: stable@kernel.org
Cc: Jouni Malinen <Jouni.Malinen@Atheros.com>
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    1 +
 drivers/net/wireless/ath/ath9k/main.c   |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 385ba03..efa573b 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -338,6 +338,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 			sc->beacon.bslot[avp->av_bslot] = NULL;
 			sc->beacon.bslot_aphy[avp->av_bslot] = NULL;
 			sc->nbcnvifs--;
+			avp->av_bslot = -1;
 		}
 
 		bf = avp->av_bcbuf;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f90a6ca..648a761 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1456,6 +1456,8 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int ret = 0;
 
@@ -1470,6 +1472,7 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 			ret = -ENOBUFS;
 			goto out;
 		}
+		sc->sc_flags |= SC_OP_TSF_RESET;
 		break;
 	case NL80211_IFTYPE_STATION:
 		/* Stop ANI */
@@ -1488,6 +1491,7 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	vif->type = new_type;
 	vif->p2p = p2p;
 
+	ah->opmode = avp->av_opmode = new_type;
 out:
 	mutex_unlock(&sc->mutex);
 	return ret;
-- 
1.7.3.5

