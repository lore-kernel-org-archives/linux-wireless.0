Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44591 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2LDOt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:49:26 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 12/18] regulatory: remove useless warning
Date: Tue,  4 Dec 2012 15:48:54 +0100
Message-Id: <1354632540-21207-13-git-send-email-johannes@sipsolutions.net> (sfid-20121204_154931_324843_3852A16E)
In-Reply-To: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
References: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even if it never happens and is hidden behind the
debug config option, it's completely useless: the
calltrace will only show module loading.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 26eff64..999b379 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2331,10 +2331,6 @@ int __init regulatory_init(void)
 		 * errors as non-fatal.
 		 */
 		pr_err("kobject_uevent_env() was unable to call CRDA during init\n");
-#ifdef CONFIG_CFG80211_REG_DEBUG
-		/* We want to find out exactly why when debugging */
-		WARN_ON(err);
-#endif
 	}
 
 	/*
-- 
1.8.0

