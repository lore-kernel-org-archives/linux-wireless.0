Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44402 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750846AbdHRMeE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 08:34:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 15:33:57 +0300
Message-Id: <20170818123357.19646-3-luca@coelho.fi> (sfid-20170818_143410_433232_5390C995)
In-Reply-To: <20170818123357.19646-1-luca@coelho.fi>
References: <20170818123357.19646-1-luca@coelho.fi>
Subject: [PATCH 2/2] mac80211: flush hw_roc_start work before cancelling the ROC
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

When HW ROC is supported it is possible that after the HW notified
that the ROC has started, the ROC was cancelled and another ROC was
added while the hw_roc_start worker is waiting on the mutex (since
cancelling the ROC and adding another one also holds the same mutex).
As a result, the hw_roc_start worker will continue to run after the
new ROC is added but before it is actually started by the HW.
This may result in notifying userspace that the ROC has started before
it actually does, or in case of management tx ROC, in an attempt to
tx while not on the right channel.

In addition, when the driver will notify mac80211 that the second ROC
has started, mac80211 will warn that this ROC has already been
notified.

Fix this by flushing the hw_roc_start work before cancelling an ROC.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/offchannel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index f8e7a8bbc618..faf4f6055000 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -707,6 +707,8 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 	if (!cookie)
 		return -ENOENT;
 
+	flush_work(&local->hw_roc_start);
+
 	mutex_lock(&local->mtx);
 	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
 		if (!mgmt_tx && roc->cookie != cookie)
-- 
2.14.1
