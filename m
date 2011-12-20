Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59073 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1LTUXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 15:23:53 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Petri Karhula <petri.karhula@nokia.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 1/3] cfg80211: replace reg.c Nokia commit c4c32294
Date: Tue, 20 Dec 2011 12:23:36 -0800
Message-ID: <1324412618-25131-2-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_212359_514728_7E632935)
In-Reply-To: <1324412618-25131-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324412618-25131-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Nokia hasn't gotten back to me in over 1 month for a relicense
change request. There are only a few changes that they contributed,
so just reverting their changes but replacing with another set.
This change replaces this commit:

commit c4c322941ce0d7e2b7b8794ad70683123d9cb26a
Author: Yuri Ershov <ext-yuri.ershov@nokia.com>
Date:   Tue Jun 29 15:08:08 2010 +0400

    cfg80211: Update of regulatory request initiator handling

    In some cases there could be possible dereferencing freed pointer. The
    update is intended to avoid this issue.

    Signed-off-by: Yuri Ershov <ext-yuri.ershov@nokia.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Cc: Petri Karhula <petri.karhula@nokia.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/wireless/reg.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c45c8b7..a7d252e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1480,18 +1480,18 @@ new_request:
 }
 
 /* This processes *all* regulatory hints */
-static void reg_process_hint(struct regulatory_request *reg_request)
+static void reg_process_hint(struct regulatory_request *reg_request,
+			     enum nl80211_reg_initiator reg_initiator)
 {
 	int r = 0;
 	struct wiphy *wiphy = NULL;
-	enum nl80211_reg_initiator initiator = reg_request->initiator;
 
 	BUG_ON(!reg_request->alpha2);
 
 	if (wiphy_idx_valid(reg_request->wiphy_idx))
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
-	if (reg_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
+	if (reg_initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    !wiphy) {
 		kfree(reg_request);
 		return;
@@ -1501,7 +1501,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	/* This is required so that the orig_* parameters are saved */
 	if (r == -EALREADY && wiphy &&
 	    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
-		wiphy_update_regulatory(wiphy, initiator);
+		wiphy_update_regulatory(wiphy, reg_initiator);
 		return;
 	}
 
@@ -1510,7 +1510,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	 * source of bogus requests.
 	 */
 	if (r != -EALREADY &&
-	    reg_request->initiator == NL80211_REGDOM_SET_BY_USER)
+	    reg_initiator == NL80211_REGDOM_SET_BY_USER)
 		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
 }
 
@@ -1547,7 +1547,7 @@ static void reg_process_pending_hints(void)
 
 	spin_unlock(&reg_requests_lock);
 
-	reg_process_hint(reg_request);
+	reg_process_hint(reg_request, reg_request->initiator);
 
 out:
 	mutex_unlock(&reg_mutex);
-- 
1.7.4.15.g7811d

