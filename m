Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab2EJQF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 12:05:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Subject: [PATCH 3/4] iwlwifi: fix debug print in iwl_sta_calc_ht_flags
Date: Thu, 10 May 2012 18:05:51 +0200
Message-Id: <1336665952-24363-4-git-send-email-johannes@sipsolutions.net> (sfid-20120510_180605_419443_31D8604B)
In-Reply-To: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

We missed passing an argument to the
debug print. Fix it.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 67e6f1d..76c1f72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -236,6 +236,7 @@ static void iwl_sta_calc_ht_flags(struct iwl_priv *priv,
 	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_SM_PS) >> 2;
 
 	IWL_DEBUG_INFO(priv, "STA %pM SM PS mode: %s\n",
+			sta->addr,
 			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_STATIC) ?
 			"static" :
 			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_DYNAMIC) ?
-- 
1.7.10

