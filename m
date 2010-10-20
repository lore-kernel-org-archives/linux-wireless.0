Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33434 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab0JTRTE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 13:19:04 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 10:18:54 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <easwar.krishnan@atheros.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>
Subject: [PATCH 1/7] cfg80211: pass the reg hint initiator to helpers
Date: Wed, 20 Oct 2010 10:18:53 -0700
Message-ID: <1287595139-10761-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
References: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is required later.

Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
Cc: stable@kernel.org
signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4b9f891..b64596f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -720,7 +720,9 @@ EXPORT_SYMBOL(freq_reg_info);
  * on the wiphy with the target_bw specified. Then we can simply use
  * that below for the desired_bw_khz below.
  */
-static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
+static void handle_channel(struct wiphy *wiphy,
+			   enum nl80211_reg_initiator initiator,
+			   enum ieee80211_band band,
 			   unsigned int chan_idx)
 {
 	int r;
@@ -784,7 +786,9 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 		chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 }
 
-static void handle_band(struct wiphy *wiphy, enum ieee80211_band band)
+static void handle_band(struct wiphy *wiphy,
+			enum ieee80211_band band,
+			enum nl80211_reg_initiator initiator)
 {
 	unsigned int i;
 	struct ieee80211_supported_band *sband;
@@ -793,7 +797,7 @@ static void handle_band(struct wiphy *wiphy, enum ieee80211_band band)
 	sband = wiphy->bands[band];
 
 	for (i = 0; i < sband->n_channels; i++)
-		handle_channel(wiphy, band, i);
+		handle_channel(wiphy, initiator, band, i);
 }
 
 static bool ignore_reg_update(struct wiphy *wiphy,
@@ -1030,7 +1034,7 @@ void wiphy_update_regulatory(struct wiphy *wiphy,
 		goto out;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
-			handle_band(wiphy, band);
+			handle_band(wiphy, band, initiator);
 	}
 out:
 	reg_process_beacons(wiphy);
-- 
1.7.0.4

