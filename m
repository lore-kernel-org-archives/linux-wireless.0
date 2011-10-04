Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab1JDNHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 09:07:37 -0400
Subject: [PATCH] mac80211: pass no-CCK flag through to HW scan
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 15:07:33 +0200
Message-ID: <1317733653.6741.10.camel@jlt3.sipsolutions.net> (sfid-20111004_150741_298694_2C5933E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is needed so that offloaded scan can do the
right thing. Without this patch, the no_cck flag
contains random values from the kernel heap.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mac80211/scan.c	2011-09-28 17:10:13.000000000 +0200
+++ b/net/mac80211/scan.c	2011-10-04 15:06:01.000000000 +0200
@@ -254,6 +254,7 @@ static bool ieee80211_prep_hw_scan(struc
 					 req->ie, req->ie_len, band,
 					 req->rates[band], 0);
 	local->hw_scan_req->ie_len = ielen;
+	local->hw_scan_req->no_cck = req->no_cck;
 
 	return true;
 }


