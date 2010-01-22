Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59035 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088Ab0AVWXP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 17/17] iwlwifi: fix throughput degradation in aggregation mode
Date: Fri, 22 Jan 2010 14:22:58 -0800
Message-Id: <1264198978-5915-18-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

The following commit

	commit e4da8c37af626001ff704fb29ea14eb58f5f7208
	Author: Johannes Berg <johannes@sipsolutions.net>
	Date:   Wed Dec 23 13:15:43 2009 +0100

	   mac80211: make off-channel work generic

triggered a bug in iwlwifi where HT parameters would not be correctly set in
some mac80211 pathways. The aggregation (and possibly other) station flags were
not being set, which limited the size of aggregation blocks and reduced
throughput at high rates.

>From Johannes:
"""
Due to Wey-Yi's patch to use the set-channel command when the channel changes
while associated, we don't get a full new RXON. Therefore, we don't re-set the
rxon-station either. However, under some circumstances that apparently have
gotten more likely mac80211 will first set up the BSS info, then add the
station and then switch to an HT channel type.

Therefore, the check for "priv->current_ht_config.is_ht" in
iwl_rxon_add_station() will hit false and not fill in the HT information.

However, that check can just be removed, which is the easiest fix for all this,
because the HT capa struct is always there, just could possibly have the
ht_supported member set to false.
"""

A sample good link in my 3x3 network improves by approximately 25% TCP
throughput. This fixes Bug 2144
(http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2144).

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index fcac73c..e0b13fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1045,24 +1045,19 @@ int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 	struct ieee80211_sta_ht_cap *cur_ht_config = NULL;
 	u8 sta_id;
 
-	/* Add station to device's station table */
-
 	/*
-	 * XXX: This check is definitely not correct, if we're an AP
-	 *	it'll always be false which is not what we want, but
-	 *	it doesn't look like iwlagn is prepared to be an HT
-	 *	AP anyway.
+	 * Set HT capabilities. It is ok to set this struct even if not using
+	 * HT config: the priv->current_ht_config.is_ht flag will just be false
 	 */
-	if (priv->current_ht_config.is_ht) {
-		rcu_read_lock();
-		sta = ieee80211_find_sta(priv->vif, addr);
-		if (sta) {
-			memcpy(&ht_config, &sta->ht_cap, sizeof(ht_config));
-			cur_ht_config = &ht_config;
-		}
-		rcu_read_unlock();
+	rcu_read_lock();
+	sta = ieee80211_find_sta(priv->vif, addr);
+	if (sta) {
+		memcpy(&ht_config, &sta->ht_cap, sizeof(ht_config));
+		cur_ht_config = &ht_config;
 	}
+	rcu_read_unlock();
 
+	/* Add station to device's station table */
 	sta_id = iwl_add_station(priv, addr, is_ap, CMD_SYNC, cur_ht_config);
 
 	/* Set up default rate scaling table in device's station table */
-- 
1.6.3.3

