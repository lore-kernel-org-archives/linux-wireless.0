Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40611 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab1ATJVz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 04:21:55 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PfqiI-0001DF-Gq
	for linux-wireless@vger.kernel.org; Thu, 20 Jan 2011 10:21:54 +0100
Received: from dslb-084-059-120-020.pools.arcor-ip.net ([84.59.120.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 10:21:54 +0100
Received: from alexander.simon by dslb-084-059-120-020.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 10:21:54 +0100
To: linux-wireless@vger.kernel.org
From: Alexander Simon <alexander.simon@saxnet.de>
Subject: [RFC 2/4] mac80211: support for IEEE80211N in IBSS
Date: Thu, 20 Jan 2011 09:21:41 +0000 (UTC)
Message-ID: <loom.20110120T101334-923@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de> <1295447708.4685.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Building the HT IE when we join an IBSS.
I think this patch is rather simple to understand. It takes the configured
channel_type and all other else from the interface capabilities (like AMPDU,
SGIs). Beamforming is disabled.
This was adopted from ieee80211_build_preq_ies in util.c.
Yeah and you could ease the last changeset.

diff -Nrup compat-wireless-2011-01-17.1//net/mac80211/ibss.c
compat-wireless-2011-01-17.2//net/mac80211/ibss.c
--- compat-wireless-2011-01-17.1//net/mac80211/ibss.c	2011-01-20
10:01:56.000000000 +0100
+++ compat-wireless-2011-01-17.2//net/mac80211/ibss.c	2011-01-20
10:02:16.000000000 +0100
@@ -174,6 +174,64 @@ static void __ieee80211_sta_join_ibss(st
 		memcpy(skb_put(skb, ifibss->ie_len),
 		       ifibss->ie, ifibss->ie_len);
 
+	if (channel_type != NL80211_CHAN_NO_HT && sband->ht_cap.ht_supported) {
+		u16 cap = sband->ht_cap.cap;
+		struct ieee80211_ht_cap *ht_cap;
+		struct ieee80211_ht_info *ht_info;
+
+		/* Build HT Capabilities */
+		if (ieee80211_disable_40mhz_24ghz &&
+		    sband->band == IEEE80211_BAND_2GHZ) {
+			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+
+		pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_cap));
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		ht_cap = (struct ieee80211_ht_cap *)pos;
+
+		ht_cap->cap_info = cpu_to_le16(cap);
+		ht_cap->ampdu_params_info = sband->ht_cap.ampdu_factor |
+			(sband->ht_cap.ampdu_density <<
+			IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
+		memcpy(&ht_cap->mcs, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
+		ht_cap->extended_ht_cap_info = 0x0000;
+		ht_cap->tx_BF_cap_info = 0x00000000;
+		ht_cap->antenna_selection_info = 0x00;
+
+		/* Build HT Information */
+		pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_info));
+		*pos++ = WLAN_EID_HT_INFORMATION;
+		*pos++ = sizeof(struct ieee80211_ht_info);
+		ht_info = (struct ieee80211_ht_info *)pos;
+
+		ht_info->control_chan = 
+			ieee80211_frequency_to_channel(chan->center_freq);
+		ht_info->ht_param = 0x00;
+		switch (local->_oper_channel_type) {
+			case NL80211_CHAN_HT40MINUS:
+				ht_info->ht_param |= IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+				break;
+			case NL80211_CHAN_HT40PLUS:
+				ht_info->ht_param |= IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+				break;
+			case NL80211_CHAN_HT20:
+			default:
+				ht_info->ht_param |= IEEE80211_HT_PARAM_CHA_SEC_NONE;
+				break;
+		}
+		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+			ht_info->ht_param |= IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
+		ht_info->operation_mode = 0x0000;
+		ht_info->stbc_param = 0x0000;
+
+		/* It seems that Basic MCS set and Supported MCS set
+		   are identical for the first 10 bytes */
+		memset(&ht_info->basic_set, 0, 16);
+		memcpy(&ht_info->basic_set, &sband->ht_cap.mcs, 10);
+	}
+
 	if (local->hw.queues >= 4) {
 		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
@@ -223,6 +281,7 @@ static void ieee80211_sta_join_ibss(stru
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+	const u8 *ht_info_ie;
 
 	lockdep_assert_held(&sdata->u.ibss.mtx);
 
@@ -923,11 +982,16 @@ int ieee80211_ibss_join(struct ieee80211
 	struct sk_buff *skb;
 
 	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
-			    36 /* bitrates */ +
-			    34 /* SSID */ +
-			    3  /* DS params */ +
-			    4  /* IBSS params */ +
-			    params->ie_len);
+				sizeof(struct ieee80211_hdr_3addr) + 
+				12 /* struct ieee80211_mgmt.u.beacon */ +
+				2 + IEEE80211_MAX_SSID_LEN /* max SSID */ +
+				2 + 8 /* max Supported Rates */ +
+				3 /* max DS params */ +
+				4 /* IBSS params */ +
+				2 + (IEEE80211_MAX_SUPP_RATES - 8) /* max Ext Rates */ +
+				2 + sizeof(struct ieee80211_ht_cap) +
+				2 + sizeof(struct ieee80211_ht_info) +
+				params->ie_len);
 	if (!skb)
 		return -ENOMEM;
 


