Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:9685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbaICMcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:32:50 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/10] mac80211: adjust roc duration when combining ROCs
Date: Wed,  3 Sep 2014 15:25:05 +0300
Message-Id: <1409747106-30717-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140903_143254_257515_CD7B6B74)
In-Reply-To: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

The new duration (remaining duration after the current
ROC ends) was calculated but not used, making the
optimization worthless.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6cd0a59e..edeab09 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2503,6 +2503,7 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
 				if (new_dur > 0) {
 					/* add right after tmp */
+					roc->duration = new_dur;
 					list_add(&roc->list, &tmp->list);
 				} else {
 					list_add_tail(&roc->list,
-- 
1.9.1

