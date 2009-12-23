Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695AbZLWMWn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:22:43 -0500
Message-Id: <20091223121616.325664760@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:15:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH next 08/18] mac80211: refactor association
References: <20091223121529.289129599@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor the code to reserve an skb of the right size
(instead of hoping 200 bytes are enough forever), and
also put HT IE generation into an own function.

Additionally, put the HT IE before the vendor-specific
WMM IE. This still leaves things not quite ordered
correctly, due to user-specified IEs, add a note about
that for now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    7 +
 net/mac80211/work.c |  239 ++++++++++++++++++++++++++++------------------------
 2 files changed, 137 insertions(+), 109 deletions(-)

--- wireless-testing.orig/net/mac80211/work.c	2009-12-23 13:11:22.000000000 +0100
+++ wireless-testing/net/mac80211/work.c	2009-12-23 13:11:22.000000000 +0100
@@ -100,6 +100,102 @@ static int ieee80211_compatible_rates(co
 
 /* frame sending functions */
 
+static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
+				struct ieee80211_supported_band *sband,
+				struct ieee80211_channel *channel,
+				enum ieee80211_smps_mode smps)
+{
+	struct ieee80211_ht_info *ht_info;
+	u8 *pos;
+	u32 flags = channel->flags;
+	u16 cap = sband->ht_cap.cap;
+	__le16 tmp;
+
+	if (!sband->ht_cap.ht_supported)
+		return;
+
+	if (!ht_info_ie)
+		return;
+
+	if (ht_info_ie[1] < sizeof(struct ieee80211_ht_info))
+		return;
+
+	ht_info = (struct ieee80211_ht_info *)(ht_info_ie + 2);
+
+	/* determine capability flags */
+
+	if (ieee80211_disable_40mhz_24ghz &&
+	    sband->band == IEEE80211_BAND_2GHZ) {
+		cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		cap &= ~IEEE80211_HT_CAP_SGI_40;
+	}
+
+	switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+		if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
+			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+		break;
+	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+		if (flags & IEEE80211_CHAN_NO_HT40MINUS) {
+			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+		break;
+	}
+
+	/* set SM PS mode properly */
+	cap &= ~IEEE80211_HT_CAP_SM_PS;
+	switch (smps) {
+	case IEEE80211_SMPS_AUTOMATIC:
+	case IEEE80211_SMPS_NUM_MODES:
+		WARN_ON(1);
+	case IEEE80211_SMPS_OFF:
+		cap |= WLAN_HT_CAP_SM_PS_DISABLED <<
+			IEEE80211_HT_CAP_SM_PS_SHIFT;
+		break;
+	case IEEE80211_SMPS_STATIC:
+		cap |= WLAN_HT_CAP_SM_PS_STATIC <<
+			IEEE80211_HT_CAP_SM_PS_SHIFT;
+		break;
+	case IEEE80211_SMPS_DYNAMIC:
+		cap |= WLAN_HT_CAP_SM_PS_DYNAMIC <<
+			IEEE80211_HT_CAP_SM_PS_SHIFT;
+		break;
+	}
+
+	/* reserve and fill IE */
+
+	pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
+	*pos++ = WLAN_EID_HT_CAPABILITY;
+	*pos++ = sizeof(struct ieee80211_ht_cap);
+	memset(pos, 0, sizeof(struct ieee80211_ht_cap));
+
+	/* capability flags */
+	tmp = cpu_to_le16(cap);
+	memcpy(pos, &tmp, sizeof(u16));
+	pos += sizeof(u16);
+
+	/* AMPDU parameters */
+	*pos++ = sband->ht_cap.ampdu_factor |
+		 (sband->ht_cap.ampdu_density <<
+			IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
+
+	/* MCS set */
+	memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
+	pos += sizeof(sband->ht_cap.mcs);
+
+	/* extended capabilities */
+	pos += sizeof(__le16);
+
+	/* BF capabilities */
+	pos += sizeof(__le32);
+
+	/* antenna selection */
+	pos += sizeof(u8);
+}
+
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 				 struct ieee80211_work *wk)
 {
@@ -107,15 +203,34 @@ static void ieee80211_send_assoc(struct 
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
-	const u8 *ies, *ht_ie;
+	const u8 *ies;
 	int i, len, count, rates_len, supp_rates_len;
 	u16 capab;
 	struct ieee80211_supported_band *sband;
 	u32 rates = 0;
 
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-			    sizeof(*mgmt) + 200 + wk->ie_len +
-			    wk->assoc.ssid_len);
+	sband = local->hw.wiphy->bands[wk->chan->band];
+
+	/*
+	 * Get all rates supported by the device and the AP as
+	 * some APs don't like getting a superset of their rates
+	 * in the association request (e.g. D-Link DAP 1353 in
+	 * b-only mode)...
+	 */
+	rates_len = ieee80211_compatible_rates(wk->assoc.supp_rates,
+					       wk->assoc.supp_rates_len,
+					       sband, &rates);
+
+	skb = alloc_skb(local->hw.extra_tx_headroom +
+			sizeof(*mgmt) + /* bit too much but doesn't matter */
+			2 + wk->assoc.ssid_len + /* SSID */
+			4 + rates_len + /* (extended) rates */
+			4 + /* power capability */
+			2 + 2 * sband->n_channels + /* supported channels */
+			2 + sizeof(struct ieee80211_ht_cap) + /* HT */
+			wk->ie_len + /* extra IEs */
+			9, /* WMM */
+			GFP_KERNEL);
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for assoc "
 		       "frame\n", sdata->name);
@@ -123,8 +238,6 @@ static void ieee80211_send_assoc(struct 
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 
-	sband = local->hw.wiphy->bands[wk->chan->band];
-
 	capab = WLAN_CAPABILITY_ESS;
 
 	if (sband->band == IEEE80211_BAND_2GHZ) {
@@ -137,16 +250,6 @@ static void ieee80211_send_assoc(struct 
 	if (wk->assoc.capability & WLAN_CAPABILITY_PRIVACY)
 		capab |= WLAN_CAPABILITY_PRIVACY;
 
-	/*
-	 * Get all rates supported by the device and the AP as
-	 * some APs don't like getting a superset of their rates
-	 * in the association request (e.g. D-Link DAP 1353 in
-	 * b-only mode)...
-	 */
-	rates_len = ieee80211_compatible_rates(wk->assoc.supp_rates,
-					       wk->assoc.supp_rates_len,
-					       sband, &rates);
-
 	if ((wk->assoc.capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
 	    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
 		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
@@ -220,7 +323,7 @@ static void ieee80211_send_assoc(struct 
 		*pos++ = WLAN_EID_PWR_CAPABILITY;
 		*pos++ = 2;
 		*pos++ = 0; /* min tx power */
-		*pos++ = local->hw.conf.channel->max_power; /* max tx power */
+		*pos++ = wk->chan->max_power; /* max tx power */
 
 		/* 2. supported channels */
 		/* TODO: get this in reg domain format */
@@ -234,11 +337,21 @@ static void ieee80211_send_assoc(struct 
 		}
 	}
 
+	/*
+	 * XXX:	These IEs could contain (vendor-specified)
+	 *	IEs that belong after HT -- the buffer may
+	 *	need to be split up.
+	 */
 	if (wk->ie_len && wk->ie) {
 		pos = skb_put(skb, wk->ie_len);
 		memcpy(pos, wk->ie, wk->ie_len);
 	}
 
+	if (wk->assoc.use_11n && wk->assoc.wmm_used &&
+	    local->hw.queues >= 4)
+		ieee80211_add_ht_ie(skb, wk->assoc.ht_information_ie,
+				    sband, wk->chan, wk->assoc.smps);
+
 	if (wk->assoc.wmm_used && local->hw.queues >= 4) {
 		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
@@ -252,98 +365,6 @@ static void ieee80211_send_assoc(struct 
 		*pos++ = 0;
 	}
 
-	/* wmm support is a must to HT */
-	/*
-	 * IEEE802.11n does not allow TKIP/WEP as pairwise
-	 * ciphers in HT mode. We still associate in non-ht
-	 * mode (11a/b/g) if any one of these ciphers is
-	 * configured as pairwise.
-	 */
-	if (wk->assoc.use_11n && wk->assoc.wmm_used &&
-	    (local->hw.queues >= 4) &&
-	    sband->ht_cap.ht_supported &&
-	    (ht_ie = wk->assoc.ht_information_ie) &&
-	    ht_ie[1] >= sizeof(struct ieee80211_ht_info)) {
-		struct ieee80211_ht_info *ht_info =
-			(struct ieee80211_ht_info *)(ht_ie + 2);
-		u16 cap = sband->ht_cap.cap;
-		__le16 tmp;
-		u32 flags = local->hw.conf.channel->flags;
-
-		/* determine capability flags */
-
-		if (ieee80211_disable_40mhz_24ghz &&
-		    sband->band == IEEE80211_BAND_2GHZ) {
-			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-			cap &= ~IEEE80211_HT_CAP_SGI_40;
-		}
-
-		switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-			if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
-				cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-				cap &= ~IEEE80211_HT_CAP_SGI_40;
-			}
-			break;
-		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-			if (flags & IEEE80211_CHAN_NO_HT40MINUS) {
-				cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-				cap &= ~IEEE80211_HT_CAP_SGI_40;
-			}
-			break;
-		}
-
-		/* set SM PS mode properly */
-		cap &= ~IEEE80211_HT_CAP_SM_PS;
-		switch (wk->assoc.smps) {
-		case IEEE80211_SMPS_AUTOMATIC:
-		case IEEE80211_SMPS_NUM_MODES:
-			WARN_ON(1);
-		case IEEE80211_SMPS_OFF:
-			cap |= WLAN_HT_CAP_SM_PS_DISABLED <<
-				IEEE80211_HT_CAP_SM_PS_SHIFT;
-			break;
-		case IEEE80211_SMPS_STATIC:
-			cap |= WLAN_HT_CAP_SM_PS_STATIC <<
-				IEEE80211_HT_CAP_SM_PS_SHIFT;
-			break;
-		case IEEE80211_SMPS_DYNAMIC:
-			cap |= WLAN_HT_CAP_SM_PS_DYNAMIC <<
-				IEEE80211_HT_CAP_SM_PS_SHIFT;
-			break;
-		}
-
-		/* reserve and fill IE */
-
-		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
-		*pos++ = WLAN_EID_HT_CAPABILITY;
-		*pos++ = sizeof(struct ieee80211_ht_cap);
-		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
-
-		/* capability flags */
-		tmp = cpu_to_le16(cap);
-		memcpy(pos, &tmp, sizeof(u16));
-		pos += sizeof(u16);
-
-		/* AMPDU parameters */
-		*pos++ = sband->ht_cap.ampdu_factor |
-			 (sband->ht_cap.ampdu_density <<
-			 	IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
-
-		/* MCS set */
-		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
-		pos += sizeof(sband->ht_cap.mcs);
-
-		/* extended capabilities */
-		pos += sizeof(__le16);
-
-		/* BF capabilities */
-		pos += sizeof(__le32);
-
-		/* antenna selection */
-		pos += sizeof(u8);
-	}
-
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, skb);
 }
--- wireless-testing.orig/net/mac80211/mlme.c	2009-12-23 13:11:21.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-12-23 13:11:22.000000000 +0100
@@ -1892,6 +1892,13 @@ int ieee80211_mgd_assoc(struct ieee80211
 		ifmgd->ap_smps = ifmgd->req_smps;
 
 	wk->assoc.smps = ifmgd->ap_smps;
+	/*
+	 * IEEE802.11n does not allow TKIP/WEP as pairwise ciphers in HT mode.
+	 * We still associate in non-HT mode (11a/b/g) if any one of these
+	 * ciphers is configured as pairwise.
+	 * We can set this to true for non-11n hardware, that'll be checked
+	 * separately along with the peer capabilities.
+	 */
 	wk->assoc.use_11n = !(ifmgd->flags & IEEE80211_STA_DISABLE_11N);
 	wk->assoc.capability = req->bss->capability;
 	wk->assoc.wmm_used = wk->assoc.bss->wmm_used;


