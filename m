Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab0G0UdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 16:33:12 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] ath9k: remove the two wiphys scanning at the same time message
Date: Tue, 27 Jul 2010 16:33:06 -0400
Message-Id: <1280262788-9890-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1280262788-9890-1-git-send-email-lrodriguez@atheros.com>
References: <1280262788-9890-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When issuing two consecutive scans you could often end up
getting in the logs:

"ath9k: Two wiphys trying to scan at the same time"

This message is due to a race in mac80211 but addressing
that race requires some more major changes on the driver
and perhaps optimizations on mac80211 like removing the
scan complete callback alltogether. Its too late to address
this this kernel release so supress the complaint and annotate
this needs fixing for later.

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6cf0410..0429dda 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1994,11 +1994,12 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 
 	mutex_lock(&sc->mutex);
 	if (ath9k_wiphy_scanning(sc)) {
-		printk(KERN_DEBUG "ath9k: Two wiphys trying to scan at the "
-		       "same time\n");
 		/*
-		 * Do not allow the concurrent scanning state for now. This
-		 * could be improved with scanning control moved into ath9k.
+		 * There is a race here in mac80211 but fixing it requires
+		 * we revisit how we handle the scan complete callback.
+		 * After mac80211 fixes we will not have configured hardware
+		 * to the home channel nor would we have configured the RX
+		 * filter yet.
 		 */
 		mutex_unlock(&sc->mutex);
 		return;
@@ -2014,6 +2015,10 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 	mutex_unlock(&sc->mutex);
 }
 
+/*
+ * XXX: this requires a revisit after the driver
+ * scan_complete gets moved to another place/removed in mac80211.
+ */
 static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
-- 
1.7.0.4

