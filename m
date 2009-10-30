Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57327 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbZJ3VgQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/15] iwlagn: move rate scale initialization to init function
Date: Fri, 30 Oct 2009 14:36:14 -0700
Message-Id: <1256938578-9638-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

This fits better in how the callbacks operate (alloc does allocation and
init does initialization). This also helps if we later want to do our own
initialization without relying on the mac80211 allocation.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 27d4ece..43edd8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2477,19 +2477,12 @@ static void *rs_alloc_sta(void *priv_rate, struct ieee80211_sta *sta,
 	struct iwl_lq_sta *lq_sta;
 	struct iwl_station_priv *sta_priv = (struct iwl_station_priv *) sta->drv_priv;
 	struct iwl_priv *priv;
-	int i, j;
 
 	priv = (struct iwl_priv *)priv_rate;
 	IWL_DEBUG_RATE(priv, "create station rate scale window\n");
 
 	lq_sta = &sta_priv->lq_sta;
 
-	lq_sta->lq.sta_id = 0xff;
-
-	for (j = 0; j < LQ_SIZE; j++)
-		for (i = 0; i < IWL_RATE_COUNT; i++)
-			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
-
 	return lq_sta;
 }
 
@@ -2502,6 +2495,12 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	struct iwl_lq_sta *lq_sta = priv_sta;
 
+	lq_sta->lq.sta_id = 0xff;
+
+	for (j = 0; j < LQ_SIZE; j++)
+		for (i = 0; i < IWL_RATE_COUNT; i++)
+			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
+
 	lq_sta->flush_timer = 0;
 	lq_sta->supp_rates = sta->supp_rates[sband->band];
 	for (j = 0; j < LQ_SIZE; j++)
-- 
1.5.6.3

