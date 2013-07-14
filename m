Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3GNU5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jul 2013 16:57:32 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: make active monitor injection work w/ HW queue
Date: Sun, 14 Jul 2013 23:57:22 +0300
Message-Id: <1373835442-3322-4-git-send-email-johannes@sipsolutions.net> (sfid-20130714_225741_080795_4A2BE9F0)
In-Reply-To: <1373835442-3322-1-git-send-email-johannes@sipsolutions.net>
References: <1373835442-3322-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a driver (like hwsim) uses HW queue control an
active monitor vif needs to be used for the queues,
make the code do that. Otherwise we'd bail out and
drop the frames.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f82301b..be4d3ca 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1272,6 +1272,10 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_MONITOR:
+		if (sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE) {
+			vif = &sdata->vif;
+			break;
+		}
 		sdata = rcu_dereference(local->monitor_sdata);
 		if (sdata) {
 			vif = &sdata->vif;
-- 
1.8.0

