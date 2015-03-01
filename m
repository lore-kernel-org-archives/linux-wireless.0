Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbbCAHKc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:32 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/16] mac80211: TDLS: support VHT between peers
Date: Sun,  1 Mar 2015 09:10:02 +0200
Message-Id: <1425193815-17785-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_081042_858374_EE78FCF1)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Add the AID and VHT-cap/operation IEs during TDLS setup. Remove the
block of TDLS peers when setting HT-caps of the peer station.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/tdls.c        | 86 +++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/util.c        | 35 +++++++++++++++++++
 net/mac80211/vht.c         |  4 ---
 4 files changed, 118 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3afe368..2891e40 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1967,6 +1967,8 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       u16 prot_mode);
 u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 			       u32 cap);
+u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
+				const struct cfg80211_chan_def *chandef);
 int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
 			     const struct ieee80211_supported_band *sband,
 			     const u8 *srates, int srates_len, u32 *rates);
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index c9f9752..5bcd542 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -193,6 +193,17 @@ static void ieee80211_tdls_add_link_ie(struct ieee80211_sub_if_data *sdata,
 	memcpy(lnkid->resp_sta, rsp_addr, ETH_ALEN);
 }
 
+static void
+ieee80211_tdls_add_aid(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	u8 *pos = (void *)skb_put(skb, 4);
+
+	*pos++ = WLAN_EID_AID;
+	*pos++ = 2; /* len */
+	put_unaligned_le16(ifmgd->aid, pos);
+}
+
 /* translate numbering in the WMM parameter IE to the mac80211 notation */
 static enum ieee80211_ac_numbers ieee80211_ac_from_wmm(int ac)
 {
@@ -271,6 +282,7 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sta_ht_cap ht_cap;
+	struct ieee80211_sta_vht_cap vht_cap;
 	struct sta_info *sta = NULL;
 	size_t offset = 0, noffset;
 	u8 *pos;
@@ -368,12 +380,60 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 		ieee80211_ie_build_ht_cap(pos, &ht_cap, ht_cap.cap);
 	}
 
-	rcu_read_unlock();
-
 	if (ht_cap.ht_supported &&
 	    (ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
 		ieee80211_tdls_add_bss_coex_ie(skb);
 
+	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
+
+	/* add any custom IEs that go before VHT capabilities */
+	if (extra_ies_len) {
+		static const u8 before_vht_cap[] = {
+			WLAN_EID_SUPP_RATES,
+			WLAN_EID_COUNTRY,
+			WLAN_EID_EXT_SUPP_RATES,
+			WLAN_EID_SUPPORTED_CHANNELS,
+			WLAN_EID_RSN,
+			WLAN_EID_EXT_CAPABILITY,
+			WLAN_EID_QOS_CAPA,
+			WLAN_EID_FAST_BSS_TRANSITION,
+			WLAN_EID_TIMEOUT_INTERVAL,
+			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
+			WLAN_EID_MULTI_BAND,
+		};
+		noffset = ieee80211_ie_split(extra_ies, extra_ies_len,
+					     before_vht_cap,
+					     ARRAY_SIZE(before_vht_cap),
+					     offset);
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, extra_ies + offset, noffset - offset);
+		offset = noffset;
+	}
+
+	/* build the VHT-cap similarly to the HT-cap */
+	memcpy(&vht_cap, &sband->vht_cap, sizeof(vht_cap));
+	if (action_code == WLAN_TDLS_SETUP_REQUEST && vht_cap.vht_supported) {
+		ieee80211_apply_vhtcap_overrides(sdata, &vht_cap);
+
+		/* the AID is present only when VHT is implemented */
+		ieee80211_tdls_add_aid(sdata, skb);
+
+		pos = skb_put(skb, sizeof(struct ieee80211_vht_cap) + 2);
+		ieee80211_ie_build_vht_cap(pos, &vht_cap, vht_cap.cap);
+	} else if (action_code == WLAN_TDLS_SETUP_RESPONSE &&
+		   vht_cap.vht_supported && sta->sta.vht_cap.vht_supported) {
+		/* the peer caps are already intersected with our own */
+		memcpy(&vht_cap, &sta->sta.vht_cap, sizeof(vht_cap));
+
+		/* the AID is present only when VHT is implemented */
+		ieee80211_tdls_add_aid(sdata, skb);
+
+		pos = skb_put(skb, sizeof(struct ieee80211_vht_cap) + 2);
+		ieee80211_ie_build_vht_cap(pos, &vht_cap, vht_cap.cap);
+	}
+
+	rcu_read_unlock();
+
 	/* add any remaining IEs */
 	if (extra_ies_len) {
 		noffset = extra_ies_len;
@@ -381,7 +441,6 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 		memcpy(pos, extra_ies + offset, noffset - offset);
 	}
 
-	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
 }
 
 static void
@@ -394,6 +453,7 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	size_t offset = 0, noffset;
 	struct sta_info *sta, *ap_sta;
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	u8 *pos;
 
 	rcu_read_lock();
@@ -453,6 +513,21 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
+
+	/* only include VHT-operation if not on the 2.4GHz band */
+	if (band != IEEE80211_BAND_2GHZ && !ap_sta->sta.vht_cap.vht_supported &&
+	    sta->sta.vht_cap.vht_supported) {
+		struct ieee80211_chanctx_conf *chanctx_conf =
+				rcu_dereference(sdata->vif.chanctx_conf);
+		if (!WARN_ON(!chanctx_conf)) {
+			pos = skb_put(skb, 2 +
+				      sizeof(struct ieee80211_vht_operation));
+			ieee80211_ie_build_vht_oper(pos, &sta->sta.vht_cap,
+						    &chanctx_conf->def);
+		}
+	}
+
 	rcu_read_unlock();
 
 	/* add any remaining IEs */
@@ -461,8 +536,6 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 		pos = skb_put(skb, noffset - offset);
 		memcpy(pos, extra_ies + offset, noffset - offset);
 	}
-
-	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
 }
 
 static void
@@ -708,8 +781,11 @@ ieee80211_tdls_build_mgmt_packet_data(struct ieee80211_sub_if_data *sdata,
 			       26 + /* max(WMM-info, WMM-param) */
 			       2 + max(sizeof(struct ieee80211_ht_cap),
 				       sizeof(struct ieee80211_ht_operation)) +
+			       2 + max(sizeof(struct ieee80211_vht_cap),
+				       sizeof(struct ieee80211_vht_operation)) +
 			       50 + /* supported channels */
 			       3 + /* 40/20 BSS coex */
+			       4 + /* AID */
 			       extra_ies_len +
 			       sizeof(struct ieee80211_tdls_lnkie));
 	if (!skb)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 8428f4a..eec9444 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2344,6 +2344,41 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 	return pos + sizeof(struct ieee80211_ht_operation);
 }
 
+u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
+				const struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_vht_operation *vht_oper;
+
+	*pos++ = WLAN_EID_VHT_OPERATION;
+	*pos++ = sizeof(struct ieee80211_vht_operation);
+	vht_oper = (struct ieee80211_vht_operation *)pos;
+	vht_oper->center_freq_seg1_idx = ieee80211_frequency_to_channel(
+							chandef->center_freq1);
+	if (chandef->center_freq2)
+		vht_oper->center_freq_seg2_idx =
+			ieee80211_frequency_to_channel(chandef->center_freq2);
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_160:
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_160MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80P80MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
+		break;
+	default:
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_USE_HT;
+		break;
+	}
+
+	/* don't require special VHT peer rates */
+	vht_oper->basic_mcs_set = cpu_to_le16(0xffff);
+
+	return pos + sizeof(struct ieee80211_vht_operation);
+}
+
 void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
 				  const struct ieee80211_ht_operation *ht_oper,
 				  struct cfg80211_chan_def *chandef)
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 85f9596..80694d5 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -129,10 +129,6 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	if (!vht_cap_ie || !sband->vht_cap.vht_supported)
 		return;
 
-	/* don't support VHT for TDLS peers for now */
-	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
-		return;
-
 	/*
 	 * A VHT STA must support 40 MHz, but if we verify that here
 	 * then we break a few things - some APs (e.g. Netgear R6300v2
-- 
1.9.1

