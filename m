Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbZGATlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:41:18 -0400
Subject: [PATCH 22/20 v4] mac80211: remove dead code, clean up
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090701192641.072258140@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 21:41:17 +0200
Message-Id: <1246477277.8154.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With mac80211 now always controlled by an external SME,
a lot of code is dead -- SSID, BSSID, channel selection
is always done externally, etc. Additionally, rename
IEEE80211_STA_TKIP_WEP_USED to IEEE80211_STA_DISABLE_11N
and clean up the code a bit.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c            |   39 ++-----
 net/mac80211/debugfs_netdev.c |    4 
 net/mac80211/ieee80211_i.h    |   42 +++----
 net/mac80211/iface.c          |    2 
 net/mac80211/mlme.c           |  231 ++++--------------------------------------
 5 files changed, 54 insertions(+), 264 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2009-07-01 20:29:51.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-07-01 20:29:52.000000000 +0200
@@ -1194,18 +1194,14 @@ static int ieee80211_auth(struct wiphy *
 	}
 
 	memcpy(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN);
-	sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
-	sdata->u.mgd.flags |= IEEE80211_STA_BSSID_SET;
 
-	/* TODO: req->chan */
-	sdata->u.mgd.flags |= IEEE80211_STA_AUTO_CHANNEL_SEL;
+	sdata->local->oper_channel = req->chan;
+	ieee80211_hw_config(sdata->local, 0);
 
-	if (req->ssid) {
-		sdata->u.mgd.flags |= IEEE80211_STA_SSID_SET;
-		memcpy(sdata->u.mgd.ssid, req->ssid, req->ssid_len);
-		sdata->u.mgd.ssid_len = req->ssid_len;
-		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
-	}
+	if (!req->ssid)
+		return -EINVAL;
+	memcpy(sdata->u.mgd.ssid, req->ssid, req->ssid_len);
+	sdata->u.mgd.ssid_len = req->ssid_len;
 
 	kfree(sdata->u.mgd.sme_auth_ie);
 	sdata->u.mgd.sme_auth_ie = NULL;
@@ -1218,7 +1214,6 @@ static int ieee80211_auth(struct wiphy *
 		sdata->u.mgd.sme_auth_ie_len = req->ie_len;
 	}
 
-	sdata->u.mgd.flags |= IEEE80211_STA_EXT_SME;
 	sdata->u.mgd.state = IEEE80211_STA_MLME_DIRECT_PROBE;
 	ieee80211_sta_req_auth(sdata);
 	return 0;
@@ -1236,27 +1231,22 @@ static int ieee80211_assoc(struct wiphy 
 	    !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
 		return -ENOLINK; /* not authenticated */
 
-	sdata->u.mgd.flags &= ~IEEE80211_STA_TKIP_WEP_USED;
+	sdata->u.mgd.flags &= ~IEEE80211_STA_DISABLE_11N;
 
 	for (i = 0; i < req->crypto.n_ciphers_pairwise; i++)
 		if (req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP40 ||
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_TKIP ||
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP104)
-			sdata->u.mgd.flags |= IEEE80211_STA_TKIP_WEP_USED;
+			sdata->u.mgd.flags |= IEEE80211_STA_DISABLE_11N;
 
-	sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
-	sdata->u.mgd.flags |= IEEE80211_STA_BSSID_SET;
+	sdata->local->oper_channel = req->chan;
+	ieee80211_hw_config(sdata->local, 0);
 
-	/* TODO: req->chan */
-	sdata->u.mgd.flags |= IEEE80211_STA_AUTO_CHANNEL_SEL;
+	if (!req->ssid)
+		return -EINVAL;
 
-	if (req->ssid) {
-		sdata->u.mgd.flags |= IEEE80211_STA_SSID_SET;
-		memcpy(sdata->u.mgd.ssid, req->ssid, req->ssid_len);
-		sdata->u.mgd.ssid_len = req->ssid_len;
-		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
-	} else
-		sdata->u.mgd.flags |= IEEE80211_STA_AUTO_SSID_SEL;
+	memcpy(sdata->u.mgd.ssid, req->ssid, req->ssid_len);
+	sdata->u.mgd.ssid_len = req->ssid_len;
 
 	ret = ieee80211_sta_set_extra_ie(sdata, req->ie, req->ie_len);
 	if (ret && ret != -EALREADY)
@@ -1275,7 +1265,6 @@ static int ieee80211_assoc(struct wiphy 
 	else
 		sdata->u.mgd.flags &= ~IEEE80211_STA_CONTROL_PORT;
 
-	sdata->u.mgd.flags |= IEEE80211_STA_EXT_SME;
 	sdata->u.mgd.state = IEEE80211_STA_MLME_ASSOCIATE;
 	ieee80211_sta_req_auth(sdata);
 	return 0;
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-07-01 20:29:51.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-07-01 20:29:52.000000000 +0200
@@ -228,28 +228,24 @@ struct mesh_preq_queue {
 };
 
 /* flags used in struct ieee80211_if_managed.flags */
-#define IEEE80211_STA_SSID_SET		BIT(0)
-#define IEEE80211_STA_BSSID_SET		BIT(1)
-#define IEEE80211_STA_PREV_BSSID_SET	BIT(2)
-#define IEEE80211_STA_AUTHENTICATED	BIT(3)
-#define IEEE80211_STA_ASSOCIATED	BIT(4)
-#define IEEE80211_STA_PROBEREQ_POLL	BIT(5)
-#define IEEE80211_STA_CREATE_IBSS	BIT(6)
-#define IEEE80211_STA_CONTROL_PORT	BIT(7)
-#define IEEE80211_STA_WMM_ENABLED	BIT(8)
-/* hole at 9, please re-use */
-#define IEEE80211_STA_AUTO_SSID_SEL	BIT(10)
-#define IEEE80211_STA_AUTO_BSSID_SEL	BIT(11)
-#define IEEE80211_STA_AUTO_CHANNEL_SEL	BIT(12)
-#define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
-#define IEEE80211_STA_TKIP_WEP_USED	BIT(14)
-#define IEEE80211_STA_CSA_RECEIVED	BIT(15)
-#define IEEE80211_STA_MFP_ENABLED	BIT(16)
-#define IEEE80211_STA_EXT_SME		BIT(17)
+enum ieee80211_sta_flags {
+	IEEE80211_STA_PREV_BSSID_SET	= BIT(0),
+	IEEE80211_STA_AUTHENTICATED	= BIT(1),
+	IEEE80211_STA_ASSOCIATED	= BIT(2),
+	IEEE80211_STA_PROBEREQ_POLL	= BIT(3),
+	IEEE80211_STA_CONTROL_PORT	= BIT(4),
+	IEEE80211_STA_WMM_ENABLED	= BIT(5),
+	IEEE80211_STA_DISABLE_11N	= BIT(6),
+	IEEE80211_STA_CSA_RECEIVED	= BIT(7),
+	IEEE80211_STA_MFP_ENABLED	= BIT(8),
+};
+
 /* flags for MLME request */
-#define IEEE80211_STA_REQ_SCAN 0
-#define IEEE80211_STA_REQ_AUTH 1
-#define IEEE80211_STA_REQ_RUN  2
+enum ieee80211_sta_request {
+	IEEE80211_STA_REQ_SCAN,
+	IEEE80211_STA_REQ_AUTH,
+	IEEE80211_STA_REQ_RUN,
+};
 
 struct ieee80211_if_managed {
 	struct timer_list timer;
@@ -934,10 +930,6 @@ extern const struct iw_handler_def ieee8
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
 ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 					  struct sk_buff *skb);
-int ieee80211_sta_commit(struct ieee80211_sub_if_data *sdata);
-int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len);
-int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t *len);
-int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid);
 void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata);
 int ieee80211_sta_deauthenticate(struct ieee80211_sub_if_data *sdata, u16 reason);
 int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata, u16 reason);
--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-01 20:29:51.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-01 20:29:52.000000000 +0200
@@ -347,7 +347,7 @@ static void ieee80211_send_assoc(struct 
 	    sband->ht_cap.ht_supported &&
 	    (ht_ie = ieee80211_bss_get_ie(bss, WLAN_EID_HT_INFORMATION)) &&
 	    ht_ie[1] >= sizeof(struct ieee80211_ht_info) &&
-	    (!(ifmgd->flags & IEEE80211_STA_TKIP_WEP_USED))) {
+	    (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N))) {
 		struct ieee80211_ht_info *ht_info =
 			(struct ieee80211_ht_info *)(ht_ie + 2);
 		u16 cap = sband->ht_cap.cap;
@@ -981,8 +981,6 @@ static void ieee80211_authenticate(struc
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
-	u8 *ies;
-	size_t ies_len;
 
 	ifmgd->auth_tries++;
 	if (ifmgd->auth_tries > IEEE80211_AUTH_MAX_TRIES) {
@@ -1010,15 +1008,8 @@ static void ieee80211_authenticate(struc
 	printk(KERN_DEBUG "%s: authenticate with AP %pM\n",
 	       sdata->dev->name, ifmgd->bssid);
 
-	if (ifmgd->flags & IEEE80211_STA_EXT_SME) {
-		ies = ifmgd->sme_auth_ie;
-		ies_len = ifmgd->sme_auth_ie_len;
-	} else {
-		ies = NULL;
-		ies_len = 0;
-	}
-	ieee80211_send_auth(sdata, 1, ifmgd->auth_alg, ies, ies_len,
-			    ifmgd->bssid, 0);
+	ieee80211_send_auth(sdata, 1, ifmgd->auth_alg, ifmgd->sme_auth_ie,
+			    ifmgd->sme_auth_ie_len, ifmgd->bssid, 0);
 	ifmgd->auth_transaction = 2;
 
 	mod_timer(&ifmgd->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
@@ -1128,44 +1119,6 @@ static void ieee80211_set_disassoc(struc
 	sta_info_destroy(sta);
 }
 
-static int ieee80211_sta_wep_configured(struct ieee80211_sub_if_data *sdata)
-{
-	if (!sdata || !sdata->default_key ||
-	    sdata->default_key->conf.alg != ALG_WEP)
-		return 0;
-	return 1;
-}
-
-static int ieee80211_privacy_mismatch(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_bss *bss;
-	int bss_privacy;
-	int wep_privacy;
-	int privacy_invoked;
-
-	if (!ifmgd || (ifmgd->flags & IEEE80211_STA_EXT_SME))
-		return 0;
-
-	bss = ieee80211_rx_bss_get(local, ifmgd->bssid,
-				   local->hw.conf.channel->center_freq,
-				   ifmgd->ssid, ifmgd->ssid_len);
-	if (!bss)
-		return 0;
-
-	bss_privacy = !!(bss->cbss.capability & WLAN_CAPABILITY_PRIVACY);
-	wep_privacy = !!ieee80211_sta_wep_configured(sdata);
-	privacy_invoked = !!(ifmgd->flags & IEEE80211_STA_PRIVACY_INVOKED);
-
-	ieee80211_rx_bss_put(local, bss);
-
-	if ((bss_privacy == wep_privacy) || (bss_privacy == privacy_invoked))
-		return 0;
-
-	return 1;
-}
-
 static void ieee80211_associate(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -1195,14 +1148,6 @@ static void ieee80211_associate(struct i
 	ifmgd->state = IEEE80211_STA_MLME_ASSOCIATE;
 	printk(KERN_DEBUG "%s: associate with AP %pM\n",
 	       sdata->dev->name, ifmgd->bssid);
-	if (ieee80211_privacy_mismatch(sdata)) {
-		printk(KERN_DEBUG "%s: mismatch in privacy configuration and "
-		       "mixed-cell disabled - abort association\n", sdata->dev->name);
-		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
-		ieee80211_recalc_idle(local);
-		return;
-	}
-
 	ieee80211_send_assoc(sdata);
 
 	mod_timer(&ifmgd->timer, jiffies + IEEE80211_ASSOC_TIMEOUT);
@@ -1360,12 +1305,9 @@ static void ieee80211_auth_completed(str
 
 	printk(KERN_DEBUG "%s: authenticated\n", sdata->dev->name);
 	ifmgd->flags |= IEEE80211_STA_AUTHENTICATED;
-	if (ifmgd->flags & IEEE80211_STA_EXT_SME) {
-		/* Wait for SME to request association */
-		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
-		ieee80211_recalc_idle(sdata->local);
-	} else
-		ieee80211_associate(sdata);
+	/* Wait for SME to request association */
+	ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+	ieee80211_recalc_idle(sdata->local);
 }
 
 
@@ -1460,15 +1402,6 @@ static void ieee80211_rx_mgmt_deauth(str
 		printk(KERN_DEBUG "%s: deauthenticated (Reason: %u)\n",
 				sdata->dev->name, reason_code);
 
-	if (!(ifmgd->flags & IEEE80211_STA_EXT_SME) &&
-	    (ifmgd->state == IEEE80211_STA_MLME_AUTHENTICATE ||
-	     ifmgd->state == IEEE80211_STA_MLME_ASSOCIATE ||
-	     ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED)) {
-		ifmgd->state = IEEE80211_STA_MLME_DIRECT_PROBE;
-		mod_timer(&ifmgd->timer, jiffies +
-				      IEEE80211_RETRY_AUTH_INTERVAL);
-	}
-
 	ieee80211_set_disassoc(sdata, true, false, 0);
 	ifmgd->flags &= ~IEEE80211_STA_AUTHENTICATED;
 	cfg80211_send_deauth(sdata->dev, (u8 *) mgmt, len, GFP_KERNEL);
@@ -1494,13 +1427,6 @@ static void ieee80211_rx_mgmt_disassoc(s
 		printk(KERN_DEBUG "%s: disassociated (Reason: %u)\n",
 				sdata->dev->name, reason_code);
 
-	if (!(ifmgd->flags & IEEE80211_STA_EXT_SME) &&
-	    ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED) {
-		ifmgd->state = IEEE80211_STA_MLME_ASSOCIATE;
-		mod_timer(&ifmgd->timer, jiffies +
-				      IEEE80211_RETRY_AUTH_INTERVAL);
-	}
-
 	ieee80211_set_disassoc(sdata, false, false, reason_code);
 	cfg80211_send_disassoc(sdata->dev, (u8 *) mgmt, len, GFP_KERNEL);
 }
@@ -1573,11 +1499,9 @@ static void ieee80211_rx_mgmt_assoc_resp
 		ifmgd->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
 		cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, len,
 				       GFP_KERNEL);
-		if (ifmgd->flags & IEEE80211_STA_EXT_SME) {
-			/* Wait for SME to decide what to do next */
-			ifmgd->state = IEEE80211_STA_MLME_DISABLED;
-			ieee80211_recalc_idle(local);
-		}
+		/* Wait for SME to decide what to do next */
+		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_idle(local);
 		return;
 	}
 
@@ -1683,8 +1607,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
-	/* If TKIP/WEP is used, no need to parse AP's HT capabilities */
-	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_TKIP_WEP_USED))
+	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
@@ -1718,7 +1641,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 	if (elems.ht_info_elem && elems.wmm_param &&
 	    (ifmgd->flags & IEEE80211_STA_WMM_ENABLED) &&
-	    !(ifmgd->flags & IEEE80211_STA_TKIP_WEP_USED))
+	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
 					       ap_ht_cap_flags);
 
@@ -1931,7 +1854,7 @@ static void ieee80211_rx_mgmt_beacon(str
 
 
 	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
-	    !(ifmgd->flags & IEEE80211_STA_TKIP_WEP_USED)) {
+	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N)) {
 		struct sta_info *sta;
 		struct ieee80211_supported_band *sband;
 		u16 ap_ht_cap_flags;
@@ -2090,26 +2013,6 @@ static int ieee80211_sta_config_auth(str
 	u16 capa_val = WLAN_CAPABILITY_ESS;
 	struct ieee80211_channel *chan = local->oper_channel;
 
-	if (!(ifmgd->flags & IEEE80211_STA_EXT_SME) &&
-	    ifmgd->flags & (IEEE80211_STA_AUTO_SSID_SEL |
-			    IEEE80211_STA_AUTO_BSSID_SEL |
-			    IEEE80211_STA_AUTO_CHANNEL_SEL)) {
-		capa_mask |= WLAN_CAPABILITY_PRIVACY;
-		if (sdata->default_key)
-			capa_val |= WLAN_CAPABILITY_PRIVACY;
-	}
-
-	if (ifmgd->flags & IEEE80211_STA_AUTO_CHANNEL_SEL)
-		chan = NULL;
-
-	if (ifmgd->flags & IEEE80211_STA_AUTO_BSSID_SEL)
-		bssid = NULL;
-
-	if (ifmgd->flags & IEEE80211_STA_AUTO_SSID_SEL) {
-		ssid = NULL;
-		ssid_len = 0;
-	}
-
 	bss = (void *)cfg80211_get_bss(local->hw.wiphy, chan,
 				       bssid, ssid, ssid_len,
 				       capa_mask, capa_val);
@@ -2119,10 +2022,6 @@ static int ieee80211_sta_config_auth(str
 		local->oper_channel_type = NL80211_CHAN_NO_HT;
 		ieee80211_hw_config(local, 0);
 
-		if (!(ifmgd->flags & IEEE80211_STA_SSID_SET))
-			ieee80211_sta_set_ssid(sdata, bss->ssid,
-					       bss->ssid_len);
-		ieee80211_sta_set_bssid(sdata, bss->cbss.bssid);
 		ieee80211_sta_def_wmm_params(sdata, bss->supp_rates_len,
 						    bss->supp_rates);
 		if (sdata->u.mgd.mfp == IEEE80211_MFP_REQUIRED)
@@ -2232,14 +2131,6 @@ static void ieee80211_sta_work(struct wo
 		WARN_ON(1);
 		break;
 	}
-
-	if (ieee80211_privacy_mismatch(sdata)) {
-		printk(KERN_DEBUG "%s: privacy configuration mismatch and "
-		       "mixed-cell disabled - disassociate\n", sdata->dev->name);
-
-		ieee80211_set_disassoc(sdata, false, true,
-					WLAN_REASON_UNSPECIFIED);
-	}
 }
 
 static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
@@ -2306,9 +2197,7 @@ void ieee80211_sta_setup_sdata(struct ie
 	skb_queue_head_init(&ifmgd->skb_queue);
 
 	ifmgd->capab = WLAN_CAPABILITY_ESS;
-	ifmgd->flags |= IEEE80211_STA_CREATE_IBSS |
-		IEEE80211_STA_AUTO_BSSID_SEL |
-		IEEE80211_STA_AUTO_CHANNEL_SEL;
+	ifmgd->flags = 0;
 	if (sdata->local->hw.queues >= 4)
 		ifmgd->flags |= IEEE80211_STA_WMM_ENABLED;
 
@@ -2324,96 +2213,20 @@ void ieee80211_sta_req_auth(struct ieee8
 	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
 		return;
 
-	if ((ifmgd->flags & (IEEE80211_STA_BSSID_SET |
-			     IEEE80211_STA_AUTO_BSSID_SEL)) &&
-	    (ifmgd->flags & (IEEE80211_STA_SSID_SET |
-			     IEEE80211_STA_AUTO_SSID_SEL))) {
-
-		if (ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED)
-			ieee80211_set_disassoc(sdata, true, true,
-					       WLAN_REASON_DEAUTH_LEAVING);
-
-		if (ifmgd->ssid_len == 0) {
-			/*
-			 * Only allow association to be started if a valid SSID
-			 * is configured.
-			 */
-			return;
-		}
-
-		if (!(ifmgd->flags & IEEE80211_STA_EXT_SME) ||
-		    ifmgd->state != IEEE80211_STA_MLME_ASSOCIATE)
-			set_bit(IEEE80211_STA_REQ_AUTH, &ifmgd->request);
-		else if (ifmgd->flags & IEEE80211_STA_EXT_SME)
-			set_bit(IEEE80211_STA_REQ_RUN, &ifmgd->request);
-		queue_work(local->hw.workqueue, &ifmgd->work);
-	}
-}
-
-int ieee80211_sta_commit(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-
-	if (ifmgd->ssid_len)
-		ifmgd->flags |= IEEE80211_STA_SSID_SET;
-	else
-		ifmgd->flags &= ~IEEE80211_STA_SSID_SET;
-
-	return 0;
-}
-
-int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len)
-{
-	struct ieee80211_if_managed *ifmgd;
-
-	if (len > IEEE80211_MAX_SSID_LEN)
-		return -EINVAL;
-
-	ifmgd = &sdata->u.mgd;
-
-	if (ifmgd->ssid_len != len || memcmp(ifmgd->ssid, ssid, len) != 0) {
-		if (ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED)
-			ieee80211_set_disassoc(sdata, true, true,
-					       WLAN_REASON_DEAUTH_LEAVING);
-
-		/*
-		 * Do not use reassociation if SSID is changed (different ESS).
-		 */
-		ifmgd->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
-		memset(ifmgd->ssid, 0, sizeof(ifmgd->ssid));
-		memcpy(ifmgd->ssid, ssid, len);
-		ifmgd->ssid_len = len;
-	}
-
-	return ieee80211_sta_commit(sdata);
-}
-
-int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t *len)
-{
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	memcpy(ssid, ifmgd->ssid, ifmgd->ssid_len);
-	*len = ifmgd->ssid_len;
-	return 0;
-}
-
-int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid)
-{
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-
-	if (compare_ether_addr(bssid, ifmgd->bssid) != 0 &&
-	    ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED)
+	if (WARN_ON(ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED))
 		ieee80211_set_disassoc(sdata, true, true,
 				       WLAN_REASON_DEAUTH_LEAVING);
 
-	if (is_valid_ether_addr(bssid)) {
-		memcpy(ifmgd->bssid, bssid, ETH_ALEN);
-		ifmgd->flags |= IEEE80211_STA_BSSID_SET;
-	} else {
-		memset(ifmgd->bssid, 0, ETH_ALEN);
-		ifmgd->flags &= ~IEEE80211_STA_BSSID_SET;
+	if (WARN_ON(ifmgd->ssid_len == 0)) {
+		/*
+		 * Only allow association to be started if a valid SSID
+		 * is configured.
+		 */
+		return;
 	}
 
-	return ieee80211_sta_commit(sdata);
+	set_bit(IEEE80211_STA_REQ_RUN, &ifmgd->request);
+	queue_work(local->hw.workqueue, &ifmgd->work);
 }
 
 int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/debugfs_netdev.c	2009-07-01 20:29:52.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_netdev.c	2009-07-01 20:29:52.000000000 +0200
@@ -111,9 +111,7 @@ IEEE80211_IF_FILE(auth_transaction, u.mg
 static ssize_t ieee80211_if_fmt_flags(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
 {
-	return scnprintf(buf, buflen, "%s%s%s%s%s%s%s\n",
-		 sdata->u.mgd.flags & IEEE80211_STA_SSID_SET ? "SSID\n" : "",
-		 sdata->u.mgd.flags & IEEE80211_STA_BSSID_SET ? "BSSID\n" : "",
+	return scnprintf(buf, buflen, "%s%s%s%s%s\n",
 		 sdata->u.mgd.flags & IEEE80211_STA_PREV_BSSID_SET ? "prev BSSID\n" : "",
 		 sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED ? "AUTH\n" : "",
 		 sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED ? "ASSOC\n" : "",
--- wireless-testing.orig/net/mac80211/iface.c	2009-07-01 13:27:46.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-07-01 20:29:52.000000000 +0200
@@ -485,8 +485,6 @@ static int ieee80211_stop(struct net_dev
 		synchronize_rcu();
 		skb_queue_purge(&sdata->u.mgd.skb_queue);
 
-		sdata->u.mgd.flags &= ~(IEEE80211_STA_PRIVACY_INVOKED |
-					IEEE80211_STA_TKIP_WEP_USED);
 		kfree(sdata->u.mgd.extra_ie);
 		sdata->u.mgd.extra_ie = NULL;
 		sdata->u.mgd.extra_ie_len = 0;


