Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946007Ab2LFQsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:48:05 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 14/24] regulatory: remove useless warning
Date: Thu,  6 Dec 2012 17:47:38 +0100
Message-Id: <1354812468-15709-15-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174855_761076_00E6999A)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
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
index de3cf71..fe8a13f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2323,10 +2323,6 @@ int __init regulatory_init(void)
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

