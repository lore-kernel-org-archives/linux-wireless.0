Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45168 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2F1JCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 05:02:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't expose ieee80211_add_srates_ie()
Date: Thu, 28 Jun 2012 11:02:12 +0200
Message-Id: <1340874132-18705-1-git-send-email-johannes@sipsolutions.net> (sfid-20120628_110224_885517_CE9E10C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This and ieee80211_add_ext_srates_ie() aren't
exported, so can't be used by drivers anyway,
but there's also no reason that they should be
so make them private to mac80211 and use sdata
instead of vif arguments.

Acked-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |    6 ------
 net/mac80211/cfg.c         |   12 ++++++------
 net/mac80211/ieee80211_i.h |    4 ++++
 net/mac80211/mesh_plink.c  |    4 ++--
 net/mac80211/tx.c          |    4 ++--
 net/mac80211/util.c        |   10 ++++------
 6 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 510d852..5e67020 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3826,12 +3826,6 @@ void ieee80211_enable_rssi_reports(struct ieee80211_vif *vif,
 
 void ieee80211_disable_rssi_reports(struct ieee80211_vif *vif);
 
-int ieee80211_add_srates_ie(struct ieee80211_vif *vif,
-			    struct sk_buff *skb, bool need_basic);
-
-int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
-				struct sk_buff *skb, bool need_basic);
-
 /**
  * ieee80211_ave_rssi - report the average rssi for the specified interface
  *
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7722a73..ebc353e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2665,8 +2665,8 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		tf->u.setup_req.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
-		ieee80211_add_srates_ie(&sdata->vif, skb, false);
-		ieee80211_add_ext_srates_ie(&sdata->vif, skb, false);
+		ieee80211_add_srates_ie(sdata, skb, false);
+		ieee80211_add_ext_srates_ie(sdata, skb, false);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	case WLAN_TDLS_SETUP_RESPONSE:
@@ -2679,8 +2679,8 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		tf->u.setup_resp.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
-		ieee80211_add_srates_ie(&sdata->vif, skb, false);
-		ieee80211_add_ext_srates_ie(&sdata->vif, skb, false);
+		ieee80211_add_srates_ie(sdata, skb, false);
+		ieee80211_add_ext_srates_ie(sdata, skb, false);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	case WLAN_TDLS_SETUP_CONFIRM:
@@ -2740,8 +2740,8 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 		mgmt->u.action.u.tdls_discover_resp.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
-		ieee80211_add_srates_ie(&sdata->vif, skb, false);
-		ieee80211_add_ext_srates_ie(&sdata->vif, skb, false);
+		ieee80211_add_srates_ie(sdata, skb, false);
+		ieee80211_add_ext_srates_ie(sdata, skb, false);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	default:
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 341d77d..6b7157d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1480,6 +1480,10 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       struct ieee80211_channel *channel,
 			       enum nl80211_channel_type channel_type,
 			       u16 prot_mode);
+int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
+			    struct sk_buff *skb, bool need_basic);
+int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
+				struct sk_buff *skb, bool need_basic);
 
 /* channel management */
 enum ieee80211_chan_mode {
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index a1dbd15..4256859 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -258,8 +258,8 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			pos = skb_put(skb, 2);
 			memcpy(pos + 2, &plid, 2);
 		}
-		if (ieee80211_add_srates_ie(&sdata->vif, skb, true) ||
-		    ieee80211_add_ext_srates_ie(&sdata->vif, skb, true) ||
+		if (ieee80211_add_srates_ie(sdata, skb, true) ||
+		    ieee80211_add_ext_srates_ie(sdata, skb, true) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata))
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ec8f5346..4e75303 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2420,9 +2420,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		*pos++ = WLAN_EID_SSID;
 		*pos++ = 0x0;
 
-		if (ieee80211_add_srates_ie(&sdata->vif, skb, true) ||
+		if (ieee80211_add_srates_ie(sdata, skb, true) ||
 		    mesh_add_ds_params_ie(skb, sdata) ||
-		    ieee80211_add_ext_srates_ie(&sdata->vif, skb, true) ||
+		    ieee80211_add_ext_srates_ie(sdata, skb, true) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_ht_cap_ie(skb, sdata) ||
 		    mesh_add_ht_oper_ie(skb, sdata) ||
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 242ecde..c424569 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1764,15 +1764,14 @@ ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper)
 	return channel_type;
 }
 
-int ieee80211_add_srates_ie(struct ieee80211_vif *vif,
+int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb, bool need_basic)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	int rate;
 	u8 i, rates, *pos;
-	u32 basic_rates = vif->bss_conf.basic_rates;
+	u32 basic_rates = sdata->vif.bss_conf.basic_rates;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	rates = sband->n_bitrates;
@@ -1796,15 +1795,14 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif,
 	return 0;
 }
 
-int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
+int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb, bool need_basic)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	int rate;
 	u8 i, exrates, *pos;
-	u32 basic_rates = vif->bss_conf.basic_rates;
+	u32 basic_rates = sdata->vif.bss_conf.basic_rates;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	exrates = sband->n_bitrates;
-- 
1.7.10

