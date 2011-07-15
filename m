Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56743 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab1GOAup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 20:50:45 -0400
Received: by iyb12 with SMTP id 12so716457iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 17:50:44 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 4/5] mac80211: move RSN IE to tail of mesh beacon
Date: Thu, 14 Jul 2011 17:50:23 -0700
Message-Id: <1310691023-31844-1-git-send-email-thomas@cozybit.com> (sfid-20110715_025048_286762_6FA1A14D)
In-Reply-To: <1310600747-9583-5-git-send-email-thomas@cozybit.com>
References: <1310600747-9583-5-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh specific beacon IEs go right before the vendor IEs. Add a
filter that checks for custom IEs (currently just the RSN IE), which
belong after the TIM, but before HT. Also, ensure we don't add any
custom IEs twice in mesh_mgmt_ies_add().

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---

v2:
	Ensure room for custom IEs in transmitted beacon (Johannes).
	We'll be allocating twice as much space as needed for some IEs
	(in tail_len and again ie_len), but it shouldn't be a big deal.

 net/mac80211/mesh.c |   63 +++++++++++++++++++++++++++++++++++---------------
 net/mac80211/tx.c   |    7 +++--
 2 files changed, 48 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 7c10b97..b4bddf2 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -207,52 +207,61 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
 
 void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u8 *pos;
 	u8 neighbors;
+	u8 offset = 0, noffset;
 
-	pos = skb_put(skb, 2 + sdata->u.mesh.mesh_id_len);
+	pos = skb_put(skb, 2 + ifmsh->mesh_id_len);
 	*pos++ = WLAN_EID_MESH_ID;
-	*pos++ = sdata->u.mesh.mesh_id_len;
-	if (sdata->u.mesh.mesh_id_len)
-		memcpy(pos, sdata->u.mesh.mesh_id, sdata->u.mesh.mesh_id_len);
+	*pos++ = ifmsh->mesh_id_len;
+	if (ifmsh->mesh_id_len)
+		memcpy(pos, ifmsh->mesh_id, ifmsh->mesh_id_len);
 
 	pos = skb_put(skb, 2 + sizeof(struct ieee80211_meshconf_ie));
 	*pos++ = WLAN_EID_MESH_CONFIG;
 	*pos++ = sizeof(struct ieee80211_meshconf_ie);
 
 	/* Active path selection protocol ID */
-	*pos++ = sdata->u.mesh.mesh_pp_id;
+	*pos++ = ifmsh->mesh_pp_id;
 
 	/* Active path selection metric ID   */
-	*pos++ = sdata->u.mesh.mesh_pm_id;
+	*pos++ = ifmsh->mesh_pm_id;
 
 	/* Congestion control mode identifier */
-	*pos++ = sdata->u.mesh.mesh_cc_id;
+	*pos++ = ifmsh->mesh_cc_id;
 
 	/* Synchronization protocol identifier */
-	*pos++ = sdata->u.mesh.mesh_sp_id;
+	*pos++ = ifmsh->mesh_sp_id;
 
 	/* Authentication Protocol identifier */
-	*pos++ = sdata->u.mesh.mesh_auth_id;
+	*pos++ = ifmsh->mesh_auth_id;
 
 	/* Mesh Formation Info - number of neighbors */
-	neighbors = atomic_read(&sdata->u.mesh.mshstats.estab_plinks);
+	neighbors = atomic_read(&ifmsh->mshstats.estab_plinks);
 	/* Number of neighbor mesh STAs or 15 whichever is smaller */
 	neighbors = (neighbors > 15) ? 15 : neighbors;
 	*pos++ = neighbors << 1;
 
 	/* Mesh capability */
-	sdata->u.mesh.accepting_plinks = mesh_plink_availables(sdata);
+	ifmsh->accepting_plinks = mesh_plink_availables(sdata);
 	*pos = MESHCONF_CAPAB_FORWARDING;
-	*pos++ |= sdata->u.mesh.accepting_plinks ?
+	*pos++ |= ifmsh->accepting_plinks ?
 	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
 	*pos++ = 0x00;
 
-	if (sdata->u.mesh.ie) {
-		int len = sdata->u.mesh.ie_len;
-		const u8 *data = sdata->u.mesh.ie;
-		if (skb_tailroom(skb) > len)
+	if (ifmsh->ie) {
+		int len;
+		const u8 *data;
+		/* fast-forward to vendor IEs and add remaining */
+		noffset = ieee80211_ie_split_vendor(ifmsh->ie, ifmsh->ie_len,
+						    offset);
+		if (noffset != offset) {
+			len = ifmsh->ie_len - noffset;
+			data = ifmsh->ie + noffset;
 			memcpy(skb_put(skb, len), data, len);
+			offset = noffset;
+		}
 	}
 }
 
@@ -435,8 +444,8 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *channel = local->hw.conf.channel;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
-	int rates, exrates, i;
-	u8 *pos, *bcn_tail;
+	int rates, exrates, i, len = 0;
+	u8 *pos, *bcn_tail, offset = 0, noffset;
 
 	local->fif_other_bss++;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
@@ -503,8 +512,20 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 		*pos++ = ieee80211_frequency_to_channel(channel->center_freq);
 	}
 
+	/* Check for custom IEs before HT */
+	if (ifmsh->ie_len && ifmsh->ie) {
+		static const u8 tail_ies[] = {
+			WLAN_EID_RSN,
+		};
+		noffset = ieee80211_ie_split(ifmsh->ie, ifmsh->ie_len,
+					     tail_ies, ARRAY_SIZE(tail_ies),
+					     offset);
+		len = noffset - offset;
+	}
+
 	/* Build beacon tail */
-	bcn_params.tail_len = 2 + exrates; /* extended rates */
+	bcn_params.tail_len = 2 + exrates + /* extended rates */
+			      len; /* extra IEs */
 	pos = kmalloc(bcn_params.tail_len, GFP_KERNEL | __GFP_ZERO);
 	if (pos == NULL) {
 		printk(KERN_ERR "Unable to allocate mesh beacon tail\n");
@@ -521,6 +542,10 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 		}
 	}
 
+	memcpy(pos, ifmsh->ie + offset, len);
+	pos += len;
+	offset = noffset;
+
 	bcn_params.head = (char *) bcn_head;
 	bcn_params.tail = bcn_tail;
 	bcn_params.dtim_period = 1;	/* unused for now */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e1389e8..c692ced 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2257,11 +2257,12 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 #endif
 		beacon = rcu_dereference(ifmsh->beacon);
 		if (beacon) {
-			/* headroom, head length, tail length, mesh_ies and
-			 * maximum TIM length */
+			/* headroom, head length, tail length, custom IEs, and
+			 * mesh IEs + maximum TIM length */
 			skb = dev_alloc_skb(local->tx_headroom +
 					    beacon->head_len +
-					    beacon->tail_len + 400);
+					    beacon->tail_len +
+					    ifmsh->ie_len + 400);
 			if (!skb)
 				goto out;
 
-- 
1.7.6

