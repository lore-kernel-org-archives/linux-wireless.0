Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56057 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZBUFEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:04:39 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v6 09/15] cfg80211: protect first access of last_request on 11d hint under mutex
Date: Sat, 21 Feb 2009 00:04:27 -0500
Message-Id: <1235192673-6314-10-git-send-email-lrodriguez@atheros.com> (sfid-20090221_060444_166332_C42D22F5)
In-Reply-To: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com>
References: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were not protecting last_request there is a small possible race
between an 11d hint and another routine which calls reset_regdomains()
which can prevent a valid country IE from being processed. This is
not critical as it will still be procesed soon after but locking prior
to it is correct.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d44f3b5..b474452 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1261,11 +1261,13 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	u32 checksum = 0;
 	enum environment_cap env = ENVIRON_ANY;
 
-	if (!last_request)
-		return;
-
 	mutex_lock(&cfg80211_mutex);
 
+	if (unlikely(!last_request)) {
+		mutex_unlock(&cfg80211_mutex);
+		return;
+	}
+
 	/* IE len must be evenly divisible by 2 */
 	if (country_ie_len & 0x01)
 		goto out;
-- 
1.6.0.3

