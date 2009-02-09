Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZBIWFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 17:05:10 -0500
Subject: [PATCH] mac80211: split managed/ibss code a little more
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Feb 2009 23:04:37 +0100
Message-Id: <1234217077.4175.257.camel@johannes.local> (sfid-20090209_230517_407914_E048211C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It appears that you can completely mess up mac80211 in IBSS
mode by sending it a disassoc or deauth: it'll stop queues
and do a lot more but not ever do anything again. Fix this
by not handling all those frames in IBSS mode,=20

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |  250 +++++++++++++++++++++++++++++--------------=
---------
 1 file changed, 142 insertions(+), 108 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-02-09 21:49:46.00000=
0000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-02-09 22:42:05.000000000 =
+0100
@@ -778,9 +778,6 @@ static void ieee80211_set_associated(str
 	bss_info_changed |=3D BSS_CHANGED_ASSOC;
 	ifsta->flags |=3D IEEE80211_STA_ASSOCIATED;
=20
-	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
-		return;
-
 	bss =3D ieee80211_rx_bss_get(local, ifsta->bssid,
 				   conf->channel->center_freq,
 				   ifsta->ssid, ifsta->ssid_len);
@@ -1139,6 +1136,30 @@ static void ieee80211_auth_challenge(str
 			    elems.challenge_len + 2, 1);
 }
=20
+static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *=
sdata,
+					struct ieee80211_if_sta *ifsta,
+					struct ieee80211_mgmt *mgmt,
+					size_t len)
+{
+	u16 auth_alg, auth_transaction, status_code;
+
+	if (len < 24 + 6)
+		return;
+
+	auth_alg =3D le16_to_cpu(mgmt->u.auth.auth_alg);
+	auth_transaction =3D le16_to_cpu(mgmt->u.auth.auth_transaction);
+	status_code =3D le16_to_cpu(mgmt->u.auth.status_code);
+
+	/*
+	 * IEEE 802.11 standard does not require authentication in IBSS
+	 * networks and most implementations do not seem to use it.
+	 * However, try to reply to authentication attempts if someone
+	 * has actually implemented this.
+	 */
+	if (auth_alg =3D=3D WLAN_AUTH_OPEN && auth_transaction =3D=3D 1)
+		ieee80211_send_auth(sdata, ifsta, 2, NULL, 0, 0);
+}
+
 static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata=
,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_mgmt *mgmt,
@@ -1146,38 +1167,22 @@ static void ieee80211_rx_mgmt_auth(struc
 {
 	u16 auth_alg, auth_transaction, status_code;
=20
-	if (ifsta->state !=3D IEEE80211_STA_MLME_AUTHENTICATE &&
-	    sdata->vif.type !=3D NL80211_IFTYPE_ADHOC)
+	if (ifsta->state !=3D IEEE80211_STA_MLME_AUTHENTICATE)
 		return;
=20
 	if (len < 24 + 6)
 		return;
=20
-	if (sdata->vif.type !=3D NL80211_IFTYPE_ADHOC &&
-	    memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN) !=3D 0)
+	if (memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN) !=3D 0)
 		return;
=20
-	if (sdata->vif.type !=3D NL80211_IFTYPE_ADHOC &&
-	    memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) !=3D 0)
+	if (memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) !=3D 0)
 		return;
=20
 	auth_alg =3D le16_to_cpu(mgmt->u.auth.auth_alg);
 	auth_transaction =3D le16_to_cpu(mgmt->u.auth.auth_transaction);
 	status_code =3D le16_to_cpu(mgmt->u.auth.status_code);
=20
-	if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC) {
-		/*
-		 * IEEE 802.11 standard does not require authentication in IBSS
-		 * networks and most implementations do not seem to use it.
-		 * However, try to reply to authentication attempts if someone
-		 * has actually implemented this.
-		 */
-		if (auth_alg !=3D WLAN_AUTH_OPEN || auth_transaction !=3D 1)
-			return;
-		ieee80211_send_auth(sdata, ifsta, 2, NULL, 0, 0);
-		return;
-	}
-
 	if (auth_alg !=3D ifsta->auth_alg ||
 	    auth_transaction !=3D ifsta->auth_transaction)
 		return;
@@ -1732,74 +1737,81 @@ static void ieee80211_rx_bss_info(struct
 	/* was just updated in ieee80211_bss_info_update */
 	beacon_timestamp =3D bss->cbss.tsf;
=20
-	/*
-	 * In STA mode, the remaining parameters should not be overridden
-	 * by beacons because they're not necessarily accurate there.
-	 */
-	if (sdata->vif.type !=3D NL80211_IFTYPE_ADHOC &&
-	    bss->last_probe_resp && beacon) {
-		ieee80211_rx_bss_put(local, bss);
-		return;
-	}
+	if (sdata->vif.type !=3D NL80211_IFTYPE_ADHOC)
+		goto put_bss;
=20
 	/* check if we need to merge IBSS */
-	if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC && beacon &&
-	    (!(sdata->u.sta.flags & IEEE80211_STA_BSSID_SET)) &&
-	    bss->cbss.capability & WLAN_CAPABILITY_IBSS &&
-	    bss->cbss.channel =3D=3D local->oper_channel &&
-	    elems->ssid_len =3D=3D sdata->u.sta.ssid_len &&
+
+	/* merge only on beacons (???) */
+	if (!beacon)
+		goto put_bss;
+
+	/* we use a fixed BSSID */
+	if (sdata->u.sta.flags & IEEE80211_STA_BSSID_SET)
+		goto put_bss;
+
+	/* not an IBSS */
+	if (!(bss->cbss.capability & WLAN_CAPABILITY_IBSS))
+		goto put_bss;
+
+	/* different SSID */
+	if (elems->ssid_len !=3D sdata->u.sta.ssid_len ||
 	    memcmp(elems->ssid, sdata->u.sta.ssid,
-				sdata->u.sta.ssid_len) =3D=3D 0) {
-		if (rx_status->flag & RX_FLAG_TSFT) {
-			/* in order for correct IBSS merging we need mactime
-			 *
-			 * since mactime is defined as the time the first data
-			 * symbol of the frame hits the PHY, and the timestamp
-			 * of the beacon is defined as "the time that the data
-			 * symbol containing the first bit of the timestamp is
-			 * transmitted to the PHY plus the transmitting STA=C3=A2=C2=80=C2=99=
s
-			 * delays through its local PHY from the MAC-PHY
-			 * interface to its interface with the WM"
-			 * (802.11 11.1.2) - equals the time this bit arrives at
-			 * the receiver - we have to take into account the
-			 * offset between the two.
-			 * e.g: at 1 MBit that means mactime is 192 usec earlier
-			 * (=3D24 bytes * 8 usecs/byte) than the beacon timestamp.
-			 */
-			int rate;
-			if (rx_status->flag & RX_FLAG_HT) {
-				rate =3D 65; /* TODO: HT rates */
-			} else {
-				rate =3D local->hw.wiphy->bands[band]->
-					bitrates[rx_status->rate_idx].bitrate;
-			}
-			rx_timestamp =3D rx_status->mactime + (24 * 8 * 10 / rate);
-		} else if (local && local->ops && local->ops->get_tsf)
-			/* second best option: get current TSF */
-			rx_timestamp =3D local->ops->get_tsf(local_to_hw(local));
+				sdata->u.sta.ssid_len))
+		goto put_bss;
+
+	if (rx_status->flag & RX_FLAG_TSFT) {
+		/*
+		 * For correct IBSS merging we need mactime; since mactime is
+		 * defined as the time the first data symbol of the frame hits
+		 * the PHY, and the timestamp of the beacon is defined as "the
+		 * time that the data symbol containing the first bit of the
+		 * timestamp is transmitted to the PHY plus the transmitting
+		 * STA's delays through its local PHY from the MAC-PHY
+		 * interface to its interface with the WM" (802.11 11.1.2)
+		 * - equals the time this bit arrives at the receiver - we have
+		 * to take into account the offset between the two.
+		 *
+		 * E.g. at 1 MBit that means mactime is 192 usec earlier
+		 * (=3D24 bytes * 8 usecs/byte) than the beacon timestamp.
+		 */
+		int rate;
+
+		if (rx_status->flag & RX_FLAG_HT)
+			rate =3D 65; /* TODO: HT rates */
 		else
-			/* can't merge without knowing the TSF */
-			rx_timestamp =3D -1LLU;
+			rate =3D local->hw.wiphy->bands[band]->
+				bitrates[rx_status->rate_idx].bitrate;
+
+		rx_timestamp =3D rx_status->mactime + (24 * 8 * 10 / rate);
+	} else if (local && local->ops && local->ops->get_tsf)
+		/* second best option: get current TSF */
+		rx_timestamp =3D local->ops->get_tsf(local_to_hw(local));
+	else
+		/* can't merge without knowing the TSF */
+		rx_timestamp =3D -1LLU;
+
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-		printk(KERN_DEBUG "RX beacon SA=3D%pM BSSID=3D"
-		       "%pM TSF=3D0x%llx BCN=3D0x%llx diff=3D%lld @%lu\n",
-		       mgmt->sa, mgmt->bssid,
-		       (unsigned long long)rx_timestamp,
-		       (unsigned long long)beacon_timestamp,
-		       (unsigned long long)(rx_timestamp - beacon_timestamp),
-		       jiffies);
-#endif /* CONFIG_MAC80211_IBSS_DEBUG */
-		if (beacon_timestamp > rx_timestamp) {
+	printk(KERN_DEBUG "RX beacon SA=3D%pM BSSID=3D"
+	       "%pM TSF=3D0x%llx BCN=3D0x%llx diff=3D%lld @%lu\n",
+	       mgmt->sa, mgmt->bssid,
+	       (unsigned long long)rx_timestamp,
+	       (unsigned long long)beacon_timestamp,
+	       (unsigned long long)(rx_timestamp - beacon_timestamp),
+	       jiffies);
+#endif
+
+	if (beacon_timestamp > rx_timestamp) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-			printk(KERN_DEBUG "%s: beacon TSF higher than "
-			       "local TSF - IBSS merge with BSSID %pM\n",
-			       sdata->dev->name, mgmt->bssid);
+		printk(KERN_DEBUG "%s: beacon TSF higher than "
+		       "local TSF - IBSS merge with BSSID %pM\n",
+		       sdata->dev->name, mgmt->bssid);
 #endif
-			ieee80211_sta_join_ibss(sdata, &sdata->u.sta, bss);
-			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
-		}
+		ieee80211_sta_join_ibss(sdata, &sdata->u.sta, bss);
+		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
 	}
=20
+ put_bss:
 	ieee80211_rx_bss_put(local, bss);
 }
=20
@@ -1948,8 +1960,7 @@ static void ieee80211_rx_mgmt_probe_req(
 	struct ieee80211_mgmt *resp;
 	u8 *pos, *end;
=20
-	if (sdata->vif.type !=3D NL80211_IFTYPE_ADHOC ||
-	    ifsta->state !=3D IEEE80211_STA_MLME_IBSS_JOINED ||
+	if (ifsta->state !=3D IEEE80211_STA_MLME_IBSS_JOINED ||
 	    len < 24 + 2 || !ifsta->probe_resp)
 		return;
=20
@@ -2053,31 +2064,54 @@ static void ieee80211_sta_rx_queued_mgmt
 	mgmt =3D (struct ieee80211_mgmt *) skb->data;
 	fc =3D le16_to_cpu(mgmt->frame_control);
=20
-	switch (fc & IEEE80211_FCTL_STYPE) {
-	case IEEE80211_STYPE_PROBE_REQ:
-		ieee80211_rx_mgmt_probe_req(sdata, ifsta, mgmt, skb->len);
-		break;
-	case IEEE80211_STYPE_PROBE_RESP:
-		ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len, rx_status);
-		break;
-	case IEEE80211_STYPE_BEACON:
-		ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len, rx_status);
-		break;
-	case IEEE80211_STYPE_AUTH:
-		ieee80211_rx_mgmt_auth(sdata, ifsta, mgmt, skb->len);
-		break;
-	case IEEE80211_STYPE_ASSOC_RESP:
-		ieee80211_rx_mgmt_assoc_resp(sdata, ifsta, mgmt, skb->len, 0);
-		break;
-	case IEEE80211_STYPE_REASSOC_RESP:
-		ieee80211_rx_mgmt_assoc_resp(sdata, ifsta, mgmt, skb->len, 1);
-		break;
-	case IEEE80211_STYPE_DEAUTH:
-		ieee80211_rx_mgmt_deauth(sdata, ifsta, mgmt, skb->len);
-		break;
-	case IEEE80211_STYPE_DISASSOC:
-		ieee80211_rx_mgmt_disassoc(sdata, ifsta, mgmt, skb->len);
-		break;
+	if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC) {
+		switch (fc & IEEE80211_FCTL_STYPE) {
+		case IEEE80211_STYPE_PROBE_REQ:
+			ieee80211_rx_mgmt_probe_req(sdata, ifsta, mgmt,
+						    skb->len);
+			break;
+		case IEEE80211_STYPE_PROBE_RESP:
+			ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len,
+						     rx_status);
+			break;
+		case IEEE80211_STYPE_BEACON:
+			ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len,
+						 rx_status);
+			break;
+		case IEEE80211_STYPE_AUTH:
+			ieee80211_rx_mgmt_auth_ibss(sdata, ifsta, mgmt,
+						    skb->len);
+			break;
+		}
+	} else { /* NL80211_IFTYPE_STATION */
+		switch (fc & IEEE80211_FCTL_STYPE) {
+		case IEEE80211_STYPE_PROBE_RESP:
+			ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len,
+						     rx_status);
+			break;
+		case IEEE80211_STYPE_BEACON:
+			ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len,
+						 rx_status);
+			break;
+		case IEEE80211_STYPE_AUTH:
+			ieee80211_rx_mgmt_auth(sdata, ifsta, mgmt, skb->len);
+			break;
+		case IEEE80211_STYPE_ASSOC_RESP:
+			ieee80211_rx_mgmt_assoc_resp(sdata, ifsta, mgmt,
+						     skb->len, 0);
+			break;
+		case IEEE80211_STYPE_REASSOC_RESP:
+			ieee80211_rx_mgmt_assoc_resp(sdata, ifsta, mgmt,
+						     skb->len, 1);
+			break;
+		case IEEE80211_STYPE_DEAUTH:
+			ieee80211_rx_mgmt_deauth(sdata, ifsta, mgmt, skb->len);
+			break;
+		case IEEE80211_STYPE_DISASSOC:
+			ieee80211_rx_mgmt_disassoc(sdata, ifsta, mgmt,
+						   skb->len);
+			break;
+		}
 	}
=20
 	kfree_skb(skb);


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
