Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:45917 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3JCBdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 21:33:16 -0400
Received: by mail-oa0-f44.google.com with SMTP id l10so1684543oag.17
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 18:33:16 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com
Subject: [PATCH 1/2] cfg80211: enable regulatory hints for strict custom settings
Date: Wed,  2 Oct 2013 18:33:09 -0700
Message-Id: <1380763990-5981-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131003_033320_027640_D4BF8776)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we have a wiphy with an ISO3166-alpha2 regulatory domain
programmed with the strict flag set we wait until the wiphy
gets its wiphy->regd programmed before allowing regulatory
domains hints other than country IE hints from processing
on the wiphy. The existing check however discards the
possibility of custom regulatory domains having also used
the strict flag and these will not have the wiphy->regd
set. Custom strict regulatory domains never set the wiphy->regd
though as such currently all regulatory hints other than
country IE hints are being ignored on these wiphys.

All custom strict regulatory domains set the wiphy with the
WIPHY_FLAG_CUSTOM_REGULATORY and use wiphy_apply_custom_regulatory().
Enhance the check for the strict ISO3166-alpha2 regulatory domain
case by exempting the WIPHY_FLAG_CUSTOM_REGULATORY case. This
will enable other regulatory hints to be processed now for
these strict custom regulatory domains.

Cc: smihir@qti.qualcomm.com
Cc: tushnimb@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5164716..9b488c7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -992,6 +992,7 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	 */
 	if (wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY && !wiphy->regd &&
 	    initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	    !(wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) &&
 	    !is_world_regdom(lr->alpha2)) {
 		REG_DBG_PRINT("Ignoring regulatory request set by %s "
 			      "since the driver requires its own regulatory "
-- 
1.8.4.rc3

