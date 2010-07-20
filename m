Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49441 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab0GTTaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 15:30:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: remove unnecessary reg_same_country_ie_hint
Date: Tue, 20 Jul 2010 15:15:33 -0400
Message-Id: <1279653333-13489-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <AANLkTinPnjtbDM8AE7gKMA9lBnIJDqG-KXc04ynZ6wLg@mail.gmail.com>
References: <AANLkTinPnjtbDM8AE7gKMA9lBnIJDqG-KXc04ynZ6wLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Might as well remove  reg_same_country_ie_hint() completely since we
already dealt with suspend/resume through the regulatory hint
disconnect." -- Luis

Reported-by: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/reg.c |   45 ---------------------------------------------
 1 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 678d0bd..48baf28 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1483,39 +1483,6 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 }
 EXPORT_SYMBOL(regulatory_hint);
 
-/* Caller must hold reg_mutex */
-static bool reg_same_country_ie_hint(struct wiphy *wiphy,
-			char *alpha2, enum environment_cap env)
-{
-	struct wiphy *request_wiphy;
-
-	assert_reg_lock();
-
-	if (unlikely(last_request->initiator !=
-	    NL80211_REGDOM_SET_BY_COUNTRY_IE))
-		return false;
-
-	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
-
-	if (!request_wiphy)
-		return false;
-
-	if (likely(request_wiphy != wiphy))
-		return (last_request->alpha2[0] == alpha2[0] &&
-			last_request->alpha2[1] == alpha2[1] &&
-			last_request->country_ie_env == env);
-	/*
-	 * We should not have let these through at this point, they
-	 * should have been picked up earlier by the first alpha2 check
-	 * on the device
-	 */
-	if (WARN_ON((last_request->alpha2[0] == alpha2[0] &&
-			last_request->alpha2[1] == alpha2[1] &&
-			last_request->country_ie_env == env )))
-		return true;
-	return false;
-}
-
 /*
  * We hold wdev_lock() here so we cannot hold cfg80211_mutex() and
  * therefore cannot iterate over the rdev list here.
@@ -1560,18 +1527,6 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	    wiphy_idx_valid(last_request->wiphy_idx)))
 		goto out;
 
-	/*
-	 * This will not happen right now but we leave it here for the
-	 * the future when we want to add suspend/resume support and having
-	 * the user move to another country after doing so, or having the user
-	 * move to another AP. Right now we just trust the first AP.
-	 *
-	 * If we hit this before we add this support we want to be informed of
-	 * it as it would indicate a mistake in the current design
-	 */
-	if (WARN_ON(reg_same_country_ie_hint(wiphy, alpha2, env)))
-		goto free_rd_out;
-
 	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
 	if (!request)
 		goto free_rd_out;
-- 
1.7.1.1

