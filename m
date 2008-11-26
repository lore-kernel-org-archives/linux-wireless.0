Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out11.libero.it ([212.52.84.111]:51700 "EHLO
	cp-out11.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYKZWST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 17:18:19 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: accept empty strings for hidden SSIDs
Date: Wed, 26 Nov 2008 22:44:23 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
MIME-Version: 1.0
Message-Id: <200811262244.23980.rossi.f@inwind.it> (sfid-20081126_231825_110899_5C66C6E2)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some access points (e.g. Sitecom WL-174) use an empty string as hidden SSID.

Signed-off-by: Fabio Rossi <rossi.f@inwind.it>
---
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 88b0b4d..dc59f76 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2023,7 +2023,7 @@ static int ieee80211_sta_match_ssid(struct ieee80211_if_sta *ifsta,
 		}
 	}
 
-	if (hidden_ssid && ifsta->ssid_len == ssid_len)
+	if (hidden_ssid && (ifsta->ssid_len == ssid_len || ssid_len == 0))
 		return 1;
 
 	if (ssid_len == 1 && ssid[0] == ' ')

