Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbZBKREz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 12:04:55 -0500
Subject: [PATCH] mac80211: fix compilation failure in ibss debug
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 18:04:53 +0100
Message-Id: <1234371893.16004.15.camel@johannes.local> (sfid-20090211_180458_860396_7C1C62A6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry! Replaced "found" variable in one of the scan patches and forgot
ibss debug.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
bug introduced in:

commit 663fc3dff0b68e905184794f70e2040988936c70
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Feb 10 21:26:00 2009 +0100

    mac80211: use cfg80211s BSS infrastructure

 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-02-11 18:02:15.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-02-11 18:02:17.000000000 +0100
@@ -2340,7 +2340,7 @@ static int ieee80211_sta_find_ibss(struc
 						ifsta->ssid, ifsta->ssid_len);
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-	if (found)
+	if (bss)
 		printk(KERN_DEBUG "   sta_find_ibss: selected %pM current "
 		       "%pM\n", bss->cbss.bssid, ifsta->bssid);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */


