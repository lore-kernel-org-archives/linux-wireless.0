Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44884 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1IZKzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 06:55:07 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so3462643eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 03:55:06 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalyan C Gaddam <chakkal@iit.edu>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/5] mac80211: standardize adding supported rates IEs
Date: Mon, 26 Sep 2011 13:54:50 +0300
Message-Id: <1317034493-5300-3-git-send-email-arik@wizery.com> (sfid-20110926_125512_356894_083653B1)
In-Reply-To: <1317034493-5300-1-git-send-email-arik@wizery.com>
References: <1317034493-5300-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Relocate the mesh implementation of adding the (extended) supported
rates IE to util.c, anticipating its use by other parts of mac80211.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Cc: Kalyan C Gaddam <chakkal@iit.edu>
---
 include/net/mac80211.h    |    5 ++++
 net/mac80211/mesh.c       |   58 --------------------------------------------
 net/mac80211/mesh.h       |    4 ---
 net/mac80211/mesh_plink.c |    4 +-
 net/mac80211/tx.c         |    4 +-
 net/mac80211/util.c       |   59 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 68 insertions(+), 66 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c0f63fd..4dfead6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3439,4 +3439,9 @@ void ieee80211_enable_rssi_reports(struct ieee80211_vif *vif,
 				   int rssi_max_thold);
 
 void ieee80211_disable_rssi_reports(struct ieee80211_vif *vif);
+
+int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb);
+
+int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
+				struct sk_buff *skb);
 #endif /* MAC80211_H */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a4225ae..a7078fd 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -320,64 +320,6 @@ mesh_add_rsn_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	return 0;
 }
 
-int
-mesh_add_srates_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
-	int rate;
-	u8 i, rates, *pos;
-
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	rates = sband->n_bitrates;
-	if (rates > 8)
-		rates = 8;
-
-	if (skb_tailroom(skb) < rates + 2)
-		return -ENOMEM;
-
-	pos = skb_put(skb, rates + 2);
-	*pos++ = WLAN_EID_SUPP_RATES;
-	*pos++ = rates;
-	for (i = 0; i < rates; i++) {
-		rate = sband->bitrates[i].bitrate;
-		*pos++ = (u8) (rate / 5);
-	}
-
-	return 0;
-}
-
-int
-mesh_add_ext_srates_ie(struct sk_buff *skb,
-		       struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
-	int rate;
-	u8 i, exrates, *pos;
-
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	exrates = sband->n_bitrates;
-	if (exrates > 8)
-		exrates -= 8;
-	else
-		exrates = 0;
-
-	if (skb_tailroom(skb) < exrates + 2)
-		return -ENOMEM;
-
-	if (exrates) {
-		pos = skb_put(skb, exrates + 2);
-		*pos++ = WLAN_EID_EXT_SUPP_RATES;
-		*pos++ = exrates;
-		for (i = 8; i < sband->n_bitrates; i++) {
-			rate = sband->bitrates[i].bitrate;
-			*pos++ = (u8) (rate / 5);
-		}
-	}
-	return 0;
-}
-
 int mesh_add_ds_params_ie(struct sk_buff *skb,
 			  struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 7118e8e..8c00e2d 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -210,10 +210,6 @@ int mesh_add_rsn_ie(struct sk_buff *skb,
 		    struct ieee80211_sub_if_data *sdata);
 int mesh_add_vendor_ies(struct sk_buff *skb,
 			struct ieee80211_sub_if_data *sdata);
-int mesh_add_srates_ie(struct sk_buff *skb,
-		       struct ieee80211_sub_if_data *sdata);
-int mesh_add_ext_srates_ie(struct sk_buff *skb,
-			   struct ieee80211_sub_if_data *sdata);
 int mesh_add_ds_params_ie(struct sk_buff *skb,
 			  struct ieee80211_sub_if_data *sdata);
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 1213a23..9cc5029 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -185,8 +185,8 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			pos = skb_put(skb, 2);
 			memcpy(pos + 2, &plid, 2);
 		}
-		if (mesh_add_srates_ie(skb, sdata) ||
-		    mesh_add_ext_srates_ie(skb, sdata) ||
+		if (ieee80211_add_srates_ie(&sdata->vif, skb) ||
+		    ieee80211_add_ext_srates_ie(&sdata->vif, skb) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata))
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7cd6c28..542272a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2307,9 +2307,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		*pos++ = WLAN_EID_SSID;
 		*pos++ = 0x0;
 
-		if (mesh_add_srates_ie(skb, sdata) ||
+		if (ieee80211_add_srates_ie(&sdata->vif, skb) ||
 		    mesh_add_ds_params_ie(skb, sdata) ||
-		    mesh_add_ext_srates_ie(skb, sdata) ||
+		    ieee80211_add_ext_srates_ie(&sdata->vif, skb) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata) ||
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4b1466d..6926c99 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1353,3 +1353,62 @@ void ieee80211_disable_rssi_reports(struct ieee80211_vif *vif)
 	_ieee80211_enable_rssi_reports(sdata, 0, 0);
 }
 EXPORT_SYMBOL(ieee80211_disable_rssi_reports);
+
+int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	int rate;
+	u8 i, rates, *pos;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	rates = sband->n_bitrates;
+	if (rates > 8)
+		rates = 8;
+
+	if (skb_tailroom(skb) < rates + 2)
+		return -ENOMEM;
+
+	pos = skb_put(skb, rates + 2);
+	*pos++ = WLAN_EID_SUPP_RATES;
+	*pos++ = rates;
+	for (i = 0; i < rates; i++) {
+		rate = sband->bitrates[i].bitrate;
+		*pos++ = (u8) (rate / 5);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ieee80211_add_srates_ie);
+
+int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	int rate;
+	u8 i, exrates, *pos;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	exrates = sband->n_bitrates;
+	if (exrates > 8)
+		exrates -= 8;
+	else
+		exrates = 0;
+
+	if (skb_tailroom(skb) < exrates + 2)
+		return -ENOMEM;
+
+	if (exrates) {
+		pos = skb_put(skb, exrates + 2);
+		*pos++ = WLAN_EID_EXT_SUPP_RATES;
+		*pos++ = exrates;
+		for (i = 8; i < sband->n_bitrates; i++) {
+			rate = sband->bitrates[i].bitrate;
+			*pos++ = (u8) (rate / 5);
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL(ieee80211_add_ext_srates_ie);
\ No newline at end of file
-- 
1.7.4.1

