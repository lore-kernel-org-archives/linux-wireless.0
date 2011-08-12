Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58299 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1HLCf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 22:35:27 -0400
Received: by iye16 with SMTP id 16so609089iye.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 19:35:26 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v3 1/6] mac80211: fix mesh beacon format
Date: Thu, 11 Aug 2011 19:35:10 -0700
Message-Id: <1313116515-26166-1-git-send-email-thomas@cozybit.com> (sfid-20110812_043530_401376_8195EFC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct ordering of IEs in the mesh beacon while removing unneeded IEs
from mesh peering frames. Set privacy bit in capability info if security
is enabled. Add utility functions to aid in construction
of IEs and reduce code duplication.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c       |  223 +++++++++++++++++++++++++++++++++------------
 net/mac80211/mesh.h       |   14 +++
 net/mac80211/mesh_plink.c |    7 +-
 net/mac80211/tx.c         |   14 +++-
 4 files changed, 196 insertions(+), 62 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 29e9980..1990869 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -204,36 +204,185 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
 	return 0;
 }
 
-void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
+int
+mesh_add_meshconf_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u8 *pos, neighbors;
+	u8 meshconf_len = sizeof(struct ieee80211_meshconf_ie);
+
+	if (skb_tailroom(skb) < 2 + meshconf_len)
+		return -ENOMEM;
+
+	pos = skb_put(skb, 2 + meshconf_len);
+	*pos++ = WLAN_EID_MESH_CONFIG;
+	*pos++ = meshconf_len;
+
+	/* Active path selection protocol ID */
+	*pos++ = ifmsh->mesh_pp_id;
+	/* Active path selection metric ID   */
+	*pos++ = ifmsh->mesh_pm_id;
+	/* Congestion control mode identifier */
+	*pos++ = ifmsh->mesh_cc_id;
+	/* Synchronization protocol identifier */
+	*pos++ = ifmsh->mesh_sp_id;
+	/* Authentication Protocol identifier */
+	*pos++ = ifmsh->mesh_auth_id;
+	/* Mesh Formation Info - number of neighbors */
+	neighbors = atomic_read(&ifmsh->mshstats.estab_plinks);
+	/* Number of neighbor mesh STAs or 15 whichever is smaller */
+	neighbors = (neighbors > 15) ? 15 : neighbors;
+	*pos++ = neighbors << 1;
+	/* Mesh capability */
+	ifmsh->accepting_plinks = mesh_plink_availables(sdata);
+	*pos = MESHCONF_CAPAB_FORWARDING;
+	*pos++ |= ifmsh->accepting_plinks ?
+	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
+	*pos++ = 0x00;
+
+	return 0;
+}
+
+int
+mesh_add_meshid_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u8 *pos;
+
+	if (skb_tailroom(skb) < 2 + ifmsh->mesh_id_len)
+		return -ENOMEM;
+
+	pos = skb_put(skb, 2 + ifmsh->mesh_id_len);
+	*pos++ = WLAN_EID_MESH_ID;
+	*pos++ = ifmsh->mesh_id_len;
+	if (ifmsh->mesh_id_len)
+		memcpy(pos, ifmsh->mesh_id, ifmsh->mesh_id_len);
+
+	return 0;
+}
+
+int
+mesh_add_vendor_ies(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u8 offset, len;
+	const u8 *data;
+
+	if (!ifmsh->ie || !ifmsh->ie_len)
+		return 0;
+
+	/* fast-forward to vendor IEs */
+	offset = ieee80211_ie_split_vendor(ifmsh->ie, ifmsh->ie_len, 0);
+
+	if (offset) {
+		len = ifmsh->ie_len - offset;
+		data = ifmsh->ie + offset;
+		if (skb_tailroom(skb) < len)
+			return -ENOMEM;
+		memcpy(skb_put(skb, len), data, len);
+	}
+
+	return 0;
+}
+
+int
+mesh_add_rsn_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u8 len = 0;
+	const u8 *data;
+
+	if (!ifmsh->ie || !ifmsh->ie_len)
+		return 0;
+
+	/* find RSN IE */
+	data = ifmsh->ie;
+	while (data < ifmsh->ie + ifmsh->ie_len) {
+		if (*data == WLAN_EID_RSN) {
+			len = data[1] + 2;
+			break;
+		}
+		data++;
+	}
+
+	if (len) {
+		if (skb_tailroom(skb) < len)
+			return -ENOMEM;
+		memcpy(skb_put(skb, len), data, len);
+	}
+
+	return 0;
+}
+
+int
+mesh_add_srates_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
-	u8 *pos;
-	int len, i, rate;
-	u8 neighbors;
+	int rate;
+	u8 i, rates, *pos;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	len = sband->n_bitrates;
-	if (len > 8)
-		len = 8;
-	pos = skb_put(skb, len + 2);
+	rates = sband->n_bitrates;
+	if (rates > 8)
+		rates = 8;
+
+	if (skb_tailroom(skb) < rates + 2)
+		return -ENOMEM;
+
+	pos = skb_put(skb, rates + 2);
 	*pos++ = WLAN_EID_SUPP_RATES;
-	*pos++ = len;
-	for (i = 0; i < len; i++) {
+	*pos++ = rates;
+	for (i = 0; i < rates; i++) {
 		rate = sband->bitrates[i].bitrate;
 		*pos++ = (u8) (rate / 5);
 	}
 
-	if (sband->n_bitrates > len) {
-		pos = skb_put(skb, sband->n_bitrates - len + 2);
+	return 0;
+}
+
+int
+mesh_add_ext_srates_ie(struct sk_buff *skb,
+		       struct ieee80211_sub_if_data *sdata)
+{
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
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
-		*pos++ = sband->n_bitrates - len;
-		for (i = len; i < sband->n_bitrates; i++) {
+		*pos++ = exrates;
+		for (i = 8; i < sband->n_bitrates; i++) {
 			rate = sband->bitrates[i].bitrate;
 			*pos++ = (u8) (rate / 5);
 		}
 	}
+	return 0;
+}
+
+int mesh_add_ds_params_ie(struct sk_buff *skb,
+			  struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	u8 *pos;
+
+	if (skb_tailroom(skb) < 3)
+		return -ENOMEM;
 
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	if (sband->band == IEEE80211_BAND_2GHZ) {
 		pos = skb_put(skb, 2 + 1);
 		*pos++ = WLAN_EID_DS_PARAMS;
@@ -241,53 +390,9 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 		*pos++ = ieee80211_frequency_to_channel(local->hw.conf.channel->center_freq);
 	}
 
-	pos = skb_put(skb, 2 + sdata->u.mesh.mesh_id_len);
-	*pos++ = WLAN_EID_MESH_ID;
-	*pos++ = sdata->u.mesh.mesh_id_len;
-	if (sdata->u.mesh.mesh_id_len)
-		memcpy(pos, sdata->u.mesh.mesh_id, sdata->u.mesh.mesh_id_len);
-
-	pos = skb_put(skb, 2 + sizeof(struct ieee80211_meshconf_ie));
-	*pos++ = WLAN_EID_MESH_CONFIG;
-	*pos++ = sizeof(struct ieee80211_meshconf_ie);
-
-	/* Active path selection protocol ID */
-	*pos++ = sdata->u.mesh.mesh_pp_id;
-
-	/* Active path selection metric ID   */
-	*pos++ = sdata->u.mesh.mesh_pm_id;
-
-	/* Congestion control mode identifier */
-	*pos++ = sdata->u.mesh.mesh_cc_id;
-
-	/* Synchronization protocol identifier */
-	*pos++ = sdata->u.mesh.mesh_sp_id;
-
-	/* Authentication Protocol identifier */
-	*pos++ = sdata->u.mesh.mesh_auth_id;
-
-	/* Mesh Formation Info - number of neighbors */
-	neighbors = atomic_read(&sdata->u.mesh.mshstats.estab_plinks);
-	/* Number of neighbor mesh STAs or 15 whichever is smaller */
-	neighbors = (neighbors > 15) ? 15 : neighbors;
-	*pos++ = neighbors << 1;
-
-	/* Mesh capability */
-	sdata->u.mesh.accepting_plinks = mesh_plink_availables(sdata);
-	*pos = MESHCONF_CAPAB_FORWARDING;
-	*pos++ |= sdata->u.mesh.accepting_plinks ?
-	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
-	*pos++ = 0x00;
-
-	if (sdata->u.mesh.ie) {
-		int len = sdata->u.mesh.ie_len;
-		const u8 *data = sdata->u.mesh.ie;
-		if (skb_tailroom(skb) > len)
-			memcpy(skb_put(skb, len), data, len);
-	}
+	return 0;
 }
 
-
 static void ieee80211_mesh_path_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 249e733..b794360 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -199,6 +199,20 @@ bool mesh_matches_local(struct ieee802_11_elems *ie,
 void mesh_ids_set_default(struct ieee80211_if_mesh *mesh);
 void mesh_mgmt_ies_add(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
+int mesh_add_meshconf_ie(struct sk_buff *skb,
+			 struct ieee80211_sub_if_data *sdata);
+int mesh_add_meshid_ie(struct sk_buff *skb,
+		       struct ieee80211_sub_if_data *sdata);
+int mesh_add_rsn_ie(struct sk_buff *skb,
+		    struct ieee80211_sub_if_data *sdata);
+int mesh_add_vendor_ies(struct sk_buff *skb,
+			struct ieee80211_sub_if_data *sdata);
+int mesh_add_srates_ie(struct sk_buff *skb,
+		       struct ieee80211_sub_if_data *sdata);
+int mesh_add_ext_srates_ie(struct sk_buff *skb,
+			   struct ieee80211_sub_if_data *sdata);
+int mesh_add_ds_params_ie(struct sk_buff *skb,
+			  struct ieee80211_sub_if_data *sdata);
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_init(void);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index f4adc09..e4113f2 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -195,7 +195,12 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			memset(pos, 0, 2);
 			memcpy(pos + 2, &plid, 2);
 		}
-		mesh_mgmt_ies_add(skb, sdata);
+		if (mesh_add_srates_ie(skb, sdata) ||
+		    mesh_add_ext_srates_ie(skb, sdata) ||
+		    mesh_add_rsn_ie(skb, sdata) ||
+		    mesh_add_meshid_ie(skb, sdata) ||
+		    mesh_add_meshconf_ie(skb, sdata))
+			return -1;
 	}
 
 	/* Add Peer Link Management element */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 69fd494..0107263 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2295,13 +2295,23 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 		mgmt->u.beacon.beacon_int =
 			cpu_to_le16(sdata->vif.bss_conf.beacon_int);
-		mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
+		mgmt->u.beacon.capab_info |= cpu_to_le16(
+			sdata->u.mesh.security ? WLAN_CAPABILITY_PRIVACY : 0);
 
 		pos = skb_put(skb, 2);
 		*pos++ = WLAN_EID_SSID;
 		*pos++ = 0x0;
 
-		mesh_mgmt_ies_add(skb, sdata);
+		if (mesh_add_srates_ie(skb, sdata) ||
+		    mesh_add_ds_params_ie(skb, sdata) ||
+		    mesh_add_ext_srates_ie(skb, sdata) ||
+		    mesh_add_rsn_ie(skb, sdata) ||
+		    mesh_add_meshid_ie(skb, sdata) ||
+		    mesh_add_meshconf_ie(skb, sdata) ||
+		    mesh_add_vendor_ies(skb, sdata)) {
+			pr_err("o11s: couldn't add ies!\n");
+			goto out;
+		}
 	} else {
 		WARN_ON(1);
 		goto out;
-- 
1.7.4.1

