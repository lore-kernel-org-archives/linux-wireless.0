Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933003Ab3BOPqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 10:46:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/5] cfg80211: constify station parameter pointers
Date: Fri, 15 Feb 2013 16:46:31 +0100
Message-Id: <1360943194-14810-3-git-send-email-johannes@sipsolutions.net> (sfid-20130215_164649_484170_15C4875D)
In-Reply-To: <1360943194-14810-1-git-send-email-johannes@sipsolutions.net>
References: <1360943194-14810-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All the pointers point right into the skb data and
not to anything that would be useful to change, so
make them const.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2d60db9..4b3b614 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -658,7 +658,7 @@ enum station_parameters_apply_mask {
  * @ext_capab_len: number of extended capabilities
  */
 struct station_parameters {
-	u8 *supported_rates;
+	const u8 *supported_rates;
 	struct net_device *vlan;
 	u32 sta_flags_mask, sta_flags_set;
 	u32 sta_modify_mask;
@@ -667,13 +667,13 @@ struct station_parameters {
 	u8 supported_rates_len;
 	u8 plink_action;
 	u8 plink_state;
-	struct ieee80211_ht_cap *ht_capa;
-	struct ieee80211_vht_cap *vht_capa;
+	const struct ieee80211_ht_cap *ht_capa;
+	const struct ieee80211_vht_cap *vht_capa;
 	u8 uapsd_queues;
 	u8 max_sp;
 	enum nl80211_mesh_power_mode local_pm;
 	u16 capability;
-	u8 *ext_capab;
+	const u8 *ext_capab;
 	u8 ext_capab_len;
 };
 
-- 
1.8.0

