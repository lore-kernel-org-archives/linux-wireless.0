Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:35086 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3H1Lln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 07:41:43 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 5/6] mac80211: send a CSA action frame when changing channel
Date: Wed, 28 Aug 2013 13:41:32 +0200
Message-Id: <1377690093-27024-6-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130828_134155_895523_E0C97E8E)
In-Reply-To: <1377690093-27024-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1377690093-27024-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IBSS members may not immediately be able to send out their beacon when
performing CSA, therefore also send a CSA action frame.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/ibss.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index c004213..5ea9b3a 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -428,6 +428,60 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				  tsf, false);
 }
 
+static int ieee80211_send_action_csa(struct ieee80211_sub_if_data *sdata,
+				     struct cfg80211_csa_settings *csa_settings)
+{
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+	int freq;
+	int hdr_len = offsetof(struct ieee80211_mgmt, u.action.u.chan_switch) +
+		      sizeof(mgmt->u.action.u.chan_switch);
+	u8 *pos;
+
+	skb = dev_alloc_skb(local->tx_headroom + hdr_len +
+			    5 +	/* channel switch announcement element */
+			    3);	/* secondary channel offset element */
+	if (!skb)
+		return -1;
+
+	skb_reserve(skb, local->tx_headroom);
+	mgmt = (struct ieee80211_mgmt *)skb_put(skb, hdr_len);
+	memset(mgmt, 0, hdr_len);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
+
+	eth_broadcast_addr(mgmt->da);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
+	memcpy(mgmt->bssid, ifibss->bssid, ETH_ALEN);
+	mgmt->u.action.category = WLAN_CATEGORY_SPECTRUM_MGMT;
+	mgmt->u.action.u.chan_switch.action_code = WLAN_ACTION_SPCT_CHL_SWITCH;
+	pos = skb_put(skb, 5);
+	*pos++ = WLAN_EID_CHANNEL_SWITCH;			/* EID */
+	*pos++ = 3;						/* IE length */
+	*pos++ = csa_settings->block_tx ? 1 : 0;		/* CSA mode */
+	freq = csa_settings->chandef.chan->center_freq;
+	*pos++ = ieee80211_frequency_to_channel(freq);		/* channel */
+	*pos++ = csa_settings->count;				/* count */
+
+	if (csa_settings->chandef.width == NL80211_CHAN_WIDTH_40) {
+		enum nl80211_channel_type ch_type;
+
+		skb_put(skb, 3);
+		*pos++ = WLAN_EID_SECONDARY_CHANNEL_OFFSET;	/* EID */
+		*pos++ = 1;					/* IE length */
+		ch_type = cfg80211_get_chandef_type(&csa_settings->chandef);
+		if (ch_type == NL80211_CHAN_HT40PLUS)
+			*pos++ = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+		else
+			*pos++ = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+	}
+
+	ieee80211_tx_skb(sdata, skb);
+	return 0;
+}
+
 int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 			      struct cfg80211_csa_settings *csa_settings)
 {
@@ -480,6 +534,12 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	if (old_presp)
 		kfree_rcu(old_presp, rcu_head);
 
+	/* it might not send the beacon for a while. send an action frame
+	 * immediately to announce the channel switch.
+	 */
+	if (csa_settings)
+		ieee80211_send_action_csa(sdata, csa_settings);
+
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
  out:
 	return ret;
-- 
1.7.10.4

