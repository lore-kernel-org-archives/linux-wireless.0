Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34914 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbaLCQIW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 11:08:22 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so31926177wiv.6
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2014 08:08:21 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v8 4/4] cfg80211: correctly check ad-hoc channels
Date: Wed,  3 Dec 2014 18:08:17 +0200
Message-Id: <1417622897-30768-4-git-send-email-arik@wizery.com> (sfid-20141203_171633_580257_1F4B194C)
In-Reply-To: <1417622897-30768-1-git-send-email-arik@wizery.com>
References: <1417622897-30768-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ad-hoc requires beaconing for regulatory purposes. Validate that the
channel is valid for beaconing, and not only enabled.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 net/wireless/reg.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c3e6f80..004ea14 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1552,9 +1552,15 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 		ret = cfg80211_reg_can_beacon(wiphy,
 					      &wdev->chandef, wdev->iftype);
 		break;
+	case NL80211_IFTYPE_ADHOC:
+		if (!wdev->ssid_len)
+			goto out;
+
+		ret = cfg80211_reg_can_beacon(wiphy,
+					      &wdev->chandef, wdev->iftype);
+		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
-	case NL80211_IFTYPE_ADHOC:
 		if (!wdev->current_bss ||
 		    !wdev->current_bss->pub.channel)
 			goto out;
-- 
1.9.1

