Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab2G0LRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 08/20] mac80211: mesh: don't use global channel type
Date: Fri, 27 Jul 2012 13:16:44 +0200
Message-Id: <1343387816-9414-9-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131731_129507_4BDCA4CB)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using local->_oper_channel_type in the mesh code is
completely wrong as this value is the combination
of the various interface channel types and can be
a different value from the mesh interface in case
there are multiple virtual interfaces.

Use sdata->vif.bss_conf.channel_type instead as it
tracks the per-vif channel type.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.c       |   11 ++++++-----
 net/mac80211/mesh_plink.c |    7 ++++---
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e6d1788..62d93ab 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -109,11 +109,11 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 
 	/* Disallow HT40+/- mismatch */
 	if (ie->ht_operation &&
-	    (local->_oper_channel_type == NL80211_CHAN_HT40MINUS ||
-	    local->_oper_channel_type == NL80211_CHAN_HT40PLUS) &&
+	    (sdata->vif.bss_conf.channel_type == NL80211_CHAN_HT40MINUS ||
+	     sdata->vif.bss_conf.channel_type == NL80211_CHAN_HT40PLUS) &&
 	    (sta_channel_type == NL80211_CHAN_HT40MINUS ||
 	     sta_channel_type == NL80211_CHAN_HT40PLUS) &&
-	    local->_oper_channel_type != sta_channel_type)
+	    sdata->vif.bss_conf.channel_type != sta_channel_type)
 		goto mismatch;
 
 	return true;
@@ -375,7 +375,7 @@ int mesh_add_ht_cap_ie(struct sk_buff *skb,
 
 	sband = local->hw.wiphy->bands[local->oper_channel->band];
 	if (!sband->ht_cap.ht_supported ||
-	    local->_oper_channel_type == NL80211_CHAN_NO_HT)
+	    sdata->vif.bss_conf.channel_type == NL80211_CHAN_NO_HT)
 		return 0;
 
 	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_ht_cap))
@@ -392,7 +392,8 @@ int mesh_add_ht_oper_ie(struct sk_buff *skb,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_channel *channel = local->oper_channel;
-	enum nl80211_channel_type channel_type = local->_oper_channel_type;
+	enum nl80211_channel_type channel_type =
+				sdata->vif.bss_conf.channel_type;
 	struct ieee80211_supported_band *sband =
 				local->hw.wiphy->bands[channel->band];
 	struct ieee80211_sta_ht_cap *ht_cap = &sband->ht_cap;
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 6df9fc0..a203166 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -117,7 +117,7 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 	u16 ht_opmode;
 	bool non_ht_sta = false, ht20_sta = false;
 
-	if (local->_oper_channel_type == NL80211_CHAN_NO_HT)
+	if (sdata->vif.bss_conf.channel_type == NL80211_CHAN_NO_HT)
 		return 0;
 
 	rcu_read_lock();
@@ -147,7 +147,8 @@ out:
 
 	if (non_ht_sta)
 		ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED;
-	else if (ht20_sta && local->_oper_channel_type > NL80211_CHAN_HT20)
+	else if (ht20_sta &&
+		 sdata->vif.bss_conf.channel_type > NL80211_CHAN_HT20)
 		ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_20MHZ;
 	else
 		ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
@@ -370,7 +371,7 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 
 	sta->sta.supp_rates[band] = rates;
 	if (elems->ht_cap_elem &&
-	    sdata->local->_oper_channel_type != NL80211_CHAN_NO_HT)
+	    sdata->vif.bss_conf.channel_type != NL80211_CHAN_NO_HT)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 						  elems->ht_cap_elem,
 						  &sta->sta.ht_cap);
-- 
1.7.10.4

