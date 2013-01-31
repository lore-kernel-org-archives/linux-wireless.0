Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3AaNIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 08:08:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix BSS IE allocation comment
Date: Thu, 31 Jan 2013 14:09:17 +0100
Message-Id: <1359637757-31521-1-git-send-email-johannes@sipsolutions.net> (sfid-20130131_140857_707270_C337429D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The comment about allocating the IEs together with
the BSS struct is no longer true, remove it. Also
fix a typo in the same area.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d220313..cae380f 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -689,11 +689,8 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 	 * Response frame, we need to pick one of the options and only use it
 	 * with the driver that does not provide the full Beacon/Probe Response
 	 * frame. Use Beacon frame pointer to avoid indicating that this should
-	 * override the iies pointer should we have received an earlier
+	 * override the IEs pointer should we have received an earlier
 	 * indication of Probe Response data.
-	 *
-	 * The initial buffer for the IEs is allocated with the BSS entry and
-	 * is located after the private area.
 	 */
 	ies = kmalloc(sizeof(*ies) + ielen, gfp);
 	if (!ies)
-- 
1.8.0

