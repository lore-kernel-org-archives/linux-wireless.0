Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45244 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbYDALs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 07:48:58 -0400
Message-Id: <20080331172433.692925000@sipsolutions.net> (sfid-20080401_124933_076259_7165C94D)
References: <20080331172258.541914000@sipsolutions.net>
Date: Mon, 31 Mar 2008 19:22:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/6] mac80211 ibss: flush only stations belonging to
	current interface
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When joining a new IBSS, all old stations are flushed, but currently
all stations belonging to all virtual interfaces are flushed, which
is wrong. This patch fixes it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_sta.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/ieee80211_sta.c	2008-03-31 18:21:58.000000000 +0200
+++ everything/net/mac80211/ieee80211_sta.c	2008-03-31 18:22:23.000000000 +0200
@@ -2231,8 +2231,10 @@ static int ieee80211_sta_join_ibss(struc
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	/* Remove possible STA entries from other IBSS networks. */
-	sta_info_flush(local, NULL);
+	sta_info_flush(local, sdata);
 
 	if (local->ops->reset_tsf) {
 		/* Reset own TSF to allow time synchronization work. */
@@ -2245,7 +2247,6 @@ static int ieee80211_sta_join_ibss(struc
 
 	local->hw.conf.beacon_int = bss->beacon_int >= 10 ? bss->beacon_int : 10;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	sdata->drop_unencrypted = bss->capability &
 		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 

-- 

