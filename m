Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:25800 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752068Ab2LBRJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 12:09:30 -0500
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 2/2] mac80211: configure short_preamble capability if requested
Date: Sun, 2 Dec 2012 18:08:27 +0100
Message-ID: <1354468107-27430-2-git-send-email-antonio@open-mesh.com> (sfid-20121202_180943_550951_93B5BE5E)
In-Reply-To: <1354468107-27430-1-git-send-email-antonio@open-mesh.com>
References: <1354468107-27430-1-git-send-email-antonio@open-mesh.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the short preamble option is specified by the user on
IBSS join, mac80211 will try to set it in the driver.
Such capability is then advertised by Beacons/ProbeResp
in the capability field.

A station not matching the short_preamble capability of
another set of nodes cannot join the same cell.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/ibss.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 11a6a1b..e5ba99a 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -535,6 +535,11 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	if (!(cbss->capability & WLAN_CAPABILITY_IBSS))
 		goto put_bss;
 
+	/* not using the same preamble policy */
+	if ((cbss->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) !=
+	    sdata->vif.bss_conf.use_short_preamble)
+		goto put_bss;
+
 	/* different channel */
 	if (sdata->u.ibss.fixed_channel &&
 	    sdata->u.ibss.channel != cbss->channel)
@@ -724,6 +729,9 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 	else
 		sdata->drop_unencrypted = 0;
 
+	if (ifibss->vif.bss_conf.use_short_preamble)
+		capability |= WLAN_CAPABILITY_SHORT_PREAMBLE;
+
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
 				  ifibss->channel, ifibss->basic_rates,
 				  capability, 0, true);
@@ -754,6 +762,8 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	capability = WLAN_CAPABILITY_IBSS;
 	if (ifibss->privacy)
 		capability |= WLAN_CAPABILITY_PRIVACY;
+	if (ifibss->vif.bss_conf.use_short_preamble)
+		capability |= WLAN_CAPABILITY_SHORT_PREAMBLE;
 	if (ifibss->fixed_bssid)
 		bssid = ifibss->bssid;
 	if (ifibss->fixed_channel)
@@ -762,8 +772,8 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		bssid = ifibss->bssid;
 	cbss = cfg80211_get_bss(local->hw.wiphy, chan, bssid,
 				ifibss->ssid, ifibss->ssid_len,
-				WLAN_CAPABILITY_IBSS | WLAN_CAPABILITY_PRIVACY,
-				capability);
+				WLAN_CAPABILITY_IBSS | WLAN_CAPABILITY_PRIVACY |
+				WLAN_CAPABILITY_SHORT_PREAMBLE, capability);
 
 	if (cbss) {
 		struct ieee80211_bss *bss;
@@ -1102,6 +1112,9 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	memcpy(sdata->u.ibss.ssid, params->ssid, params->ssid_len);
 	sdata->u.ibss.ssid_len = params->ssid_len;
 
+	sdata->vif.bss_conf.use_short_preamble = params->use_short_preamble;
+	changed |= BSS_CHANGED_ERP_PREAMBLE;
+
 	mutex_unlock(&sdata->u.ibss.mtx);
 
 	mutex_lock(&sdata->local->mtx);
@@ -1156,11 +1169,14 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 
 		if (ifibss->privacy)
 			capability |= WLAN_CAPABILITY_PRIVACY;
+		if (ifibss->vif.bss_conf.use_short_preamble)
+			capability |= WLAN_CAPABILITY_SHORT_PREAMBLE;
 
 		cbss = cfg80211_get_bss(local->hw.wiphy, ifibss->channel,
 					ifibss->bssid, ifibss->ssid,
 					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
-					WLAN_CAPABILITY_PRIVACY,
+					WLAN_CAPABILITY_PRIVACY |
+					WLAN_CAPABILITY_SHORT_PREAMBLE,
 					capability);
 
 		if (cbss) {
-- 
1.8.0

