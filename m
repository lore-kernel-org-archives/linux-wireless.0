Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f51.google.com ([74.125.83.51]:58234 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646Ab1CDDMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 22:12:01 -0500
Received: by mail-gw0-f51.google.com with SMTP id 15so917880gwb.10
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 19:12:01 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Javier Cardona <javier@cozybit.com>
Subject: [PATCH 6/7] mac80211: Parse RSN information element to determine if a peer needs authentication
Date: Thu,  3 Mar 2011 19:11:46 -0800
Message-Id: <1299208307-9428-7-git-send-email-thomas@cozybit.com>
In-Reply-To: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
Tested-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/ieee80211.h  |   19 +++++++++++++++++
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mesh.c        |   26 ++++++++++++++++++++++-
 net/mac80211/mesh.h        |    2 +-
 net/mac80211/mesh_plink.c  |    8 ++++++-
 net/mac80211/util.c        |   49 ++++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 100 insertions(+), 6 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 294169e..5253a01 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -593,6 +593,25 @@ struct ieee80211_tim_ie {
 } __attribute__ ((packed));
 
 /**
+ * struct ieee80211_rsn_ie
+ *
+ * This structure is used to parse a "Robust Security Network element".  After
+ * parsing, the pointers will point to *_count number of elements (e.g. if
+ * p_cipher_count is 3, p_cipher_suites will point to 3 suites).
+ */
+struct ieee80211_rsn_ie {
+	u16 version;
+	u8 *g_cipher_suite;
+	u16 p_cipher_count;
+	u8 *p_cipher_suites;
+	u16 akm_count;
+	u8 *akm_suites;
+	u16 capa;
+	u16 pkmid_count;
+	u8 *pkmids;
+};
+
+/**
  * struct ieee80211_meshconf_ie
  *
  * This structure refers to "Mesh Configuration information element"
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index fc27222..eb838e7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -994,7 +994,7 @@ struct ieee802_11_elems {
 	u8 *ibss_params;
 	u8 *challenge;
 	u8 *wpa;
-	u8 *rsn;
+	struct ieee80211_rsn_ie rsn;
 	u8 *erp_info;
 	u8 *ext_supp_rates;
 	u8 *wmm_info;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index c0635c5..ab5ff5c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -58,6 +58,29 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 }
 
 /**
+ * mesh_peer_supports_sae - inspect RSN IE to see if an mp can do SAE auth
+ *
+ * @ie: information elements of a management frame from the mesh peer
+ */
+bool mesh_peer_supports_sae(struct ieee802_11_elems *ie)
+{
+	int i;
+	u8 *akm;
+	u8 sae_akm_suite[4] = { 0x00, 0x0f, 0xac, 0x08 };
+
+	if (ie->rsn.akm_count && ie->rsn.akm_suites) {
+		akm = ie->rsn.akm_suites;
+		for (i = 0; i < ie->rsn.akm_count; i++) {
+			if (memcmp(akm, sae_akm_suite, 4) == 0)
+				return true;
+			akm += 4;
+		}
+	}
+	return false;
+}
+
+
+/**
  * mesh_matches_local - check if the config of a mesh point matches ours
  *
  * @ie: information elements of a management frame from the mesh peer
@@ -595,7 +618,8 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		supp_rates = ieee80211_sta_get_rates(local, &elems, band);
 
 		mesh_neighbour_update(mgmt->sa, supp_rates, sdata,
-				      mesh_peer_accepts_plinks(&elems));
+				      mesh_peer_accepts_plinks(&elems),
+				      mesh_peer_supports_sae(&elems));
 	}
 }
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index b99e230..6a81b35 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -226,7 +226,7 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata);
 /* Mesh plinks */
 void mesh_neighbour_update(u8 *hw_addr, u32 rates,
-		struct ieee80211_sub_if_data *sdata, bool add);
+		struct ieee80211_sub_if_data *sdata, bool add, bool rsn_enbld);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 44b5393..5a845fd 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -238,7 +238,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 }
 
 void mesh_neighbour_update(u8 *hw_addr, u32 rates, struct ieee80211_sub_if_data *sdata,
-			   bool peer_accepting_plinks)
+			   bool peer_accepting_plinks, bool rsn_enabled)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
@@ -252,6 +252,12 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates, struct ieee80211_sub_if_data
 		sta = mesh_plink_alloc(sdata, hw_addr, rates);
 		if (!sta)
 			return;
+		if (!rsn_enabled) {
+			mpl_dbg("Mesh peer %pM needs no auth\n", sta->sta.addr);
+			set_sta_flags(sta, WLAN_STA_AUTH);
+		} else
+			mpl_dbg("Mesh peer %pM needs auth\n", sta->sta.addr);
+
 		if (sta_info_insert_rcu(sta)) {
 			rcu_read_unlock();
 			return;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 556647a..77d10d6 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -573,6 +573,52 @@ void ieee802_11_parse_elems(u8 *start, size_t len,
 	ieee802_11_parse_elems_crc(start, len, elems, 0, 0);
 }
 
+static int parse_rsn_elem(u8 *start, size_t len, struct ieee80211_rsn_ie *rsn)
+{
+	int len_so_far;
+	u8 *pos = start;
+
+	if (len < 2 || !start || !rsn)
+		return -1;
+
+	/* Version is the only mandatory field.  The rest are optional */
+	rsn->version = le16_to_cpu(*(__le16 *) pos);
+	len_so_far = 2;
+	if (len < len_so_far + 4)
+		return len_so_far;
+	rsn->g_cipher_suite = &pos[len_so_far];
+	len_so_far += 4;
+	if (len < len_so_far + 6)
+		return len_so_far;
+	rsn->p_cipher_count = le16_to_cpu(*(__le16 *) &pos[len_so_far]);
+	rsn->p_cipher_suites = &pos[len_so_far + 2];
+	len_so_far +=  2 + rsn->p_cipher_count * 4;
+	if (len < len_so_far + 2) {
+		if (len < len_so_far)
+			rsn->p_cipher_count = le16_to_cpu(0);
+		return len_so_far;
+	}
+	rsn->akm_count = le16_to_cpu(*(__le16 *) &pos[len_so_far]);
+	rsn->akm_suites = &pos[len_so_far + 2];
+	len_so_far += 2 + rsn->akm_count * 4;
+	if (len < len_so_far + 2) {
+		if (len < len_so_far)
+			rsn->akm_count = le16_to_cpu(0);
+		return len_so_far;
+	}
+	rsn->capa = le16_to_cpu(*(__le16 *) &pos[len_so_far]);
+	len_so_far += 2;
+	if (len < len_so_far + 2)
+		return len_so_far;
+	rsn->pkmid_count = le16_to_cpu(*(__le16 *) &pos[len_so_far]);
+	rsn->pkmids = &pos[len_so_far + 2];
+	len_so_far += 2 + rsn->pkmid_count * 16;
+	if (len < len_so_far)
+		rsn->pkmid_count = le16_to_cpu(*(__le16 *) 0);
+	return len_so_far;
+}
+
+
 u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc)
@@ -658,8 +704,7 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			}
 			break;
 		case WLAN_EID_RSN:
-			elems->rsn = pos;
-			elems->rsn_len = elen;
+			parse_rsn_elem(pos, elen, &elems->rsn);
 			break;
 		case WLAN_EID_ERP_INFO:
 			elems->erp_info = pos;
-- 
1.7.0.4

