Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab0GLMrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 08:47:10 -0400
Subject: [PATCH] cfg80211: ignore spurious deauth
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <AANLkTikWA9YeoTgYWrpE5J7RW3BJGu2LPqP-iBIdAUHs@mail.gmail.com>
References: <AANLkTilV1t1737ciSPyyETeBEcN_QXsYxgEwpZIIucR2@mail.gmail.com>
	 <1278091743.15412.17.camel@jlt3.sipsolutions.net>
	 <AANLkTikfegnc1gAwIUiZKaMeDoUYOFqK8eSc6_3wUggm@mail.gmail.com>
	 <1278094401.15412.27.camel@jlt3.sipsolutions.net>
	 <AANLkTikWA9YeoTgYWrpE5J7RW3BJGu2LPqP-iBIdAUHs@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jul 2010 14:46:43 +0200
Message-ID: <1278938803.5870.24.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Ever since mac80211/drivers are no longer
fully in charge of keeping track of the
auth status, trying to make them do so will
fail. Instead of warning and reporting the
deauthentication to userspace, cfg80211 must
simply ignore it so that spurious
deauthentications, e.g. before starting
authentication, aren't seen by userspace as
actual deauthentications.

Cc: stable@kernel.org
Reported-by: Paul Stewart <pstew@google.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/mlme.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/wireless/mlme.c	2010-07-12 14:34:22.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2010-07-12 14:42:27.000000000 +0200
@@ -44,10 +44,10 @@ void cfg80211_send_rx_auth(struct net_de
 		}
 	}
 
-	WARN_ON(!done);
-
-	nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
-	cfg80211_sme_rx_auth(dev, buf, len);
+	if (done) {
+		nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
+		cfg80211_sme_rx_auth(dev, buf, len);
+	}
 
 	wdev_unlock(wdev);
 }


