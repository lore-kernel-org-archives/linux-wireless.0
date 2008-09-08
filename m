Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYIHPhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:37:19 -0400
Message-Id: <20080908153509.159561000@sipsolutions.net> (sfid-20080908_173723_848103_0FF014BE)
References: <20080908153336.891710000@sipsolutions.net>
Date: Mon, 08 Sep 2008 17:33:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, tomasw@gmail.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/4] mac80211: disassociate when moving to new BSS
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes the MLME cleanly disassociate from the current BSS
when leaving it for a new one. This is not just nicer to the old AP
(we're leaving it, might as well tell it!) but also required for some
drivers that keep track of the station we're associated with, they'd
get confused because they'd think we are associated with two APs.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-08 16:39:55.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 16:39:57.000000000 +0200
@@ -3272,9 +3272,14 @@ void ieee80211_sta_req_auth(struct ieee8
 		return;
 
 	if ((ifsta->flags & (IEEE80211_STA_BSSID_SET |
-				IEEE80211_STA_AUTO_BSSID_SEL)) &&
+			     IEEE80211_STA_AUTO_BSSID_SEL)) &&
 	    (ifsta->flags & (IEEE80211_STA_SSID_SET |
-				IEEE80211_STA_AUTO_SSID_SEL))) {
+			     IEEE80211_STA_AUTO_SSID_SEL))) {
+
+		if (ifsta->state == IEEE80211_STA_MLME_ASSOCIATED)
+			ieee80211_set_disassoc(sdata, ifsta, true, true,
+					       WLAN_REASON_DEAUTH_LEAVING);
+
 		set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
 		queue_work(local->hw.workqueue, &ifsta->work);
 	}

-- 

