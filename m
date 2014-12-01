Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58061 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbaLAPsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 10:48:55 -0500
Received: by mail-wi0-f178.google.com with SMTP id hi2so17810458wib.5
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 07:48:54 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v6 4/4] cfg80211: correctly check ad-hoc channels
Date: Mon,  1 Dec 2014 17:48:47 +0200
Message-Id: <1417448927-9337-4-git-send-email-arik@wizery.com> (sfid-20141201_164859_011286_55B72C0C)
In-Reply-To: <1417448927-9337-1-git-send-email-arik@wizery.com>
References: <1417448927-9337-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ad-hoc requires beaconing for regulatory purposes. Validate that the
channel is valid for beaconing, and not only enabled.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
Ilan Peer mentioned this bug privately, so I thought I'd roll it up into
this patch-set

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

