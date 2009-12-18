Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44211 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163AbZLRQ0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 11:26:07 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Peter Stuge <peter@stuge.se>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: [PATCH] ath9k: re-enable ps by default for new single chip families
Date: Fri, 18 Dec 2009 11:26:04 -0500
Message-Id: <1261153564-17430-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The newer single chip hardware family of chipsets have not been
experiencing issues with power saving set by default with recent
fixes merged (even into stable). The remaining issues are only
reported with AR5416 and since enabling PS by default can increase
power savings considerably best to take advantage of that feature
as this has been tested properly.

For more details on this issue see the bug report:

http://bugzilla.kernel.org/show_bug.cgi?id=14267

We leave AR5416 with PS disabled by default, that seems to require
some more work.

Cc: stable@kernel.org
Cc: Peter Stuge <peter@stuge.se>
Cc: Justin P. Mattock  <justinmattock@gmail.com>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c487434..7d96d76 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1848,6 +1848,8 @@ bad_free_hw:
 
 void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
+	struct ath_hw *ah = sc->sc_ah;
+
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
@@ -1865,7 +1867,8 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
-	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	if (AR_SREV_5416(ah))
+		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->queues = 4;
 	hw->max_rates = 4;
-- 
1.6.3.3

