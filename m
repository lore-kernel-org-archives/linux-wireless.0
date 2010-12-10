Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab0LJQKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 11:10:47 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1PR5YU-0003k1-2p
	for linux-wireless@vger.kernel.org; Fri, 10 Dec 2010 17:10:46 +0100
Subject: [RFC] mac80211: support IBSS RSN with SW crypto
From: Johannes Berg <johannes@sipsolutions.net>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 17:10:44 +0100
Message-ID: <1291997444.3531.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When software crypto is used, mac80211 will
support IBSS RSN, it doesn't depend on the
driver in that case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/main.c	2010-12-10 17:07:22.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2010-12-10 17:08:25.000000000 +0100
@@ -517,11 +517,15 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	wiphy->mgmt_stypes = ieee80211_default_mgmt_stypes;
 
+	wiphy->privid = mac80211_wiphy_privid;
+
 	wiphy->flags |= WIPHY_FLAG_NETNS_OK |
 			WIPHY_FLAG_4ADDR_AP |
 			WIPHY_FLAG_4ADDR_STATION |
 			WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS;
-	wiphy->privid = mac80211_wiphy_privid;
+
+	if (!ops->set_key)
+		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
 	wiphy->bss_priv_size = sizeof(struct ieee80211_bss);
 


