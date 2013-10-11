Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43561 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab3JKSaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 14:30:04 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr4so4594351pbb.34
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 11:30:04 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH v4 2/6] {nl,cfg,mac}80211: enable the triggering of CSA frame in mesh
Date: Fri, 11 Oct 2013 11:29:46 -0700
Message-Id: <1381516190-23918-3-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131011_203012_156372_2F41082A)
In-Reply-To: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow the triggering of CSA frame using mesh interface. The
rules are more or less same with IBSS, such as not allowed to
change between the band and channel width has to be same from
the previous mode. Also, move the ieee80211_send_action_csa
to a common space so that it can be re-used by mesh interface.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---
v2: fix return value and others (Johannes Berg)

 net/mac80211/cfg.c         |   19 ++++++++++
 net/mac80211/ibss.c        |   54 ---------------------------
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/util.c        |   87 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c     |    1 +
 5 files changed, 109 insertions(+), 54 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b455e72..438c689 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2907,6 +2907,7 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_chanctx *chanctx;
+	struct ieee80211_if_mesh *ifmsh;
 	int err, num_chanctx;
 
 	if (!list_empty(&local->roc_list) || local->scanning)
@@ -2990,6 +2991,24 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		if (err < 0)
 			return err;
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		ifmsh = &sdata->u.mesh;
+
+		if (!ifmsh->mesh_id)
+			return -EINVAL;
+
+		if (params->chandef.width != sdata->vif.bss_conf.chandef.width)
+			return -EINVAL;
+
+		/* changes into another band are not supported */
+		if (sdata->vif.bss_conf.chandef.chan->band !=
+		    params->chandef.chan->band)
+			return -EINVAL;
+
+		err = ieee80211_send_action_csa(sdata, params);
+		if (err < 0)
+			return err;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5ea9b3a..017e206 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -428,60 +428,6 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				  tsf, false);
 }
 
-static int ieee80211_send_action_csa(struct ieee80211_sub_if_data *sdata,
-				     struct cfg80211_csa_settings *csa_settings)
-{
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_local *local = sdata->local;
-	int freq;
-	int hdr_len = offsetof(struct ieee80211_mgmt, u.action.u.chan_switch) +
-		      sizeof(mgmt->u.action.u.chan_switch);
-	u8 *pos;
-
-	skb = dev_alloc_skb(local->tx_headroom + hdr_len +
-			    5 +	/* channel switch announcement element */
-			    3);	/* secondary channel offset element */
-	if (!skb)
-		return -1;
-
-	skb_reserve(skb, local->tx_headroom);
-	mgmt = (struct ieee80211_mgmt *)skb_put(skb, hdr_len);
-	memset(mgmt, 0, hdr_len);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_ACTION);
-
-	eth_broadcast_addr(mgmt->da);
-	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifibss->bssid, ETH_ALEN);
-	mgmt->u.action.category = WLAN_CATEGORY_SPECTRUM_MGMT;
-	mgmt->u.action.u.chan_switch.action_code = WLAN_ACTION_SPCT_CHL_SWITCH;
-	pos = skb_put(skb, 5);
-	*pos++ = WLAN_EID_CHANNEL_SWITCH;			/* EID */
-	*pos++ = 3;						/* IE length */
-	*pos++ = csa_settings->block_tx ? 1 : 0;		/* CSA mode */
-	freq = csa_settings->chandef.chan->center_freq;
-	*pos++ = ieee80211_frequency_to_channel(freq);		/* channel */
-	*pos++ = csa_settings->count;				/* count */
-
-	if (csa_settings->chandef.width == NL80211_CHAN_WIDTH_40) {
-		enum nl80211_channel_type ch_type;
-
-		skb_put(skb, 3);
-		*pos++ = WLAN_EID_SECONDARY_CHANNEL_OFFSET;	/* EID */
-		*pos++ = 1;					/* IE length */
-		ch_type = cfg80211_get_chandef_type(&csa_settings->chandef);
-		if (ch_type == NL80211_CHAN_HT40PLUS)
-			*pos++ = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-		else
-			*pos++ = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-	}
-
-	ieee80211_tx_skb(sdata, skb);
-	return 0;
-}
-
 int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 			      struct cfg80211_csa_settings *csa_settings)
 {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7f13b65..829ff7e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1714,6 +1714,8 @@ void ieee80211_dfs_cac_timer(unsigned long data);
 void ieee80211_dfs_cac_timer_work(struct work_struct *work);
 void ieee80211_dfs_cac_cancel(struct ieee80211_local *local);
 void ieee80211_dfs_radar_detected_work(struct work_struct *work);
+int ieee80211_send_action_csa(struct ieee80211_sub_if_data *sdata,
+			      struct cfg80211_csa_settings *csa_settings);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 133667c..5d12440 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2361,3 +2361,90 @@ u32 ieee80211_chandef_downgrade(struct cfg80211_chan_def *c)
 
 	return ret;
 }
+
+int ieee80211_send_action_csa(struct ieee80211_sub_if_data *sdata,
+			      struct cfg80211_csa_settings *csa_settings)
+{
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_local *local = sdata->local;
+	int freq;
+	int hdr_len = offsetof(struct ieee80211_mgmt, u.action.u.chan_switch) +
+			       sizeof(mgmt->u.action.u.chan_switch);
+	u8 *pos;
+
+	if (sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
+		return -EOPNOTSUPP;
+
+	skb = dev_alloc_skb(local->tx_headroom + hdr_len +
+			    5 + /* channel switch announcement element */
+			    3 + /* secondary channel offset element */
+			    8); /* mesh channel switch parameters element */
+	if (!skb)
+		return -ENOMEM;
+
+	skb_reserve(skb, local->tx_headroom);
+	mgmt = (struct ieee80211_mgmt *)skb_put(skb, hdr_len);
+	memset(mgmt, 0, hdr_len);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
+
+	eth_broadcast_addr(mgmt->da);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
+	} else {
+		struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+		memcpy(mgmt->bssid, ifibss->bssid, ETH_ALEN);
+	}
+	mgmt->u.action.category = WLAN_CATEGORY_SPECTRUM_MGMT;
+	mgmt->u.action.u.chan_switch.action_code = WLAN_ACTION_SPCT_CHL_SWITCH;
+	pos = skb_put(skb, 5);
+	*pos++ = WLAN_EID_CHANNEL_SWITCH;			/* EID */
+	*pos++ = 3;						/* IE length */
+	*pos++ = csa_settings->block_tx ? 1 : 0;		/* CSA mode */
+	freq = csa_settings->chandef.chan->center_freq;
+	*pos++ = ieee80211_frequency_to_channel(freq);		/* channel */
+	*pos++ = csa_settings->count;				/* count */
+
+	if (csa_settings->chandef.width == NL80211_CHAN_WIDTH_40) {
+		enum nl80211_channel_type ch_type;
+
+		skb_put(skb, 3);
+		*pos++ = WLAN_EID_SECONDARY_CHANNEL_OFFSET;	/* EID */
+		*pos++ = 1;					/* IE length */
+		ch_type = cfg80211_get_chandef_type(&csa_settings->chandef);
+		if (ch_type == NL80211_CHAN_HT40PLUS)
+			*pos++ = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+		else
+			*pos++ = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+	}
+
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+		__le16 pre_value;
+
+		skb_put(skb, 8);
+		*pos++ = WLAN_EID_CHAN_SWITCH_PARAM;		/* EID */
+		*pos++ = 6;					/* IE length */
+		*pos++ = sdata->u.mesh.mshcfg.dot11MeshTTL;	/* Mesh TTL */
+		*pos = 0x00;	/* Mesh Flag: Tx Restrict, Initiator, Reason */
+		*pos |= WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
+		*pos++ |= csa_settings->block_tx ?
+			  WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT : 0x00;
+		put_unaligned_le16(WLAN_REASON_MESH_CHAN, pos); /* Reason Cd */
+		pos += 2;
+		if (!ifmsh->pre_value)
+			ifmsh->pre_value = 1;
+		else
+			ifmsh->pre_value++;
+		pre_value = cpu_to_le16(ifmsh->pre_value);
+		memcpy(pos, &pre_value, 2);		/* Precedence Value */
+		pos += 2;
+		ifmsh->chsw_init = true;
+	}
+
+	ieee80211_tx_skb(sdata, skb);
+	return 0;
+}
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index da8de5b..7bb5aca 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5650,6 +5650,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		break;
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
1.7.9.5

