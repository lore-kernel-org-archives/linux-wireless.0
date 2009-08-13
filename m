Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:3757 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405AbZHMUbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/13] iwlwifi: remove unused members of iwl_ht_info
Date: Thu, 13 Aug 2009 13:30:55 -0700
Message-Id: <1250195462-15811-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
References: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Some members of iwl_ht_info are unused, and one of
them is write-only, so we can remove these three:
max_amsdu_size, ampdu_factor and mpdu_density.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    3 ---
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 479b7e1..08345b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2397,8 +2397,6 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 		iwl_conf->sgf |= HT_SHORT_GI_40MHZ;
 
 	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
-	iwl_conf->max_amsdu_size =
-		!!(ht_conf->cap & IEEE80211_HT_CAP_MAX_AMSDU);
 
 	iwl_conf->supported_chan_width =
 		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0b19a6f..db74534 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -509,9 +509,6 @@ struct iwl_ht_info {
 	u8 sm_ps;
 	u8 is_green_field;
 	u8 sgf;			/* HT_SHORT_GI_* short guard interval */
-	u8 max_amsdu_size;
-	u8 ampdu_factor;
-	u8 mpdu_density;
 	struct ieee80211_mcs_info mcs;
 	/* BSS related data */
 	u8 extension_chan_offset;
-- 
1.5.6.3

