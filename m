Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60385 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbZCUDxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 23:53:12 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Quentin@armitage.org.uk,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH 2/5] cfg80211: fix incorrect assumption on last_request for 11d
Date: Fri, 20 Mar 2009 23:53:05 -0400
Message-Id: <1237607588-6316-3-git-send-email-lrodriguez@atheros.com> (sfid-20090321_045325_125679_2AAAAF92)
In-Reply-To: <1237607588-6316-1-git-send-email-lrodriguez@atheros.com>
References: <1237607588-6316-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The incorrect assumption is the last regulatory request
(last_request) is always a country IE when processing
country IEs. Although this is true 99% of the time the
first time this happens this could not be true.

This fixes an oops in the branch check for the last_request
when accessing drv_last_ie. The access was done under the
assumption the struct won't be null.

Note to stable: to port to 29 replace as follows, only 29 has
country IE code:

s|NL80211_REGDOM_SET_BY_COUNTRY_IE|REGDOM_SET_BY_COUNTRY_IE

Cc: stable@kernel.org
Reported-by: Quentin Armitage <Quentin@armitage.org.uk>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ead9dcc..9afc916 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1601,6 +1601,10 @@ static bool reg_same_country_ie_hint(struct wiphy *wiphy,
 
 	assert_cfg80211_lock();
 
+	if (unlikely(last_request->initiator !=
+	    NL80211_REGDOM_SET_BY_COUNTRY_IE))
+		return false;
+
 	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
 
 	if (!request_wiphy)
@@ -1663,7 +1667,9 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	 * we optimize an early check to exit out early if we don't have to
 	 * do anything
 	 */
-	if (likely(wiphy_idx_valid(last_request->wiphy_idx))) {
+	if (likely(last_request->initiator ==
+	    NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	    wiphy_idx_valid(last_request->wiphy_idx))) {
 		struct cfg80211_registered_device *drv_last_ie;
 
 		drv_last_ie =
-- 
1.6.0.6

