Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38034 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbZDVJip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 05:38:45 -0400
Subject: [PATCH] mac80211: fix variable truncation on 32-bit
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-next@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090422144537.06937b16.sfr@canb.auug.org.au>
References: <20090422144537.06937b16.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 11:25:43 +0200
Message-Id: <1240392343.20308.6.camel@johannes.local> (sfid-20090422_113848_881539_58D9C896)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell reported these warnings from a 32-bit build:

  net/mac80211/mlme.c:1771: warning: left shift count >= width of type
  net/mac80211/mlme.c:1772: warning: left shift count >= width of type
  net/mac80211/mlme.c:1773: warning: left shift count >= width of type
  net/mac80211/mlme.c:1774: warning: left shift count >= width of type
  net/mac80211/mlme.c:1775: warning: left shift count >= width of type

This shows a bug in my code -- BIT(X) uses just "1 << X" which means
a 32-bit integer on 32-bit platforms, but the code here needs a u64
on all platforms. Fix this by using "1ULL << X" instead of BIT(X).

Thanks Stephen!

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-22 11:19:20.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-22 11:19:54.000000000 +0200
@@ -1743,12 +1743,12 @@ static void ieee80211_rx_mgmt_probe_resp
  *	look out for other vendor IEs.
  */
 static const u64 care_about_ies =
-	BIT(WLAN_EID_COUNTRY) |
-	BIT(WLAN_EID_ERP_INFO) |
-	BIT(WLAN_EID_CHANNEL_SWITCH) |
-	BIT(WLAN_EID_PWR_CONSTRAINT) |
-	BIT(WLAN_EID_HT_CAPABILITY) |
-	BIT(WLAN_EID_HT_INFORMATION);
+	(1ULL << WLAN_EID_COUNTRY) |
+	(1ULL << WLAN_EID_ERP_INFO) |
+	(1ULL << WLAN_EID_CHANNEL_SWITCH) |
+	(1ULL << WLAN_EID_PWR_CONSTRAINT) |
+	(1ULL << WLAN_EID_HT_CAPABILITY) |
+	(1ULL << WLAN_EID_HT_INFORMATION);
 
 static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt,


