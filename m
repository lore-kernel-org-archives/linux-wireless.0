Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41959 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab2DYMpF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 08:45:05 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: Remove compile warnings
Date: Wed, 25 Apr 2012 15:45:55 +0300
Message-Id: <1335357955-28089-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120425_144514_783980_CE23A8CA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Use default key to handle similar iface types. This removes compile warnings:

net/wireless/util.c: In function ‘cfg80211_change_iface’:
net/wireless/util.c:846:3: warning: enumeration value ‘NL80211_IFTYPE_MAX’
	not handled in switch [-Wswitch]

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 net/wireless/util.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 1b7a08d..468dc8b 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -862,8 +862,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		case NL80211_IFTYPE_MONITOR:
 			/* monitor can't bridge anyway */
 			break;
-		case NL80211_IFTYPE_UNSPECIFIED:
-		case NUM_NL80211_IFTYPES:
+		default:
 			/* not happening */
 			break;
 		}
-- 
1.7.9.5

