Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762740Ab0GUIJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 04:09:29 -0400
Subject: [PATCH] mac80211: refuse shared key auth when WEP is unavailable
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100720185643.GB3468@tuxdriver.com>
References: <1278528270-9703-1-git-send-email-linville@tuxdriver.com>
	 <1278529669-9904-1-git-send-email-linville@tuxdriver.com>
	 <1279623588.3706.17.camel@jlt3.sipsolutions.net>
	 <20100720185643.GB3468@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 10:09:25 +0200
Message-ID: <1279699765.3707.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When WEP is not available, we should reject shared
key authentication because it could never succeed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/mac80211/mlme.c	2010-07-21 10:07:20.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-07-21 10:07:20.000000000 +0200
@@ -2030,6 +2030,8 @@ int ieee80211_mgd_auth(struct ieee80211_
 		auth_alg = WLAN_AUTH_OPEN;
 		break;
 	case NL80211_AUTHTYPE_SHARED_KEY:
+		if (IS_ERR(sdata->local->wep_tx_tfm))
+			return -EOPNOTSUPP;
 		auth_alg = WLAN_AUTH_SHARED_KEY;
 		break;
 	case NL80211_AUTHTYPE_FT:


