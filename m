Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:39384 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764314AbdEWPAu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 May 2017 11:00:50 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH v2 1/2] mac80211: mesh: support sending wide bandwidth CSA
Date: Tue, 23 May 2017 17:00:42 +0200
Message-Id: <20170523150043.22093-2-sw@simonwunderlich.de> (sfid-20170523_170054_732745_28AD04A2)
In-Reply-To: <20170523150043.22093-1-sw@simonwunderlich.de>
References: <20170523150043.22093-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To support HT and VHT CSA, beacons and action frames must include the
corresponding IEs.

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
Changes to PATCHv1 (Thanks Johannes)
 * change patch subject (originally: mac80211: add wide bandwidth
channel switch announcement to CSA action frames and mesh beacons)
 * use skb_put() to simplify csa handling
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/mesh.c        | 45 +++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/util.c        | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c960e4999380..e3a0b295c5ce 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2066,6 +2066,8 @@ u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       const struct cfg80211_chan_def *chandef,
 			       u16 prot_mode, bool rifs_mode);
+u8 *ieee80211_ie_build_wide_bw_cs(u8 *pos,
+				  const struct cfg80211_chan_def *chandef);
 u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 			       u32 cap);
 u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 2f189c59ae80..872a05606f06 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -690,6 +690,9 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 		   2 + sizeof(struct ieee80211_channel_sw_ie) +
 		   /* Mesh Channel Switch Parameters */
 		   2 + sizeof(struct ieee80211_mesh_chansw_params_ie) +
+		   /* Channel Switch Wrapper + Wide Bandwidth CSA IE */
+		   2 + 2 + sizeof(struct ieee80211_wide_bw_chansw_ie) +
+		   2 + sizeof(struct ieee80211_sec_chan_offs_ie) +
 		   2 + 8 + /* supported rates */
 		   2 + 3; /* DS params */
 	tail_len = 2 + (IEEE80211_MAX_SUPP_RATES - 8) +
@@ -736,8 +739,13 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 	rcu_read_lock();
 	csa = rcu_dereference(ifmsh->csa);
 	if (csa) {
-		pos = skb_put(skb, 13);
-		memset(pos, 0, 13);
+		enum nl80211_channel_type ct;
+		struct cfg80211_chan_def *chandef;
+		int ie_len = 2 + sizeof(struct ieee80211_channel_sw_ie) +
+			     2 + sizeof(struct ieee80211_mesh_chansw_params_ie);
+
+		pos = skb_put(skb, ie_len);
+		memset(pos, 0, ie_len);
 		*pos++ = WLAN_EID_CHANNEL_SWITCH;
 		*pos++ = 3;
 		*pos++ = 0x0;
@@ -760,6 +768,39 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 		pos += 2;
 		put_unaligned_le16(ifmsh->pre_value, pos);
 		pos += 2;
+
+		switch (csa->settings.chandef.width) {
+		case NL80211_CHAN_WIDTH_40:
+			ie_len = 2 + sizeof(struct ieee80211_sec_chan_offs_ie);
+			pos = skb_put(skb, ie_len);
+			memset(pos, 0, ie_len);
+
+			*pos++ = WLAN_EID_SECONDARY_CHANNEL_OFFSET; /* EID */
+			*pos++ = 1;				    /* len */
+			ct = cfg80211_get_chandef_type(&csa->settings.chandef);
+			if (ct == NL80211_CHAN_HT40PLUS)
+				*pos++ = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+			else
+				*pos++ = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+			break;
+		case NL80211_CHAN_WIDTH_80:
+		case NL80211_CHAN_WIDTH_80P80:
+		case NL80211_CHAN_WIDTH_160:
+			/* Channel Switch Wrapper + Wide Bandwidth CSA IE */
+			ie_len = 2 + 2 +
+				 sizeof(struct ieee80211_wide_bw_chansw_ie);
+			pos = skb_put(skb, ie_len);
+			memset(pos, 0, ie_len);
+
+			*pos++ = WLAN_EID_CHANNEL_SWITCH_WRAPPER; /* EID */
+			*pos++ = 5;				  /* len */
+			/* put sub IE */
+			chandef = &csa->settings.chandef;
+			pos = ieee80211_ie_build_wide_bw_cs(pos, chandef);
+			break;
+		default:
+			break;
+		}
 	}
 	rcu_read_unlock();
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ac9ac6c35594..d2e885cbfdf8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2414,6 +2414,37 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 	return pos + sizeof(struct ieee80211_ht_operation);
 }
 
+u8 *ieee80211_ie_build_wide_bw_cs(u8 *pos,
+				  const struct cfg80211_chan_def *chandef)
+{
+	*pos++ = WLAN_EID_WIDE_BW_CHANNEL_SWITCH;	/* EID */
+	*pos++ = 3;					/* IE length */
+	/* New channel width */
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_80:
+		*pos++ = IEEE80211_VHT_CHANWIDTH_80MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		*pos++ = IEEE80211_VHT_CHANWIDTH_160MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+		*pos++ = IEEE80211_VHT_CHANWIDTH_80P80MHZ;
+		break;
+	default:
+		*pos++ = IEEE80211_VHT_CHANWIDTH_USE_HT;
+	}
+
+	/* new center frequency segment 0 */
+	*pos++ = ieee80211_frequency_to_channel(chandef->center_freq1);
+	/* new center frequency segment 1 */
+	if (chandef->center_freq2)
+		*pos++ = ieee80211_frequency_to_channel(chandef->center_freq2);
+	else
+		*pos++ = 0;
+
+	return pos;
+}
+
 u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 				const struct cfg80211_chan_def *chandef)
 {
@@ -2964,6 +2995,7 @@ int ieee80211_send_action_csa(struct ieee80211_sub_if_data *sdata,
 	skb = dev_alloc_skb(local->tx_headroom + hdr_len +
 			    5 + /* channel switch announcement element */
 			    3 + /* secondary channel offset element */
+			    5 + /* wide bandwidth channel switch announcement */
 			    8); /* mesh channel switch parameters element */
 	if (!skb)
 		return -ENOMEM;
@@ -3022,6 +3054,14 @@ int ieee80211_send_action_csa(struct ieee80211_sub_if_data *sdata,
 		pos += 2;
 	}
 
+	if (csa_settings->chandef.width == NL80211_CHAN_WIDTH_80 ||
+	    csa_settings->chandef.width == NL80211_CHAN_WIDTH_80P80 ||
+	    csa_settings->chandef.width == NL80211_CHAN_WIDTH_160) {
+		skb_put(skb, 5);
+		pos = ieee80211_ie_build_wide_bw_cs(pos,
+						    &csa_settings->chandef);
+	}
+
 	ieee80211_tx_skb(sdata, skb);
 	return 0;
 }
-- 
2.11.0
