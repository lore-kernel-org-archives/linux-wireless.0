Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21259 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab1AaS7u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:59:50 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 10:59:30 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH v2] mac80211: disable power save if an infra AP vif exists
Date: Tue, 1 Feb 2011 00:28:59 +0530
Message-ID: <1296500339-4252-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PS should not be enabled if an infra AP vif exists in
the interface list. So while recalculating PS,
AP vif type should be taken into account.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/mac80211/mlme.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3221069..dfa752e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -601,6 +601,14 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
 			continue;
+		if (sdata->vif.type == NL80211_IFTYPE_AP) {
+			/* If an AP vif is found, then disable PS
+			 * by setting the count to zero thereby setting
+			 * ps_sdata to NULL.
+			 */
+			count = 0;
+			break;
+		}
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
 			continue;
 		found = sdata;
-- 
1.7.3.5

