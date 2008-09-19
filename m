Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbYISDLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 23:11:14 -0400
Subject: [PATCH] mac80211: probe with correct SSID
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 05:10:34 +0200
Message-Id: <1221793834.10419.0.camel@johannes.berg> (sfid-20080919_051124_220020_FD8A42B6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While associated, we should probe with the SSID we're associated to,
not the scan SSID.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-19 01:46:33.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-19 01:46:47.000000000 +0200
@@ -973,8 +973,8 @@ static void ieee80211_associated(struct 
 				disassoc = 1;
 			} else
 				ieee80211_send_probe_req(sdata, ifsta->bssid,
-							 local->scan_ssid,
-							 local->scan_ssid_len);
+							 ifsta->ssid,
+							 ifsta->ssid_len);
 			ifsta->flags ^= IEEE80211_STA_PROBEREQ_POLL;
 		} else {
 			ifsta->flags &= ~IEEE80211_STA_PROBEREQ_POLL;


