Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18930 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab1AaSqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:46:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 10:45:47 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] mac80211: disable power save if an infra AP vif exists
Date: Tue, 1 Feb 2011 00:15:18 +0530
Message-ID: <1296499518-3895-1-git-send-email-rmanoharan@atheros.com>
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
 net/mac80211/mlme.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3221069..82e6b89 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -601,6 +601,15 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
 			continue;
+		if ((sdata->vif.type == NL80211_IFTYPE_AP) ||
+		    (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
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

