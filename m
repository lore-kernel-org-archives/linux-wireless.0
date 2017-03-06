Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52934 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753140AbdCFWIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 17:08:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] iwlegacy: remove usage of txrc->max_rate_idx
Date: Mon,  6 Mar 2017 23:07:11 +0100
Message-Id: <20170306220713.14499-1-johannes@sipsolutions.net> (sfid-20170306_230822_379170_B6D3E1A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just calculate it like mac80211 does today, so we can get rid
of the calculation in mac80211 for everyone else.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlegacy/3945-rs.c | 2 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-rs.c b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
index 03ad9b8b55f4..b2f35dfbc01b 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
@@ -656,7 +656,7 @@ il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 	rate_mask = sta->supp_rates[sband->band];
 
 	/* get user max rate if set */
-	max_rate_idx = txrc->max_rate_idx;
+	max_rate_idx = fls(txrc->rate_idx_mask) - 1;
 	if (sband->band == NL80211_BAND_5GHZ && max_rate_idx != -1)
 		max_rate_idx += IL_FIRST_OFDM_RATE;
 	if (max_rate_idx < 0 || max_rate_idx >= RATE_COUNT)
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index a867ae7f4095..c055f6da11c6 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2211,7 +2211,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 
 	/* Get max rate if user set max rate */
 	if (lq_sta) {
-		lq_sta->max_rate_idx = txrc->max_rate_idx;
+		lq_sta->max_rate_idx = fls(txrc->rate_idx_mask) - 1;
 		if (sband->band == NL80211_BAND_5GHZ &&
 		    lq_sta->max_rate_idx != -1)
 			lq_sta->max_rate_idx += IL_FIRST_OFDM_RATE;
-- 
2.11.0
