Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13966 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1A3NhQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 08:37:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 05:36:56 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [RFC] mac80211: disable ps if an AP type vif is present
Date: Sun, 30 Jan 2011 19:06:11 +0530
Message-ID: <1296394571-3317-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PS should be disabled for AP type. So while recalculating
PS, AP vif type should be taken into account.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/mac80211/mlme.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3221069..1fd6023 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -601,6 +601,12 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
 			continue;
+		if (((sdata->vif.type == NL80211_IFTYPE_AP) ||
+		     (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) &&
+		    !sdata->vif.p2p) {
+			count = 0;
+			break;
+		}
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
 			continue;
 		found = sdata;
-- 
1.7.3.5

