Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58671 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbZESVuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 17:50:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/3] cfg80211: warn when wiphy_apply_custom_regulatory() does nothing
Date: Tue, 19 May 2009 17:49:47 -0400
Message-Id: <1242769787-29467-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1242769787-29467-1-git-send-email-lrodriguez@atheros.com>
References: <1242769787-29467-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Device drivers using wiphy_apply_custom_regulatory() want some
regulatory settings applied to their wiphy, if no bands were
configured on the wiphy then something went wrong.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 48db569..0eac285 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1342,13 +1342,22 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 				   const struct ieee80211_regdomain *regd)
 {
 	enum ieee80211_band band;
+	unsigned int bands_set = 0;
 
 	mutex_lock(&cfg80211_mutex);
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-		if (wiphy->bands[band])
-			handle_band_custom(wiphy, band, regd);
+		if (!wiphy->bands[band])
+			continue;
+		handle_band_custom(wiphy, band, regd);
+		bands_set++;
 	}
 	mutex_unlock(&cfg80211_mutex);
+
+	/*
+	 * no point in calling this if it won't have any effect
+	 * on your device's supportd bands.
+	 */
+	WARN_ON(!bands_set);
 }
 EXPORT_SYMBOL(wiphy_apply_custom_regulatory);
 
-- 
1.6.0.6

