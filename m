Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46304 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1GMXqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 19:46:10 -0400
Received: by mail-iy0-f174.google.com with SMTP id 12so5995000iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 16:46:10 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/5] mac80211: correct mesh beacon head
Date: Wed, 13 Jul 2011 16:45:44 -0700
Message-Id: <1310600747-9583-3-git-send-email-thomas@cozybit.com> (sfid-20110714_014619_826297_F0360E94)
In-Reply-To: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Supported Rates and DS Parameter elements go in the beacon head. Add
these IEs when we initially construct the beacon.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 60fd958..70bfa96 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -217,14 +217,6 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	len = sband->n_bitrates;
 	if (len > 8)
 		len = 8;
-	pos = skb_put(skb, len + 2);
-	*pos++ = WLAN_EID_SUPP_RATES;
-	*pos++ = len;
-	for (i = 0; i < len; i++) {
-		rate = sband->bitrates[i].bitrate;
-		*pos++ = (u8) (rate / 5);
-	}
-
 	if (sband->n_bitrates > len) {
 		pos = skb_put(skb, sband->n_bitrates - len + 2);
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
@@ -235,13 +227,6 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 		}
 	}
 
-	if (sband->band == IEEE80211_BAND_2GHZ) {
-		pos = skb_put(skb, 2 + 1);
-		*pos++ = WLAN_EID_DS_PARAMS;
-		*pos++ = 1;
-		*pos++ = ieee80211_frequency_to_channel(local->hw.conf.channel->center_freq);
-	}
-
 	pos = skb_put(skb, 2 + sdata->u.mesh.mesh_id_len);
 	*pos++ = WLAN_EID_MESH_ID;
 	*pos++ = sdata->u.mesh.mesh_id_len;
@@ -464,6 +449,10 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_mgmt *bcn_head;
 	struct beacon_parameters bcn_params;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *channel = local->hw.conf.channel;
+	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
+	int rates, i;
 	u8 *pos;
 
 	local->fif_other_bss++;
@@ -478,11 +467,22 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_mesh_root_setup(ifmsh);
 	ieee80211_queue_work(&local->hw, &sdata->work);
 
+	/* build supported rates array */
+	sband = local->hw.wiphy->bands[channel->band];
+	rates = sband->n_bitrates;
+	if (rates > 8)
+		rates = 8;
+	for (i = 0; i < rates; i++) {
+		int rate = sband->bitrates[i].bitrate;
+		supp_rates[i] = (u8) (rate / 5);
+	}
+
 	/* Build fixed part of mesh beacon. */
 	memset(&bcn_params, 0, sizeof(struct beacon_parameters));
 
-	/* header + fixed fields + null ssid */
-	bcn_params.head_len = 24 + sizeof(bcn_head->u.beacon) + 2;
+	/* header + fixed fields + null ssid + supp rates + DS params */
+	bcn_params.head_len = 24 + sizeof(bcn_head->u.beacon) + 2 +
+			      (2 + rates) + 3;
 	pos = kmalloc(bcn_params.head_len, GFP_KERNEL | __GFP_ZERO);
 	if (pos == NULL) {
 		printk(KERN_ERR "Unable to allocate mesh beacon\n");
@@ -506,6 +506,19 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	*pos++ = WLAN_EID_SSID;
 	*pos++ = 0x0;
 
+	/* supported rates */
+	*pos++ = WLAN_EID_SUPP_RATES;
+	*pos++ = rates;
+	memcpy(pos, supp_rates, rates);
+	pos += rates;
+
+	/* DS parameter set */
+	if (sband->band == IEEE80211_BAND_2GHZ) {
+		*pos++ = WLAN_EID_DS_PARAMS;
+		*pos++ = 1;
+		*pos++ = ieee80211_frequency_to_channel(channel->center_freq);
+	}
+
 	bcn_params.head = (char *) bcn_head;
 	bcn_params.dtim_period = 1;	/* unused for now */
 
-- 
1.7.6

