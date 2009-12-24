Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZLXBDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 20:03:30 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH 4/5] ath9k: wake hardware for interface IBSS/AP/Mesh removal
Date: Wed, 23 Dec 2009 20:03:28 -0500
Message-Id: <1261616609-518-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1261616609-518-1-git-send-email-lrodriguez@atheros.com>
References: <1261616609-518-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we remove a IBSS/AP/Mesh interface we stop DMA
but to do this we should ensure hardware is on. Awaken
the device prior to these calls. This should ensure
DMA is stopped upon suspend and plain device removal.

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1464ded..9a4d9b9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2643,8 +2643,10 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT)) {
+		ath9k_ps_wakeup(sc);
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 		ath_beacon_return(sc, avp);
+		ath9k_ps_restore(sc);
 	}
 
 	sc->sc_flags &= ~SC_OP_BEACONS;
-- 
1.6.3.3

