Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:57449 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab0EZMdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 08:33:38 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix basic rates for created IBSS networks
Date: Wed, 26 May 2010 15:34:32 +0300
Message-Id: <1274877272-22487-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the mac80211 marks rates 1 and 2 mbps as basic rates for created
ad-hoc networks. To be certifiable, rates 1, 2, 5.5 and 12 need to be marked
basic.

Change this.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/ibss.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b2cc1fd..448cf57 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -529,7 +529,8 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, 3, /* first two are basic */
+				  ifibss->channel,
+				  15, /* 1, 2, 5.5 and 12 are basic */
 				  capability, 0);
 }
 
-- 
1.6.3.3

