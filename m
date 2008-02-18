Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:31975 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752950AbYBRCV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 21:21:29 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 2/3] mac80211: move function ieee80211_sta_join_ibss()
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz
Date: Mon, 18 Feb 2008 11:21:15 +0900
Message-ID: <20080218022115.5488.61223.stgit@one> (sfid-20080218_022132_030593_02357C5A)
In-Reply-To: <20080218021448.5488.10305.stgit@one>
References: <20080218021448.5488.10305.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this moves ieee80211_sta_join_ibss() up for the next patch (ibss merge).

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---

 net/mac80211/ieee80211_sta.c |  317 +++++++++++++++++++++---------------------
 1 files changed, 159 insertions(+), 158 deletions(-)


diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 2c7b8be..72d7a86 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2030,6 +2030,165 @@ void ieee80211_rx_bss_list_deinit(struct net_device *dev)
 }
 
 
+static int ieee80211_sta_join_ibss(struct net_device *dev,
+				   struct ieee80211_if_sta *ifsta,
+				   struct ieee80211_sta_bss *bss)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	int res, rates, i, j;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_tx_control control;
+	struct rate_selection ratesel;
+	u8 *pos;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	/* Remove possible STA entries from other IBSS networks. */
+	sta_info_flush(local, NULL);
+
+	if (local->ops->reset_tsf) {
+		/* Reset own TSF to allow time synchronization work. */
+		local->ops->reset_tsf(local_to_hw(local));
+	}
+	memcpy(ifsta->bssid, bss->bssid, ETH_ALEN);
+	res = ieee80211_if_config(dev);
+	if (res)
+		return res;
+
+	local->hw.conf.beacon_int = bss->beacon_int >= 10 ? bss->beacon_int : 10;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	sdata->drop_unencrypted = bss->capability &
+		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
+
+	res = ieee80211_set_freq(local, bss->freq);
+
+	if (local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS) {
+		printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
+		       "%d MHz\n", dev->name, local->oper_channel->center_freq);
+		return -1;
+	}
+
+	/* Set beacon template */
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
+	do {
+		if (!skb)
+			break;
+
+		skb_reserve(skb, local->hw.extra_tx_headroom);
+
+		mgmt = (struct ieee80211_mgmt *)
+			skb_put(skb, 24 + sizeof(mgmt->u.beacon));
+		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
+		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+						   IEEE80211_STYPE_BEACON);
+		memset(mgmt->da, 0xff, ETH_ALEN);
+		memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+		mgmt->u.beacon.beacon_int =
+			cpu_to_le16(local->hw.conf.beacon_int);
+		mgmt->u.beacon.capab_info = cpu_to_le16(bss->capability);
+
+		pos = skb_put(skb, 2 + ifsta->ssid_len);
+		*pos++ = WLAN_EID_SSID;
+		*pos++ = ifsta->ssid_len;
+		memcpy(pos, ifsta->ssid, ifsta->ssid_len);
+
+		rates = bss->supp_rates_len;
+		if (rates > 8)
+			rates = 8;
+		pos = skb_put(skb, 2 + rates);
+		*pos++ = WLAN_EID_SUPP_RATES;
+		*pos++ = rates;
+		memcpy(pos, bss->supp_rates, rates);
+
+		if (bss->band == IEEE80211_BAND_2GHZ) {
+			pos = skb_put(skb, 2 + 1);
+			*pos++ = WLAN_EID_DS_PARAMS;
+			*pos++ = 1;
+			*pos++ = ieee80211_frequency_to_channel(bss->freq);
+		}
+
+		pos = skb_put(skb, 2 + 2);
+		*pos++ = WLAN_EID_IBSS_PARAMS;
+		*pos++ = 2;
+		/* FIX: set ATIM window based on scan results */
+		*pos++ = 0;
+		*pos++ = 0;
+
+		if (bss->supp_rates_len > 8) {
+			rates = bss->supp_rates_len - 8;
+			pos = skb_put(skb, 2 + rates);
+			*pos++ = WLAN_EID_EXT_SUPP_RATES;
+			*pos++ = rates;
+			memcpy(pos, &bss->supp_rates[8], rates);
+		}
+
+		memset(&control, 0, sizeof(control));
+		rate_control_get_rate(dev, sband, skb, &ratesel);
+		if (!ratesel.rate) {
+			printk(KERN_DEBUG "%s: Failed to determine TX rate "
+			       "for IBSS beacon\n", dev->name);
+			break;
+		}
+		control.vif = &sdata->vif;
+		control.tx_rate = ratesel.rate;
+		if (sdata->bss_conf.use_short_preamble &&
+		    ratesel.rate->flags & IEEE80211_RATE_SHORT_PREAMBLE)
+			control.flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
+		control.antenna_sel_tx = local->hw.conf.antenna_sel_tx;
+		control.flags |= IEEE80211_TXCTL_NO_ACK;
+		control.retry_limit = 1;
+
+		ifsta->probe_resp = skb_copy(skb, GFP_ATOMIC);
+		if (ifsta->probe_resp) {
+			mgmt = (struct ieee80211_mgmt *)
+				ifsta->probe_resp->data;
+			mgmt->frame_control =
+				IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+					     IEEE80211_STYPE_PROBE_RESP);
+		} else {
+			printk(KERN_DEBUG "%s: Could not allocate ProbeResp "
+			       "template for IBSS\n", dev->name);
+		}
+
+		if (local->ops->beacon_update &&
+		    local->ops->beacon_update(local_to_hw(local),
+					     skb, &control) == 0) {
+			printk(KERN_DEBUG "%s: Configured IBSS beacon "
+			       "template\n", dev->name);
+			skb = NULL;
+		}
+
+		rates = 0;
+		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+		for (i = 0; i < bss->supp_rates_len; i++) {
+			int bitrate = (bss->supp_rates[i] & 0x7f) * 5;
+			for (j = 0; j < sband->n_bitrates; j++)
+				if (sband->bitrates[j].bitrate == bitrate)
+					rates |= BIT(j);
+		}
+		ifsta->supp_rates_bits[local->hw.conf.channel->band] = rates;
+	} while (0);
+
+	if (skb) {
+		printk(KERN_DEBUG "%s: Failed to configure IBSS beacon "
+		       "template\n", dev->name);
+		dev_kfree_skb(skb);
+	}
+
+	ifsta->state = IEEE80211_IBSS_JOINED;
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
+
+	ieee80211_rx_bss_put(dev, bss);
+
+	return res;
+}
+
+
 static void ieee80211_rx_bss_info(struct net_device *dev,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len,
@@ -2896,164 +3055,6 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 	return -1;
 }
 
-static int ieee80211_sta_join_ibss(struct net_device *dev,
-				   struct ieee80211_if_sta *ifsta,
-				   struct ieee80211_sta_bss *bss)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	int res, rates, i, j;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_tx_control control;
-	struct rate_selection ratesel;
-	u8 *pos;
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_supported_band *sband;
-
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	/* Remove possible STA entries from other IBSS networks. */
-	sta_info_flush(local, NULL);
-
-	if (local->ops->reset_tsf) {
-		/* Reset own TSF to allow time synchronization work. */
-		local->ops->reset_tsf(local_to_hw(local));
-	}
-	memcpy(ifsta->bssid, bss->bssid, ETH_ALEN);
-	res = ieee80211_if_config(dev);
-	if (res)
-		return res;
-
-	local->hw.conf.beacon_int = bss->beacon_int >= 10 ? bss->beacon_int : 10;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	sdata->drop_unencrypted = bss->capability &
-		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
-
-	res = ieee80211_set_freq(local, bss->freq);
-
-	if (local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS) {
-		printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
-		       "%d MHz\n", dev->name, local->oper_channel->center_freq);
-		return -1;
-	}
-
-	/* Set beacon template based on scan results */
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
-	do {
-		if (!skb)
-			break;
-
-		skb_reserve(skb, local->hw.extra_tx_headroom);
-
-		mgmt = (struct ieee80211_mgmt *)
-			skb_put(skb, 24 + sizeof(mgmt->u.beacon));
-		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
-		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-						   IEEE80211_STYPE_BEACON);
-		memset(mgmt->da, 0xff, ETH_ALEN);
-		memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
-		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-		mgmt->u.beacon.beacon_int =
-			cpu_to_le16(local->hw.conf.beacon_int);
-		mgmt->u.beacon.capab_info = cpu_to_le16(bss->capability);
-
-		pos = skb_put(skb, 2 + ifsta->ssid_len);
-		*pos++ = WLAN_EID_SSID;
-		*pos++ = ifsta->ssid_len;
-		memcpy(pos, ifsta->ssid, ifsta->ssid_len);
-
-		rates = bss->supp_rates_len;
-		if (rates > 8)
-			rates = 8;
-		pos = skb_put(skb, 2 + rates);
-		*pos++ = WLAN_EID_SUPP_RATES;
-		*pos++ = rates;
-		memcpy(pos, bss->supp_rates, rates);
-
-		if (bss->band == IEEE80211_BAND_2GHZ) {
-			pos = skb_put(skb, 2 + 1);
-			*pos++ = WLAN_EID_DS_PARAMS;
-			*pos++ = 1;
-			*pos++ = ieee80211_frequency_to_channel(bss->freq);
-		}
-
-		pos = skb_put(skb, 2 + 2);
-		*pos++ = WLAN_EID_IBSS_PARAMS;
-		*pos++ = 2;
-		/* FIX: set ATIM window based on scan results */
-		*pos++ = 0;
-		*pos++ = 0;
-
-		if (bss->supp_rates_len > 8) {
-			rates = bss->supp_rates_len - 8;
-			pos = skb_put(skb, 2 + rates);
-			*pos++ = WLAN_EID_EXT_SUPP_RATES;
-			*pos++ = rates;
-			memcpy(pos, &bss->supp_rates[8], rates);
-		}
-
-		memset(&control, 0, sizeof(control));
-		rate_control_get_rate(dev, sband, skb, &ratesel);
-		if (!ratesel.rate) {
-			printk(KERN_DEBUG "%s: Failed to determine TX rate "
-			       "for IBSS beacon\n", dev->name);
-			break;
-		}
-		control.vif = &sdata->vif;
-		control.tx_rate = ratesel.rate;
-		if (sdata->bss_conf.use_short_preamble &&
-		    ratesel.rate->flags & IEEE80211_RATE_SHORT_PREAMBLE)
-			control.flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
-		control.antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-		control.flags |= IEEE80211_TXCTL_NO_ACK;
-		control.retry_limit = 1;
-
-		ifsta->probe_resp = skb_copy(skb, GFP_ATOMIC);
-		if (ifsta->probe_resp) {
-			mgmt = (struct ieee80211_mgmt *)
-				ifsta->probe_resp->data;
-			mgmt->frame_control =
-				IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					     IEEE80211_STYPE_PROBE_RESP);
-		} else {
-			printk(KERN_DEBUG "%s: Could not allocate ProbeResp "
-			       "template for IBSS\n", dev->name);
-		}
-
-		if (local->ops->beacon_update &&
-		    local->ops->beacon_update(local_to_hw(local),
-					     skb, &control) == 0) {
-			printk(KERN_DEBUG "%s: Configured IBSS beacon "
-			       "template based on scan results\n", dev->name);
-			skb = NULL;
-		}
-
-		rates = 0;
-		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-		for (i = 0; i < bss->supp_rates_len; i++) {
-			int bitrate = (bss->supp_rates[i] & 0x7f) * 5;
-			for (j = 0; j < sband->n_bitrates; j++)
-				if (sband->bitrates[j].bitrate == bitrate)
-					rates |= BIT(j);
-		}
-		ifsta->supp_rates_bits[local->hw.conf.channel->band] = rates;
-	} while (0);
-
-	if (skb) {
-		printk(KERN_DEBUG "%s: Failed to configure IBSS beacon "
-		       "template\n", dev->name);
-		dev_kfree_skb(skb);
-	}
-
-	ifsta->state = IEEE80211_IBSS_JOINED;
-	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
-
-	ieee80211_rx_bss_put(dev, bss);
-
-	return res;
-}
-
 
 static int ieee80211_sta_create_ibss(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta)

