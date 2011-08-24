Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64521 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1HXTCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 15:02:39 -0400
Received: by mail-yw0-f46.google.com with SMTP id 7so1101813ywf.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 12:02:38 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [RFC 2/3] mac80211: add HT IEs to mesh frames
Date: Wed, 24 Aug 2011 12:02:18 -0700
Message-Id: <1314212539-23669-3-git-send-email-thomas@cozybit.com> (sfid-20110824_210242_086509_0ACA550E)
In-Reply-To: <1314212539-23669-1-git-send-email-thomas@cozybit.com>
References: <1314212539-23669-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/mesh.h       |    4 ++++
 net/mac80211/mesh_plink.c |    9 +++++++++
 net/mac80211/tx.c         |    4 ++++
 4 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 28ab510..6ed233d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -400,6 +400,49 @@ int mesh_add_ds_params_ie(struct sk_buff *skb,
 	return 0;
 }
 
+int mesh_add_ht_cap_ie(struct sk_buff *skb,
+		       struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	u8 *pos;
+
+	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	if (!sband->ht_cap.ht_supported ||
+	    local->_oper_channel_type == NL80211_CHAN_NO_HT)
+		return 0;
+
+	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_ht_cap))
+		return -ENOMEM;
+
+	pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_cap));
+	ieee80211_ie_build_ht_cap(pos, sband, sband->ht_cap.cap);
+
+	return 0;
+}
+
+int mesh_add_ht_info_ie(struct sk_buff *skb,
+			struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel *channel = local->oper_channel;
+	enum nl80211_channel_type channel_type = local->_oper_channel_type;
+	struct ieee80211_supported_band *sband =
+				local->hw.wiphy->bands[channel->band];
+	struct ieee80211_sta_ht_cap *ht_cap = &sband->ht_cap;
+	u8 *pos;
+
+	if (!ht_cap->ht_supported || channel_type == NL80211_CHAN_NO_HT)
+		return 0;
+
+	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_ht_info))
+		return -ENOMEM;
+
+	pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_info));
+	ieee80211_ie_build_ht_info(pos, ht_cap, channel, channel_type);
+
+	return 0;
+}
 static void ieee80211_mesh_path_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 42536a4..334c392 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -221,6 +221,10 @@ int mesh_add_ext_srates_ie(struct sk_buff *skb,
 			   struct ieee80211_sub_if_data *sdata);
 int mesh_add_ds_params_ie(struct sk_buff *skb,
 			  struct ieee80211_sub_if_data *sdata);
+int mesh_add_ht_cap_ie(struct sk_buff *skb,
+		       struct ieee80211_sub_if_data *sdata);
+int mesh_add_ht_info_ie(struct sk_buff *skb,
+			struct ieee80211_sub_if_data *sdata);
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_init(void);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index f8c9666..8f068b1 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -158,6 +158,8 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
 			    2 + sdata->u.mesh.mesh_id_len +
 			    2 + sizeof(struct ieee80211_meshconf_ie) +
+			    2 + sizeof(struct ieee80211_ht_cap) +
+			    2 + sizeof(struct ieee80211_ht_info) +
 			    2 + 8 + /* peering IE */
 			    sdata->u.mesh.ie_len);
 	if (!skb)
@@ -234,6 +236,13 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		memcpy(pos, &reason, 2);
 		pos += 2;
 	}
+
+	if (action != WLAN_SP_MESH_PEERING_CLOSE) {
+		if (mesh_add_ht_cap_ie(skb, sdata) ||
+		    mesh_add_ht_info_ie(skb, sdata))
+			return -1;
+	}
+
 	if (mesh_add_vendor_ies(skb, sdata))
 		return -1;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ba1956a..173b40b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2284,6 +2284,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 				    2 + 8 + /* supported rates */
 				    2 + 3 + /* DS params */
 				    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
+				    2 + sizeof(struct ieee80211_ht_cap) +
+				    2 + sizeof(struct ieee80211_ht_info) +
 				    2 + sdata->u.mesh.mesh_id_len +
 				    2 + sizeof(struct ieee80211_meshconf_ie) +
 				    sdata->u.mesh.ie_len);
@@ -2312,6 +2314,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		    mesh_add_ds_params_ie(skb, sdata) ||
 		    mesh_add_ext_srates_ie(skb, sdata) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
+		    mesh_add_ht_cap_ie(skb, sdata) ||
+		    mesh_add_ht_info_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata) ||
 		    mesh_add_vendor_ies(skb, sdata)) {
-- 
1.7.4.1

