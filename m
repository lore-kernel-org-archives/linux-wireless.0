Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab0EENd6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 09:33:58 -0400
Subject: [PATCH v2] mac80211: improve IBSS scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1272869388.3614.0.camel@jlt3.sipsolutions.net>
References: <1272869388.3614.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 15:33:55 +0200
Message-ID: <1273066435.3728.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When IBSS is fixed to a frequency, it can still
scan to try to find the right BSSID. This makes
sense if the BSSID isn't also fixed, but it need
not scan all channels -- just one is sufficient.
Make it do that by moving the scan setup code to
ieee80211_request_internal_scan() and include
a channel variable setting.

Note that this can be further improved to start
the IBSS right away if both frequency and BSSID
are fixed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Argh, forgot a quilt refresh :(

 net/mac80211/ibss.c        |   15 ++++++++++++---
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/main.c        |   17 +----------------
 net/mac80211/scan.c        |   28 +++++++++++++++++++++++++++-
 4 files changed, 42 insertions(+), 21 deletions(-)

--- wireless-testing.orig/net/mac80211/main.c	2010-05-02 17:47:28.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-05-05 15:32:16.000000000 +0200
@@ -439,7 +439,7 @@ int ieee80211_register_hw(struct ieee802
 	struct ieee80211_local *local = hw_to_local(hw);
 	int result;
 	enum ieee80211_band band;
-	int channels, i, j, max_bitrates;
+	int channels, max_bitrates;
 	bool supp_ht;
 	static const u32 cipher_suites[] = {
 		WLAN_CIPHER_SUITE_WEP40,
@@ -605,21 +605,6 @@ int ieee80211_register_hw(struct ieee802
 
 	ieee80211_led_init(local);
 
-	/* alloc internal scan request */
-	i = 0;
-	local->int_scan_req->ssids = &local->scan_ssid;
-	local->int_scan_req->n_ssids = 1;
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-		if (!hw->wiphy->bands[band])
-			continue;
-		for (j = 0; j < hw->wiphy->bands[band]->n_channels; j++) {
-			local->int_scan_req->channels[i] =
-				&hw->wiphy->bands[band]->channels[j];
-			i++;
-		}
-	}
-	local->int_scan_req->n_channels = i;
-
 	local->network_latency_notifier.notifier_call =
 		ieee80211_max_network_latency;
 	result = pm_qos_add_notifier(PM_QOS_NETWORK_LATENCY,
--- wireless-testing.orig/net/mac80211/scan.c	2010-05-02 17:47:28.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2010-05-02 17:47:50.000000000 +0200
@@ -729,10 +729,12 @@ int ieee80211_request_scan(struct ieee80
 }
 
 int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
-				    const u8 *ssid, u8 ssid_len)
+				    const u8 *ssid, u8 ssid_len,
+				    struct ieee80211_channel *chan)
 {
 	struct ieee80211_local *local = sdata->local;
 	int ret = -EBUSY;
+	enum nl80211_band band;
 
 	mutex_lock(&local->scan_mtx);
 
@@ -740,6 +742,30 @@ int ieee80211_request_internal_scan(stru
 	if (local->scan_req)
 		goto unlock;
 
+	/* fill internal scan request */
+	if (!chan) {
+		int i, nchan = 0;
+
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+			if (!local->hw.wiphy->bands[band])
+				continue;
+			for (i = 0;
+			     i < local->hw.wiphy->bands[band]->n_channels;
+			     i++) {
+				local->int_scan_req->channels[nchan] =
+				    &local->hw.wiphy->bands[band]->channels[i];
+				nchan++;
+			}
+		}
+
+		local->int_scan_req->n_channels = nchan;
+	} else {
+		local->int_scan_req->channels[0] = chan;
+		local->int_scan_req->n_channels = 1;
+	}
+
+	local->int_scan_req->ssids = &local->scan_ssid;
+	local->int_scan_req->n_ssids = 1;
 	memcpy(local->int_scan_req->ssids[0].ssid, ssid, IEEE80211_MAX_SSID_LEN);
 	local->int_scan_req->ssids[0].ssid_len = ssid_len;
 
--- wireless-testing.orig/net/mac80211/ibss.c	2010-05-02 17:47:28.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-05-05 15:32:16.000000000 +0200
@@ -489,7 +489,9 @@ static void ieee80211_sta_merge_ibss(str
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->name);
 
-	ieee80211_request_internal_scan(sdata, ifibss->ssid, ifibss->ssid_len);
+	ieee80211_request_internal_scan(sdata,
+			ifibss->ssid, ifibss->ssid_len,
+			ifibss->fixed_channel ? ifibss->channel : NULL);
 }
 
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
@@ -596,8 +598,9 @@ static void ieee80211_sta_find_ibss(stru
 		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
 		       "join\n", sdata->name);
 
-		ieee80211_request_internal_scan(sdata, ifibss->ssid,
-						ifibss->ssid_len);
+		ieee80211_request_internal_scan(sdata,
+				ifibss->ssid, ifibss->ssid_len,
+				ifibss->fixed_channel ? ifibss->channel : NULL);
 	} else {
 		int interval = IEEE80211_SCAN_INTERVAL;
 
@@ -905,6 +908,12 @@ int ieee80211_ibss_join(struct ieee80211
 	sdata->u.ibss.channel = params->channel;
 	sdata->u.ibss.fixed_channel = params->channel_fixed;
 
+	/* fix ourselves to that channel now already */
+	if (params->channel_fixed) {
+		sdata->local->oper_channel = params->channel;
+		sdata->local->oper_channel_type = NL80211_CHAN_NO_HT;
+	}
+
 	if (params->ie) {
 		sdata->u.ibss.ie = kmemdup(params->ie, params->ie_len,
 					   GFP_KERNEL);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-05-05 15:32:18.000000000 +0200
@@ -1020,7 +1020,8 @@ void ieee80211_ibss_restart(struct ieee8
 /* scan/BSS handling */
 void ieee80211_scan_work(struct work_struct *work);
 int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
-				    const u8 *ssid, u8 ssid_len);
+				    const u8 *ssid, u8 ssid_len,
+				    struct ieee80211_channel *chan);
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_scan_request *req);
 void ieee80211_scan_cancel(struct ieee80211_local *local);


