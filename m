Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2HEQbx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 12:31:53 -0400
Message-ID: <1344184306.5765.0.camel@jlt3.sipsolutions.net> (sfid-20120805_183234_976708_F712B40F)
Subject: [PATCH v3.6] iwlwifi: disable greenfield transmissions as a
 workaround
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 05 Aug 2012 18:31:46 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a bug that causes the rate scaling to get stuck
when it has to use single-stream rates with a peer that
can do GF and SGI; the two are incompatible so we can't
use them together, but that causes the algorithm to not
work at all, it always rejects updates.

Disable greenfield for now to prevent that problem.

Cc: stable@vger.kernel.org
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Tested-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
John, can you apply this for 3.6 please, I forgot last
week and didn't want to prepare a pull request for a single
patch now. Thanks!

 drivers/net/wireless/iwlwifi/dvm/rs.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index 6fddd27..a82f46c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -707,11 +707,14 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
  */
 static bool rs_use_green(struct ieee80211_sta *sta)
 {
-	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct iwl_rxon_context *ctx = sta_priv->ctx;
-
-	return (sta->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
-		!(ctx->ht.non_gf_sta_present);
+	/*
+	 * There's a bug somewhere in this code that causes the
+	 * scaling to get stuck because GF+SGI can't be combined
+	 * in SISO rates. Until we find that bug, disable GF, it
+	 * has only limited benefit and we still interoperate with
+	 * GF APs since we can always receive GF transmissions.
+	 */
+	return false;
 }
 
 /**
-- 
1.7.10.4



