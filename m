Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49168 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1JTSe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 14:34:59 -0400
Received: by mail-gy0-f174.google.com with SMTP id 13so3086542gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 11:34:59 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 2/6] mac80211: add HT IEs to mesh frames
Date: Thu, 20 Oct 2011 11:34:35 -0700
Message-Id: <1319135679-6740-3-git-send-email-thomas@cozybit.com> (sfid-20111020_203501_291401_8754FAB8)
In-Reply-To: <1319135679-6740-1-git-send-email-thomas@cozybit.com>
References: <1319135679-6740-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Ashok Nagarajan <anagar6@uic.edu>
---
 net/mac80211/mesh.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/mesh.h       |    4 ++++
 net/mac80211/mesh_plink.c |    9 +++++++++
 net/mac80211/tx.c         |    4 ++++
 4 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a7078fd..2dc76a9 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -341,6 +341,49 @@ int mesh_add_ds_params_ie(struct sk_buff *skb,
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
index 8c00e2d..0f2c4e6 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -212,6 +212,10 @@ int mesh_add_vendor_ies(struct sk_buff *skb,
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
index 42a0544..bbfbd45 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -168,6 +168,8 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
 			    2 + sdata->u.mesh.mesh_id_len +
 			    2 + sizeof(struct ieee80211_meshconf_ie) +
+			    2 + sizeof(struct ieee80211_ht_cap) +
+			    2 + sizeof(struct ieee80211_ht_info) +
 			    2 + 8 + /* peering IE */
 			    sdata->u.mesh.ie_len);
 	if (!skb)
@@ -244,6 +246,13 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
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
index f28a920..faca189 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2290,6 +2290,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 				    2 + 8 + /* supported rates */
 				    2 + 3 + /* DS params */
 				    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
+				    2 + sizeof(struct ieee80211_ht_cap) +
+				    2 + sizeof(struct ieee80211_ht_info) +
 				    2 + sdata->u.mesh.mesh_id_len +
 				    2 + sizeof(struct ieee80211_meshconf_ie) +
 				    sdata->u.mesh.ie_len);
@@ -2318,6 +2320,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		    mesh_add_ds_params_ie(skb, sdata) ||
 		    ieee80211_add_ext_srates_ie(&sdata->vif, skb) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
+		    mesh_add_ht_cap_ie(skb, sdata) ||
+		    mesh_add_ht_info_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata) ||
 		    mesh_add_vendor_ies(skb, sdata)) {
-- 
1.7.5.4

