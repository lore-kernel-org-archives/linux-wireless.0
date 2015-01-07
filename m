Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:63581 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbAGOrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 09:47:25 -0500
Received: by mail-we0-f170.google.com with SMTP id w61so1292886wes.29
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 06:47:24 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 2/2] cfg80211: avoid reg-hints in self-managed only systems
Date: Wed,  7 Jan 2015 16:47:20 +0200
Message-Id: <1420642040-4530-2-git-send-email-arik@wizery.com> (sfid-20150107_154729_209737_F020E345)
In-Reply-To: <1420642040-4530-1-git-send-email-arik@wizery.com>
References: <1420642040-4530-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a system contains only self-managed regulatory devices all hints
from the regulatory core are ignored. Stop hint processing early in this
case. These systems usually don't have CRDA deployed, which results in
endless (irrelevent) logs of the form:
cfg80211: Calling CRDA to update world regulatory domain

Make sure there's at least one self-managed device before discarding a
hint, in order to prevent initial hints from disappearing on CRDA
managed systems.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 net/wireless/reg.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 521f3a4..588e45f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2120,6 +2120,26 @@ out_free:
 	reg_free_request(reg_request);
 }
 
+static bool reg_only_self_managed_wiphys(void)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wiphy *wiphy;
+	bool self_managed_found = false;
+
+	ASSERT_RTNL();
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		wiphy = &rdev->wiphy;
+		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+			self_managed_found = true;
+		else
+			return false;
+	}
+
+	/* make sure at least one self-managed wiphy exists */
+	return self_managed_found;
+}
+
 /*
  * Processes regulatory hints, this is all the NL80211_REGDOM_SET_BY_*
  * Regulatory hints come on a first come first serve basis and we
@@ -2151,6 +2171,11 @@ static void reg_process_pending_hints(void)
 
 	spin_unlock(&reg_requests_lock);
 
+	if (reg_only_self_managed_wiphys()) {
+		reg_free_request(reg_request);
+		return;
+	}
+
 	reg_process_hint(reg_request);
 }
 
-- 
2.1.0

