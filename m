Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:55226 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759243Ab0EMShc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 14:37:32 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 1/2] ath9k: change beacon allocation to prefer the first beacon slot
Date: Thu, 13 May 2010 20:37:24 +0200
Message-Id: <1273775845-10056-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes IBSS beacon transmissions without VEOL enabled

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index c8a4558..77face7 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -274,17 +274,11 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 			avp->av_bslot = 0;
 			for (slot = 0; slot < ATH_BCBUF; slot++)
 				if (sc->beacon.bslot[slot] == NULL) {
-					/*
-					 * XXX hack, space out slots to better
-					 * deal with misses
-					 */
-					if (slot+1 < ATH_BCBUF &&
-					    sc->beacon.bslot[slot+1] == NULL) {
-						avp->av_bslot = slot+1;
-						break;
-					}
 					avp->av_bslot = slot;
+
 					/* NB: keep looking for a double slot */
+					if (slot == 0 || !sc->beacon.bslot[slot-1])
+						break;
 				}
 			BUG_ON(sc->beacon.bslot[avp->av_bslot] != NULL);
 			sc->beacon.bslot[avp->av_bslot] = vif;
-- 
1.6.4.2

