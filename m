Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54864 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2CaUcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 16:32:23 -0400
Received: by mail-ob0-f174.google.com with SMTP id tb18so473268obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2012 13:32:22 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, thomas@cozybit.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, linville@tuxdriver.com,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [[PATCH v2 2/4] mac80211: Indicate basic rates when adding rate IEs
Date: Sat, 31 Mar 2012 13:32:08 -0700
Message-Id: <1333225930-320-2-git-send-email-ashok@cozybit.com> (sfid-20120331_223227_145309_C3EF31FC)
In-Reply-To: <1333225930-320-1-git-send-email-ashok@cozybit.com>
References: <1333225930-320-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Basic rates are added with supported rates IE and extended supported
rates IE.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
v2:
	indicate basic_rates conditionally (Johannes)
 include/net/mac80211.h    |    5 +++--
 net/mac80211/cfg.c        |   12 ++++++------
 net/mac80211/mesh_plink.c |    4 ++--
 net/mac80211/tx.c         |    4 ++--
 net/mac80211/util.c       |   18 ++++++++++++++----
 5 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9a012be..60f4cf4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3704,8 +3704,9 @@ void ieee80211_enable_rssi_reports(struct ieee80211_vif *vif,
 
 void ieee80211_disable_rssi_reports(struct ieee80211_vif *vif);
 
-int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb);
+int ieee80211_add_srates_ie(struct ieee80211_vif *vif,
+			    struct sk_buff *skb, bool need_basic);
 
 int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
-				struct sk_buff *skb);
+				struct sk_buff *skb, bool need_basic);
 #endif /* MAC80211_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 75a5bcd..37f6b35 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2354,8 +2354,8 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		tf->u.setup_req.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
-		ieee80211_add_srates_ie(&sdata->vif, skb);
-		ieee80211_add_ext_srates_ie(&sdata->vif, skb);
+		ieee80211_add_srates_ie(&sdata->vif, skb, false);
+		ieee80211_add_ext_srates_ie(&sdata->vif, skb, false);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	case WLAN_TDLS_SETUP_RESPONSE:
@@ -2368,8 +2368,8 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		tf->u.setup_resp.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
-		ieee80211_add_srates_ie(&sdata->vif, skb);
-		ieee80211_add_ext_srates_ie(&sdata->vif, skb);
+		ieee80211_add_srates_ie(&sdata->vif, skb, false);
+		ieee80211_add_ext_srates_ie(&sdata->vif, skb, false);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	case WLAN_TDLS_SETUP_CONFIRM:
@@ -2429,8 +2429,8 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 		mgmt->u.action.u.tdls_discover_resp.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
-		ieee80211_add_srates_ie(&sdata->vif, skb);
-		ieee80211_add_ext_srates_ie(&sdata->vif, skb);
+		ieee80211_add_srates_ie(&sdata->vif, skb, false);
+		ieee80211_add_ext_srates_ie(&sdata->vif, skb, false);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	default:
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 8ba5f5e..e1a5fc4 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -212,8 +212,8 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			pos = skb_put(skb, 2);
 			memcpy(pos + 2, &plid, 2);
 		}
-		if (ieee80211_add_srates_ie(&sdata->vif, skb) ||
-		    ieee80211_add_ext_srates_ie(&sdata->vif, skb) ||
+		if (ieee80211_add_srates_ie(&sdata->vif, skb, true) ||
+		    ieee80211_add_ext_srates_ie(&sdata->vif, skb, true) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata))
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 782a601..196cc58 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2414,9 +2414,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		*pos++ = WLAN_EID_SSID;
 		*pos++ = 0x0;
 
-		if (ieee80211_add_srates_ie(&sdata->vif, skb) ||
+		if (ieee80211_add_srates_ie(&sdata->vif, skb, true) ||
 		    mesh_add_ds_params_ie(skb, sdata) ||
-		    ieee80211_add_ext_srates_ie(&sdata->vif, skb) ||
+		    ieee80211_add_ext_srates_ie(&sdata->vif, skb, true) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_ht_cap_ie(skb, sdata) ||
 		    mesh_add_ht_info_ie(skb, sdata) ||
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 32f7a3b..ca5aa32 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1678,13 +1678,15 @@ ieee80211_ht_info_to_channel_type(struct ieee80211_ht_info *ht_info)
 	return channel_type;
 }
 
-int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
+int ieee80211_add_srates_ie(struct ieee80211_vif *vif,
+			    struct sk_buff *skb, bool need_basic)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	int rate;
 	u8 i, rates, *pos;
+	u32 basic_rates = vif->bss_conf.basic_rates;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	rates = sband->n_bitrates;
@@ -1698,20 +1700,25 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos++ = rates;
 	for (i = 0; i < rates; i++) {
+		u8 basic = 0;
+		if (need_basic && basic_rates & BIT(i))
+			basic = 0x80;
 		rate = sband->bitrates[i].bitrate;
-		*pos++ = (u8) (rate / 5);
+		*pos++ = basic | (u8) (rate / 5);
 	}
 
 	return 0;
 }
 
-int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
+int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
+				struct sk_buff *skb, bool need_basic)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	int rate;
 	u8 i, exrates, *pos;
+	u32 basic_rates = vif->bss_conf.basic_rates;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	exrates = sband->n_bitrates;
@@ -1728,8 +1735,11 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
 		*pos++ = exrates;
 		for (i = 8; i < sband->n_bitrates; i++) {
+			u8 basic = 0;
+			if (need_basic && basic_rates & BIT(i))
+				basic = 0x80;
 			rate = sband->bitrates[i].bitrate;
-			*pos++ = (u8) (rate / 5);
+			*pos++ = basic | (u8) (rate / 5);
 		}
 	}
 	return 0;
-- 
1.7.5.4

