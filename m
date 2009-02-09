Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59973 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669AbZBIUBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 15:01:04 -0500
Subject: [PATCH] mac80211: reject extra IEs for probe resp when hw_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 21:00:31 +0100
Message-Id: <1234209631.4175.242.camel@johannes.local> (sfid-20090209_210133_384668_7BC4C69F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We cannot currently hand off extra IEs to hw_scan, so reject
configuring extra IEs for probe response frames when hw_scan
is set.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>
---
 net/mac80211/cfg.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2009-02-09 20:56:40.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-02-09 20:58:46.000000000 +0100
@@ -1176,9 +1176,12 @@ static int ieee80211_set_channel(struct 
 	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 }
 
-static int set_mgmt_extra_ie_sta(struct ieee80211_if_sta *ifsta, u8 subtype,
-				 u8 *ies, size_t ies_len)
+static int set_mgmt_extra_ie_sta(struct ieee80211_sub_if_data *sdata,
+				 u8 subtype, u8 *ies, size_t ies_len)
 {
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+
 	switch (subtype) {
 	case IEEE80211_STYPE_PROBE_REQ >> 4:
 		kfree(ifsta->ie_probereq);
@@ -1186,6 +1189,8 @@ static int set_mgmt_extra_ie_sta(struct 
 		ifsta->ie_probereq_len = ies_len;
 		return 0;
 	case IEEE80211_STYPE_PROBE_RESP >> 4:
+		if (local->ops->hw_scan)
+			break;
 		kfree(ifsta->ie_proberesp);
 		ifsta->ie_proberesp = ies;
 		ifsta->ie_proberesp_len = ies_len;
@@ -1244,7 +1249,7 @@ static int ieee80211_set_mgmt_extra_ie(s
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
-		ret = set_mgmt_extra_ie_sta(&sdata->u.sta, params->subtype,
+		ret = set_mgmt_extra_ie_sta(sdata, params->subtype,
 					    ies, ies_len);
 		break;
 	default:


