Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:64397 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759625Ab3KMSNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:13:10 -0500
Received: by mail-we0-f169.google.com with SMTP id q58so813679wes.14
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 10:13:09 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 3/5] cfg80211: add regulatory quiescing support
Date: Wed, 13 Nov 2013 19:12:57 +0100
Message-Id: <1384366379-25301-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_191316_324340_9D57488A)
In-Reply-To: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This quiesces devices when appropriate to ensure that
regulatory domain updates take effect and avoid having
devices initiate radiation when they should not.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e5935c2..3036093 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1287,12 +1287,65 @@ static void reg_call_notifier(struct wiphy *wiphy,
 		wiphy->reg_notifier(wiphy, request);
 }
 
+static void wiphy_regulatory_quiesce_all(struct wiphy *wiphy)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = wiphy_to_dev(wiphy);
+	if (!rdev)
+		return;
+
+	cfg80211_leave_all(rdev);
+}
+
+static void wiphy_regulatory_quiesce_skip_wdev(struct wiphy *wiphy,
+					       struct regulatory_request *lr)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wiphy *last_wiphy = NULL;
+	struct wireless_dev *wdev;
+
+	rdev = wiphy_to_dev(wiphy);
+	if (!rdev)
+		return;
+
+	last_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
+	if (last_wiphy != wiphy) {
+		cfg80211_leave_all(rdev);
+		return;
+	}
+
+	list_for_each_entry(wdev, &rdev->wdev_list, list)
+		if (lr->wdev != wdev)
+			cfg80211_leave(rdev, wdev);
+}
+
+static void wiphy_regulatory_quiesce(struct wiphy *wiphy,
+				     struct regulatory_request *lr)
+{
+	switch (lr->initiator) {
+	case NL80211_REGDOM_SET_BY_CORE:
+		return;
+	case NL80211_REGDOM_SET_BY_USER:
+		wiphy_regulatory_quiesce_all(wiphy);
+		return;
+	case NL80211_REGDOM_SET_BY_DRIVER:
+		wiphy_regulatory_quiesce_all(wiphy);
+		return;
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		wiphy_regulatory_quiesce_skip_wdev(wiphy, lr);
+		return;
+	}
+}
+
 static void wiphy_update_regulatory(struct wiphy *wiphy,
 				    enum nl80211_reg_initiator initiator)
 {
 	enum ieee80211_band band;
 	struct regulatory_request *lr = get_last_request();
 
+	wiphy_regulatory_quiesce(wiphy, lr);
+
 	if (ignore_reg_update(wiphy, initiator)) {
 		/*
 		 * Regulatory updates set by CORE are ignored for custom
-- 
1.8.4.rc3

