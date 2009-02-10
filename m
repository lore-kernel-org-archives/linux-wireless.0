Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbZBJUcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:32:32 -0500
Message-Id: <20090210202553.482117002@sipsolutions.net> (sfid-20090210_213236_374841_C73D0E42)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:41 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 05/27] mac80211: reject extra IEs for probe request when
	hw_scan
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We cannot currently hand off extra IEs to hw_scan, so reject
configuring extra IEs for probe request frames when hw_scan
is set.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>
---
 net/mac80211/cfg.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2009-02-10 20:59:27.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-02-10 20:59:30.000000000 +0100
@@ -1176,11 +1176,16 @@ static int ieee80211_set_channel(struct 
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
+		if (local->ops->hw_scan)
+			break;
 		kfree(ifsta->ie_probereq);
 		ifsta->ie_probereq = ies;
 		ifsta->ie_probereq_len = ies_len;
@@ -1244,7 +1249,7 @@ static int ieee80211_set_mgmt_extra_ie(s
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
-		ret = set_mgmt_extra_ie_sta(&sdata->u.sta, params->subtype,
+		ret = set_mgmt_extra_ie_sta(sdata, params->subtype,
 					    ies, ies_len);
 		break;
 	default:

-- 

