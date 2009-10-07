Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35349 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758472AbZJGApL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 20:45:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 7/7] ath5k: enable Power-Save Polls by setting the association ID
Date: Tue,  6 Oct 2009 20:44:34 -0400
Message-Id: <1254876274-1145-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
References: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 has long provided us the association ID. This isn't useful except
for Power-Save polling which now gets enabled. We can now poll for our
pending frames on the AP during power save.

You can review the details of Power-Save on the wireless wiki:

http://wireless.kernel.org/en/developers/Documentation/ieee80211/power-savings

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/base.c  |   11 +++++++++--
 drivers/net/wireless/ath/ath5k/reset.c |    1 -
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 01da83d..07c1e52 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3211,8 +3211,7 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 	if (changes & BSS_CHANGED_BSSID) {
 		/* Cache for later use during resets */
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
-		/* XXX: assoc id is set to 0 for now, mac80211 doesn't have
-		 * a clean way of letting us retrieve this yet. */
+		common->curaid = 0;
 		ath5k_hw_set_associd(ah);
 		mmiowb();
 	}
@@ -3226,6 +3225,14 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 			set_beacon_filter(hw, sc->assoc);
 		ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
 			AR5K_LED_ASSOC : AR5K_LED_INIT);
+		if (bss_conf->assoc) {
+			ATH5K_DBG(sc, ATH5K_DEBUG_ANY,
+				  "Bss Info ASSOC %d, bssid: %pM\n",
+				  bss_conf->aid, common->curbssid);
+			common->curaid = bss_conf->aid;
+			ath5k_hw_set_associd(ah);
+			/* Once ANI is available you would start it here */
+		}
 	}
 
 	if (changes & BSS_CHANGED_BEACON) {
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index fb89815..3dab3d8 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1187,7 +1187,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 */
 
 	/* Restore bssid and bssid mask */
-	/* XXX: add ah->aid once mac80211 gives this to us */
 	ath5k_hw_set_associd(ah);
 
 	/* Set PCU config */
-- 
1.6.0.4

