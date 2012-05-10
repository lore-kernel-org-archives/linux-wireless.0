Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:48058 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab2EJGpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 02:45:12 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/7] mac80211: remove _oper_channel_type
Date: Thu, 10 May 2012 08:44:41 +0200
Message-ID: <1336632282-2278-7-git-send-email-michal.kazior@tieto.com> (sfid-20120510_084535_725868_4EF7DE8D)
In-Reply-To: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removes _oper_channel_type since it may be
calculated on the fly now by using
ieee80211_oper_channel_type function.

Change-Id: I8b2942e3a43efb7d68ab5b6f9eb7a0265d1a3ef0
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c         |   12 ++++++------
 net/mac80211/chan.c        |    1 -
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/iface.c       |    7 ++++---
 net/mac80211/main.c        |    8 +++++---
 net/mac80211/mesh.c        |    7 ++++---
 6 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8b71e90..1898299 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1499,8 +1499,6 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 	case CHAN_MODE_FIXED:
 		if (local->oper_channel != chan)
 			return -EBUSY;
-		if (!sdata && local->_oper_channel_type == channel_type)
-			return 0;
 		break;
 	case CHAN_MODE_UNDEFINED:
 		break;
@@ -1508,7 +1506,7 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 
 	if (sdata)
 		old_vif_oper_type = sdata->vif.bss_conf.channel_type;
-	old_oper_type = local->_oper_channel_type;
+	old_oper_type = ieee80211_oper_channel_type(local, sdata);
 
 	if (!ieee80211_set_channel_type(local, sdata, channel_type))
 		return -EBUSY;
@@ -1518,7 +1516,7 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 
 	/* Update driver if changes were actually made. */
 	if ((old_oper != local->oper_channel) ||
-	    (old_oper_type != local->_oper_channel_type))
+	    (old_oper_type != ieee80211_oper_channel_type(local, sdata)))
 		ieee80211_recalc_channel(sdata);
 
 	if (sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR &&
@@ -2064,7 +2062,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 		is_offchan = true;
 	if (channel_type_valid &&
 	    (channel_type != local->tmp_channel_type &&
-	     channel_type != local->_oper_channel_type))
+	     channel_type != ieee80211_oper_channel_type(local, sdata)))
 		is_offchan = true;
 
 	if (chan == local->hw_roc_channel) {
@@ -2697,8 +2695,10 @@ ieee80211_wiphy_get_channel(struct wiphy *wiphy,
 			    enum nl80211_channel_type *type)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata =
+			container_of(wdev, struct ieee80211_sub_if_data, wdev);
 
-	*type = local->_oper_channel_type;
+	*type = ieee80211_oper_channel_type(local, sdata);
 	return local->oper_channel;
 }
 
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 8513f70..bfcaff8 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -153,7 +153,6 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 	if (!ieee80211_channel_types_are_compatible(superchan, chantype))
 		return false;
 
-	local->_oper_channel_type = superchan;
 	if (sdata)
 		sdata->vif.bss_conf.channel_type = chantype;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e40cd06..3a1af25 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -993,7 +993,6 @@ struct ieee80211_local {
 	enum mac80211_scan_state next_scan_state;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
-	enum nl80211_channel_type _oper_channel_type;
 	struct ieee80211_channel *oper_channel, *csa_channel;
 
 	/* Temporary remain-on-channel for off-channel operations */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index cefdf73..77b9154 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -515,7 +515,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
 	int i;
-	enum nl80211_channel_type orig_ct;
+	enum nl80211_channel_type orig_ct, new_ct;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
@@ -683,11 +683,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	/* Re-calculate channel-type, in case there are multiple vifs
 	 * on different channel types.
 	 */
-	orig_ct = local->_oper_channel_type;
+	orig_ct = ieee80211_oper_channel_type(local, sdata);
 	ieee80211_set_channel_type(local, NULL, NL80211_CHAN_NO_HT);
+	new_ct = ieee80211_oper_channel_type(local, sdata);
 
 	/* do after stop to avoid reconfiguring when we stop anyway */
-	if (hw_reconf_flags || (orig_ct != local->_oper_channel_type)) {
+	if (hw_reconf_flags || orig_ct != new_ct) {
 		ieee80211_hw_config(local, hw_reconf_flags);
 		ieee80211_recalc_channel(sdata);
 	}
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 01c0e8b..6c05464 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -123,8 +123,10 @@ void ieee80211_recalc_channel(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_channel *chan;
 	enum nl80211_channel_type channel_type;
+	enum nl80211_channel_type oper_channel_type;
 	u32 offchannel_flag;
 
+	oper_channel_type = ieee80211_oper_channel_type(local, sdata);
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 	if (local->scan_channel) {
 		chan = local->scan_channel;
@@ -132,7 +134,7 @@ void ieee80211_recalc_channel(struct ieee80211_sub_if_data *sdata)
 		 * is currently in use.
 		 */
 		if (chan == local->oper_channel)
-			channel_type = local->_oper_channel_type;
+			channel_type = oper_channel_type;
 		else
 			channel_type = NL80211_CHAN_NO_HT;
 	} else if (local->tmp_channel) {
@@ -140,11 +142,11 @@ void ieee80211_recalc_channel(struct ieee80211_sub_if_data *sdata)
 		channel_type = local->tmp_channel_type;
 	} else {
 		chan = local->oper_channel;
-		channel_type = local->_oper_channel_type;
+		channel_type = oper_channel_type;
 	}
 
 	if (chan != local->oper_channel ||
-	    channel_type != local->_oper_channel_type)
+	    channel_type != oper_channel_type)
 		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
 	else
 		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 133c118..ac03c4b 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -101,7 +101,7 @@ bool mesh_matches_local(struct ieee802_11_elems *ie,
 
 	/* disallow peering with mismatched channel types for now */
 	if (ie->ht_operation &&
-	    (local->_oper_channel_type !=
+	    (ieee80211_oper_channel_type(local, sdata) !=
 	     ieee80211_ht_oper_to_channel_type(ie->ht_operation)))
 		goto mismatch;
 
@@ -363,7 +363,7 @@ int mesh_add_ht_cap_ie(struct sk_buff *skb,
 
 	sband = local->hw.wiphy->bands[local->oper_channel->band];
 	if (!sband->ht_cap.ht_supported ||
-	    local->_oper_channel_type == NL80211_CHAN_NO_HT)
+	    ieee80211_oper_channel_type(local, sdata) == NL80211_CHAN_NO_HT)
 		return 0;
 
 	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_ht_cap))
@@ -380,7 +380,8 @@ int mesh_add_ht_oper_ie(struct sk_buff *skb,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_channel *channel = local->oper_channel;
-	enum nl80211_channel_type channel_type = local->_oper_channel_type;
+	enum nl80211_channel_type channel_type =
+				ieee80211_oper_channel_type(local, sdata);
 	struct ieee80211_supported_band *sband =
 				local->hw.wiphy->bands[channel->band];
 	struct ieee80211_sta_ht_cap *ht_cap = &sband->ht_cap;
-- 
1.7.0.4

