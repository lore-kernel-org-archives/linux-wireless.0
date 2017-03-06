Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52938 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750940AbdCFWIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 17:08:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] iwlwifi: dvm: remove usage of txrc->max_rate_idx
Date: Mon,  6 Mar 2017 23:07:12 +0100
Message-Id: <20170306220713.14499-2-johannes@sipsolutions.net> (sfid-20170306_230809_477068_835A01D7)
In-Reply-To: <20170306220713.14499-1-johannes@sipsolutions.net>
References: <20170306220713.14499-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just calculate it like mac80211 does today, so we can get rid
of the calculation in mac80211 for everyone else.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index ff44ebc5829d..ddcd8c2d66cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -2720,7 +2720,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 
 	/* Get max rate if user set max rate */
 	if (lq_sta) {
-		lq_sta->max_rate_idx = txrc->max_rate_idx;
+		lq_sta->max_rate_idx = fls(txrc->rate_idx_mask) - 1;
 		if ((sband->band == NL80211_BAND_5GHZ) &&
 		    (lq_sta->max_rate_idx != -1))
 			lq_sta->max_rate_idx += IWL_FIRST_OFDM_RATE;
-- 
2.11.0
