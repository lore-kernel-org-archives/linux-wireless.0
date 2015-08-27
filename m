Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33462 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbbH0NAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 09:00:43 -0400
Received: by iods203 with SMTP id s203so55718638iod.0
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2015 06:00:42 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/4] mac80211: implement VHT support for mesh
Date: Thu, 27 Aug 2015 09:00:18 -0400
Message-Id: <1440680418-19714-1-git-send-email-me@bobcopeland.com> (sfid-20150827_150049_078846_76C8D2AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the basics required for supporting very high throughput
with mesh: include VHT information elements in beacons, probe
responses, and peering action frames, and check for compatible VHT
configurations when peering.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
[resend with correct linux-wireless address]

 net/mac80211/mesh.c       | 76 +++++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/mesh.h       |  4 +++
 net/mac80211/mesh_plink.c |  9 +++++-
 3 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e06a5ca..62b3e29 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -94,6 +94,9 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	ieee80211_ht_oper_to_chandef(sdata->vif.bss_conf.chandef.chan,
 				     ie->ht_operation, &sta_chan_def);
 
+	ieee80211_vht_oper_to_chandef(sdata->vif.bss_conf.chandef.chan,
+				      ie->vht_operation, &sta_chan_def);
+
 	if (!cfg80211_chandef_compatible(&sdata->vif.bss_conf.chandef,
 					 &sta_chan_def))
 		return false;
@@ -436,8 +439,6 @@ int mesh_add_ht_oper_ie(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *channel;
-	enum nl80211_channel_type channel_type =
-		cfg80211_get_chandef_type(&sdata->vif.bss_conf.chandef);
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sta_ht_cap *ht_cap;
 	u8 *pos;
@@ -454,7 +455,10 @@ int mesh_add_ht_oper_ie(struct ieee80211_sub_if_data *sdata,
 	sband = local->hw.wiphy->bands[channel->band];
 	ht_cap = &sband->ht_cap;
 
-	if (!ht_cap->ht_supported || channel_type == NL80211_CHAN_NO_HT)
+	if (!ht_cap->ht_supported ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_5 ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_10)
 		return 0;
 
 	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_ht_operation))
@@ -467,6 +471,68 @@ int mesh_add_ht_oper_ie(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+int mesh_add_vht_cap_ie(struct ieee80211_sub_if_data *sdata,
+			struct sk_buff *skb)
+{
+	struct ieee80211_local *local = sdata->local;
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	struct ieee80211_supported_band *sband;
+	u8 *pos;
+
+	sband = local->hw.wiphy->bands[band];
+	if (!sband->vht_cap.vht_supported ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_5 ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_10)
+		return 0;
+
+	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_vht_cap))
+		return -ENOMEM;
+
+	pos = skb_put(skb, 2 + sizeof(struct ieee80211_vht_cap));
+	ieee80211_ie_build_vht_cap(pos, &sband->vht_cap, sband->vht_cap.cap);
+
+	return 0;
+}
+
+int mesh_add_vht_oper_ie(struct ieee80211_sub_if_data *sdata,
+			 struct sk_buff *skb)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *channel;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_sta_vht_cap *vht_cap;
+	u8 *pos;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (WARN_ON(!chanctx_conf)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	channel = chanctx_conf->def.chan;
+	rcu_read_unlock();
+
+	sband = local->hw.wiphy->bands[channel->band];
+	vht_cap = &sband->vht_cap;
+
+	if (!vht_cap->vht_supported ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_5 ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_10)
+		return 0;
+
+	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_vht_operation))
+		return -ENOMEM;
+
+	pos = skb_put(skb, 2 + sizeof(struct ieee80211_vht_operation));
+	ieee80211_ie_build_vht_oper(pos, vht_cap,
+				    &sdata->vif.bss_conf.chandef);
+
+	return 0;
+}
+
 static void ieee80211_mesh_path_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -637,6 +703,8 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 		   2 + ifmsh->mesh_id_len +
 		   2 + sizeof(struct ieee80211_meshconf_ie) +
 		   2 + sizeof(__le16) + /* awake window */
+		   2 + sizeof(struct ieee80211_vht_cap) +
+		   2 + sizeof(struct ieee80211_vht_operation) +
 		   ifmsh->ie_len;
 
 	bcn = kzalloc(sizeof(*bcn) + head_len + tail_len, GFP_KERNEL);
@@ -718,6 +786,8 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 	    mesh_add_meshid_ie(sdata, skb) ||
 	    mesh_add_meshconf_ie(sdata, skb) ||
 	    mesh_add_awake_window_ie(sdata, skb) ||
+	    mesh_add_vht_cap_ie(sdata, skb) ||
+	    mesh_add_vht_oper_ie(sdata, skb) ||
 	    mesh_add_vendor_ies(sdata, skb))
 		goto out_free;
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 50c8473..c60be85 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -227,6 +227,10 @@ int mesh_add_ht_cap_ie(struct ieee80211_sub_if_data *sdata,
 		       struct sk_buff *skb);
 int mesh_add_ht_oper_ie(struct ieee80211_sub_if_data *sdata,
 			struct sk_buff *skb);
+int mesh_add_vht_cap_ie(struct ieee80211_sub_if_data *sdata,
+			struct sk_buff *skb);
+int mesh_add_vht_oper_ie(struct ieee80211_sub_if_data *sdata,
+			 struct sk_buff *skb);
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_init(void);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index e12be2e..2222067 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -226,6 +226,8 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			    2 + sizeof(struct ieee80211_meshconf_ie) +
 			    2 + sizeof(struct ieee80211_ht_cap) +
 			    2 + sizeof(struct ieee80211_ht_operation) +
+			    2 + sizeof(struct ieee80211_vht_cap) +
+			    2 + sizeof(struct ieee80211_vht_operation) +
 			    2 + 8 + /* peering IE */
 			    sdata->u.mesh.ie_len);
 	if (!skb)
@@ -306,7 +308,9 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 
 	if (action != WLAN_SP_MESH_PEERING_CLOSE) {
 		if (mesh_add_ht_cap_ie(sdata, skb) ||
-		    mesh_add_ht_oper_ie(sdata, skb))
+		    mesh_add_ht_oper_ie(sdata, skb) ||
+		    mesh_add_vht_cap_ie(sdata, skb) ||
+		    mesh_add_vht_oper_ie(sdata, skb))
 			goto free;
 	}
 
@@ -402,6 +406,9 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 					      elems->ht_cap_elem, sta))
 		changed |= IEEE80211_RC_BW_CHANGED;
 
+	ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
+					    elems->vht_cap_elem, sta);
+
 	if (bw != sta->sta.bandwidth)
 		changed |= IEEE80211_RC_BW_CHANGED;
 
-- 
2.1.4

