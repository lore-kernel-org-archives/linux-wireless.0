Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYIHObx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 10:31:53 -0400
Subject: [PATCH 5/3] mac80211: fix typo in action frame handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080908090507.641740000@sipsolutions.net> (sfid-20080908_110822_044365_11756028)
References: <20080908090507.641740000@sipsolutions.net>
	 (sfid-20080908_110822_044365_11756028)
Content-Type: text/plain
Date: Mon, 08 Sep 2008 16:31:48 +0200
Message-Id: <1220884308.31304.62.camel@johannes.berg> (sfid-20080908_163156_447836_6887EBA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This says chan_switch.action_code but really means
measurement.action_code, of course the actual offset in
the frame is the same, it's just harder to understand
this way.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-08 16:29:54.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 16:29:56.000000000 +0200
@@ -2997,7 +2997,7 @@ static void ieee80211_rx_mgmt_action(str
 	case WLAN_CATEGORY_SPECTRUM_MGMT:
 		if (local->hw.conf.channel->band != IEEE80211_BAND_5GHZ)
 			break;
-		switch (mgmt->u.action.u.chan_switch.action_code) {
+		switch (mgmt->u.action.u.measurement.action_code) {
 		case WLAN_ACTION_SPCT_MSR_REQ:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.measurement)))


