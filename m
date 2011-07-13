Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46304 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab1GMXqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 19:46:12 -0400
Received: by mail-iy0-f174.google.com with SMTP id 12so5995000iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 16:46:12 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 3/5] mac80211: Ext. Supported Rates go in mesh beacon tail
Date: Wed, 13 Jul 2011 16:45:45 -0700
Message-Id: <1310600747-9583-4-git-send-email-thomas@cozybit.com> (sfid-20110714_014620_367205_22860080)
In-Reply-To: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Give mesh beacon a tail and maintain Extended Supported Rates IE here.
Reorder construction of mesh beacon frame so it looks like:

head | tail | mesh IEs | vendor IEs

mesh IEs include dynamic elements which must be updated on each beacon.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |   41 ++++++++++++++++++++++-------------------
 net/mac80211/tx.c   |    4 ++--
 2 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 70bfa96..7c10b97 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -207,26 +207,9 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
 
 void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
 	u8 *pos;
-	int len, i, rate;
 	u8 neighbors;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	len = sband->n_bitrates;
-	if (len > 8)
-		len = 8;
-	if (sband->n_bitrates > len) {
-		pos = skb_put(skb, sband->n_bitrates - len + 2);
-		*pos++ = WLAN_EID_EXT_SUPP_RATES;
-		*pos++ = sband->n_bitrates - len;
-		for (i = len; i < sband->n_bitrates; i++) {
-			rate = sband->bitrates[i].bitrate;
-			*pos++ = (u8) (rate / 5);
-		}
-	}
-
 	pos = skb_put(skb, 2 + sdata->u.mesh.mesh_id_len);
 	*pos++ = WLAN_EID_MESH_ID;
 	*pos++ = sdata->u.mesh.mesh_id_len;
@@ -452,8 +435,8 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *channel = local->hw.conf.channel;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
-	int rates, i;
-	u8 *pos;
+	int rates, exrates, i;
+	u8 *pos, *bcn_tail;
 
 	local->fif_other_bss++;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
@@ -472,6 +455,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	rates = sband->n_bitrates;
 	if (rates > 8)
 		rates = 8;
+	exrates = sband->n_bitrates - rates;
 	for (i = 0; i < rates; i++) {
 		int rate = sband->bitrates[i].bitrate;
 		supp_rates[i] = (u8) (rate / 5);
@@ -519,7 +503,26 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 		*pos++ = ieee80211_frequency_to_channel(channel->center_freq);
 	}
 
+	/* Build beacon tail */
+	bcn_params.tail_len = 2 + exrates; /* extended rates */
+	pos = kmalloc(bcn_params.tail_len, GFP_KERNEL | __GFP_ZERO);
+	if (pos == NULL) {
+		printk(KERN_ERR "Unable to allocate mesh beacon tail\n");
+		return;
+	}
+	bcn_tail = pos;
+
+	if (exrates) {
+		*pos++ = WLAN_EID_EXT_SUPP_RATES;
+		*pos++ = exrates;
+		for (i = rates; i < sband->n_bitrates; i++) {
+			int rate = sband->bitrates[i].bitrate;
+			*pos++ = (u8) (rate / 5);
+		}
+	}
+
 	bcn_params.head = (char *) bcn_head;
+	bcn_params.tail = bcn_tail;
 	bcn_params.dtim_period = 1;	/* unused for now */
 
 	if (mac80211_config_ops.add_beacon(sdata->wdev.wiphy, sdata->dev,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c406b13..e1389e8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2269,11 +2269,11 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 			memcpy(skb_put(skb, beacon->head_len), beacon->head,
 			       beacon->head_len);
 
-			mesh_mgmt_ies_add(skb, sdata);
-
 			if (beacon->tail && beacon->tail_len)
 				memcpy(skb_put(skb, beacon->tail_len),
 				       beacon->tail, beacon->tail_len);
+
+			mesh_mgmt_ies_add(skb, sdata);
 		}
 	} else {
 		WARN_ON(1);
-- 
1.7.6

