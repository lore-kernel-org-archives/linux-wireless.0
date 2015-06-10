Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22860 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbbFJRT7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 13:19:59 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: clear local->in_reconfig on reconfig error
Date: Wed, 10 Jun 2015 20:19:37 +0300
Message-Id: <1433956777-23072-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150610_192002_716314_CAAA79DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

If reconfiguration fails, local->in_reconfig is never
cleaned, resulting in rx frames being dropped next
time the device is started.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 28858b4..f425754 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1714,6 +1714,7 @@ static void ieee80211_handle_reconfig_failure(struct ieee80211_local *local)
 	local->resuming = false;
 	local->suspended = false;
 	local->started = false;
+	local->in_reconfig = false;
 
 	/* scheduled scan clearly can't be running any more, but tell
 	 * cfg80211 and clear local state
-- 
2.1.4

