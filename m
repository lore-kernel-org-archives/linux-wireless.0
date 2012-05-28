Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62995 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab2E1LTh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 07:19:37 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 04/14] cfg80211: .stop_ap when interface is going down
Date: Mon, 28 May 2012 13:18:52 +0200
Message-ID: <1338203942-5667-5-git-send-email-michal.kazior@tieto.com> (sfid-20120528_132027_316187_E107C916)
In-Reply-To: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We'll need this for proper channel tracking (which
is going to be needed for channel context
accounting and finding matching/active interface
combination).

Change-Id: I7fc8eac0989ced8a81048f299a9c311e0692f850
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/core.c |    3 +++
 net/wireless/util.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index a87d435..46a33ea 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -869,6 +869,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		case NL80211_IFTYPE_MESH_POINT:
 			cfg80211_leave_mesh(rdev, dev);
 			break;
+		case NL80211_IFTYPE_AP:
+			cfg80211_stop_ap(rdev, dev);
+			break;
 		default:
 			break;
 		}
diff --git a/net/wireless/util.c b/net/wireless/util.c
index eb7ca3c..252ba8d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -815,6 +815,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		dev->ieee80211_ptr->mesh_id_up_len = 0;
 
 		switch (otype) {
+		case NL80211_IFTYPE_AP:
+			cfg80211_stop_ap(rdev, dev);
+			break;
 		case NL80211_IFTYPE_ADHOC:
 			cfg80211_leave_ibss(rdev, dev, false);
 			break;
-- 
1.7.0.4

