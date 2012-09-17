Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32916 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2IQKfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 06:35:46 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] wireless: remove unreachable code
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date: Mon, 17 Sep 2012 11:54:15 +0100
Message-ID: <20120917105354.30097.45595.stgit@localhost.localdomain> (sfid-20120917_123550_034380_87C5773D)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

The only case where intersected_rd can become non NULL is within an if. All
paths from that if return, so the end chunk has therefore squawked its
last and is no more.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 net/wireless/reg.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1ad04e5..4a405c2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2305,24 +2305,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		return 0;
 	}
 
-	if (!intersected_rd)
-		return -EINVAL;
-
-	rdev = wiphy_to_dev(request_wiphy);
-
-	rdev->country_ie_alpha2[0] = rd->alpha2[0];
-	rdev->country_ie_alpha2[1] = rd->alpha2[1];
-	rdev->env = last_request->country_ie_env;
-
-	BUG_ON(intersected_rd == rd);
-
-	kfree(rd);
-	rd = NULL;
-
-	reset_regdomains(false);
-	cfg80211_regdomain = intersected_rd;
-
-	return 0;
+	return -EINVAL;
 }
 
 

