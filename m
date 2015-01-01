Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44718 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbbAALmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2015 06:42:49 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so22913123wgg.21
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jan 2015 03:42:47 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/2] cfg80211: avoid reg-hints in self-managed only systems
Date: Thu,  1 Jan 2015 13:42:43 +0200
Message-Id: <1420112563-3981-2-git-send-email-arik@wizery.com> (sfid-20150101_124318_467560_B1BDB092)
In-Reply-To: <1420112563-3981-1-git-send-email-arik@wizery.com>
References: <1420112563-3981-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a system contains only self-managed regulatory devices all hints
from the regulatory core are ignored. Stop hint processing early in this
case. These systems usually don't have CRDA deployed, which results in
endless (irrelevent) logs of the form:
cfg80211: Calling CRDA to update world regulatory domain

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 net/wireless/reg.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9b5662f..21b2095 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2102,6 +2102,22 @@ out_free:
 	reg_free_request(reg_request);
 }
 
+static bool reg_only_self_managed_wiphys(void)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wiphy *wiphy;
+
+	ASSERT_RTNL();
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		wiphy = &rdev->wiphy;
+		if (!(wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED))
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * Processes regulatory hints, this is all the NL80211_REGDOM_SET_BY_*
  * Regulatory hints come on a first come first serve basis and we
@@ -2133,6 +2149,11 @@ static void reg_process_pending_hints(void)
 
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

