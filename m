Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2FMILJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 04:11:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SeifU-0000HH-7z
	for linux-wireless@vger.kernel.org; Wed, 13 Jun 2012 10:11:08 +0200
Message-ID: <1339575067.4519.10.camel@jlt3.sipsolutions.net> (sfid-20120613_101118_731216_374BE2F6)
Subject: [PATCH] mac80211: allow cancelling dependent ROCs
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 13 Jun 2012 10:11:07 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In my redesign of remain-on-channel I forgot
that an item could be cancelled when it's a
dependent item that is part of another item.
Allow cancelling such items by removing them
from the dependents list.

Note that when we cancel the main item, all
its dependents are also cancelled. It would
be possible to not do that, but would need
tricks to promote an item from dependent to
top-level and is tricky in the HW ROC case.

Reported-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Will apply to mac80211-next soon.

 net/mac80211/cfg.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 498c94e..2ba4b50 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2306,6 +2306,21 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 
 	mutex_lock(&local->mtx);
 	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
+		struct ieee80211_roc_work *dep, *tmp2;
+
+		list_for_each_entry_safe(dep, tmp2, &roc->dependents, list) {
+			if (!mgmt_tx && (unsigned long)dep != cookie)
+				continue;
+			else if (mgmt_tx && dep->mgmt_tx_cookie != cookie)
+				continue;
+			/* found dependent item -- just remove it */
+			list_del(&dep->list);
+			mutex_unlock(&local->mtx);
+
+			ieee80211_roc_notify_destroy(dep);
+			return 0;
+		}
+
 		if (!mgmt_tx && (unsigned long)roc != cookie)
 			continue;
 		else if (mgmt_tx && roc->mgmt_tx_cookie != cookie)
@@ -2320,6 +2335,13 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 		return -ENOENT;
 	}
 
+	/*
+	 * We found the item to cancel, so do that. Note that it
+	 * may have dependents, which we also cancel (and send
+	 * the expired signal for.) Not doing so would be quite
+	 * tricky here, but we may need to fix it later.
+	 */
+
 	if (local->ops->remain_on_channel) {
 		if (found->started) {
 			ret = drv_cancel_remain_on_channel(local);
-- 
1.7.10



