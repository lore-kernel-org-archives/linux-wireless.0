Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZI2WJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 18:09:52 -0400
Subject: [PATCH] mac80211: fix BSS leak
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 00:09:25 +0200
Message-Id: <1254262165.30589.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IBSS code leaks a BSS struct after telling
cfg80211 about a given BSS by passing a frame.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ibss.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2009-09-30 00:05:12.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-09-30 00:08:18.000000000 +0200
@@ -73,6 +73,7 @@ static void __ieee80211_sta_join_ibss(st
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
 	struct ieee80211_supported_band *sband;
+	struct cfg80211_bss *bss;
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 
@@ -177,8 +178,9 @@ static void __ieee80211_sta_join_ibss(st
 	mod_timer(&ifibss->timer,
 		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
 
-	cfg80211_inform_bss_frame(local->hw.wiphy, local->hw.conf.channel,
-				  mgmt, skb->len, 0, GFP_KERNEL);
+	bss = cfg80211_inform_bss_frame(local->hw.wiphy, local->hw.conf.channel,
+					mgmt, skb->len, 0, GFP_KERNEL);
+	cfg80211_put_bss(bss);
 	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, GFP_KERNEL);
 }
 


