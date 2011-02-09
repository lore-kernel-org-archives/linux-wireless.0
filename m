Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27507 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab1BIMRB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 07:17:01 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 04:16:41 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 1/2] mac80211: add monitor interface into PS disable list
Date: Wed, 9 Feb 2011 17:46:38 +0530
Message-ID: <1297253799-9688-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PS should be disabled in the presence of monitor interface.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/mac80211/mlme.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f77adf1..8fc6d35 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -630,13 +630,13 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
 			continue;
-		if (sdata->vif.type == NL80211_IFTYPE_AP) {
-			/* If an AP vif is found, then disable PS
-			 * by setting the count to zero thereby setting
-			 * ps_sdata to NULL.
+		if ((sdata->vif.type == NL80211_IFTYPE_AP) ||
+		    (sdata->vif.type == NL80211_IFTYPE_MONITOR)) {
+			/* If an AP/monitor vif is found, then disable PS
+			 * by setting ps_sdata to NULL.
 			 */
-			count = 0;
-			break;
+			local->ps_sdata = NULL;
+			goto change;
 		}
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
 			continue;
-- 
1.7.4

