Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35986 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbZGATfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:35:50 -0400
Message-Id: <20090701193419.826590018@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:26:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/20 v4] mac80211: tell SME about real auth state
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the auth algorithm is rejected, but we don't have
another one to try, we will eventually retry but that
isn't useful -- we'll then do it again and again until
we eventually give up. Instead, we should let the SME
know and go into disabled state. The same applies for
situations where the AP rejects with any other status
code.

Additionally, when trying the next auth algorithm, we
should reset the auth_tries so that just a single lost
frame doesn't lead to us giving up on the third auth
algorithm.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-01 09:01:15.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-01 09:01:19.000000000 +0200
@@ -1511,9 +1511,15 @@ static void ieee80211_rx_mgmt_auth(struc
 				    !ieee80211_sta_wep_configured(sdata))
 					continue;
 				ifmgd->auth_alg = algs[pos];
-				break;
+				ifmgd->auth_tries = 0;
+				return;
 			}
 		}
+		/* nothing else to try -- give up */
+		cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, len,
+				      GFP_KERNEL);
+		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_idle(sdata->local);
 		return;
 	}
 

-- 

