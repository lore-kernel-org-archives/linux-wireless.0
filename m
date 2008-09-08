Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbYIHPr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:47:27 -0400
Subject: [PATCH 9/8] mac80211: clarify scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080908154421.216772000@sipsolutions.net> (sfid-20080908_174606_739824_DD7A31F6)
References: <20080908154421.216772000@sipsolutions.net>
	 (sfid-20080908_174606_739824_DD7A31F6)
Content-Type: text/plain
Date: Mon, 08 Sep 2008 17:47:23 +0200
Message-Id: <1220888843.31304.76.camel@johannes.berg> (sfid-20080908_174741_420172_A261D7CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a scan is requested for non-STA interfaces, we simply fire
off a scan, but for STA interfaces we shouldn't because they
could be in the middle of an association. This clarifies the
corresponding code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/scan.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- everything.orig/net/mac80211/scan.c	2008-09-08 17:01:21.000000000 +0200
+++ everything/net/mac80211/scan.c	2008-09-08 17:23:59.000000000 +0200
@@ -674,23 +674,32 @@ int ieee80211_sta_start_scan(struct ieee
 
 int ieee80211_sta_req_scan(struct ieee80211_sub_if_data *sdata, u8 *ssid, size_t ssid_len)
 {
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_sta *ifsta;
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
 		return ieee80211_sta_start_scan(sdata, ssid, ssid_len);
 
+	/*
+	 * STA has a state machine that might need to defer scanning
+	 * while it's trying to associate/authenticate, therefore we
+	 * queue it up to the state machine in that case.
+	 */
+
 	if (local->sta_sw_scanning || local->sta_hw_scanning) {
 		if (local->scan_sdata == sdata)
 			return 0;
 		return -EBUSY;
 	}
 
+	ifsta = &sdata->u.sta;
+
 	ifsta->scan_ssid_len = ssid_len;
 	if (ssid_len)
 		memcpy(ifsta->scan_ssid, ssid, ssid_len);
 	set_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request);
 	queue_work(local->hw.workqueue, &ifsta->work);
+
 	return 0;
 }
 


