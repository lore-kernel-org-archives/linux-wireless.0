Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab3A2Jzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 04:55:37 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: remove assoc data "sent_assoc"
Date: Tue, 29 Jan 2013 10:55:58 +0100
Message-Id: <1359453359-20767-1-git-send-email-johannes@sipsolutions.net> (sfid-20130129_105542_708903_6DD77997)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The field is never used, so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 1 -
 net/mac80211/mlme.c        | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index fdb0d3c..0f3e4b1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -400,7 +400,6 @@ struct ieee80211_mgd_assoc_data {
 	u8 supp_rates_len;
 	bool wmm, uapsd;
 	bool have_beacon;
-	bool sent_assoc;
 	bool synced;
 
 	u8 ap_ht_param;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5f7fd43..eda80b1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2578,7 +2578,6 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 		ifmgd->assoc_data->have_beacon = true;
-		ifmgd->assoc_data->sent_assoc = false;
 		/* continue assoc process */
 		ifmgd->assoc_data->timeout = jiffies;
 		run_again(ifmgd, ifmgd->assoc_data->timeout);
@@ -3993,13 +3992,11 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 				ifmgd->dtim_period = tim->dtim_period;
 			}
 			assoc_data->have_beacon = true;
-			assoc_data->sent_assoc = false;
 			assoc_data->timeout = jiffies;
 		}
 		rcu_read_unlock();
 	} else {
 		assoc_data->have_beacon = true;
-		assoc_data->sent_assoc = false;
 		assoc_data->timeout = jiffies;
 	}
 	run_again(ifmgd, assoc_data->timeout);
-- 
1.8.0

