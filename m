Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46986 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbZH0Xe6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 19:34:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/2] mac80211: initialize rate control after station inserted
Date: Thu, 27 Aug 2009 16:34:54 -0700
Message-Id: <1251416094-10420-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
References: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Station information may be needed by rate control algorithms, so call rate
scaling initialization after adding the station.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 net/mac80211/ibss.c |    3 ++-
 net/mac80211/mlme.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 920ec87..040d184 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -413,11 +413,12 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
-	rate_control_rate_init(sta);
 
 	if (sta_info_insert(sta))
 		return NULL;
 
+	rate_control_rate_init(sta);
+
 	return sta;
 }
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 97a278a..307b33c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1554,8 +1554,6 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 
 	ap_ht_cap_flags = sta->sta.ht_cap.cap;
 
-	rate_control_rate_init(sta);
-
 	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
 		set_sta_flags(sta, WLAN_STA_MFP);
 
@@ -1572,6 +1570,8 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	rate_control_rate_init(sta);
+
 	rcu_read_unlock();
 
 	if (elems.wmm_param)
-- 
1.5.6.3

