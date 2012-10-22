Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2JVNWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 09:22:53 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix WDS channel context test
Date: Mon, 22 Oct 2012 15:23:24 +0200
Message-Id: <1350912204-31722-1-git-send-email-johannes@sipsolutions.net> (sfid-20121022_152256_780761_E7E6B293)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

WDS is (currently) not allowed when channel
contexts are *supported*, not when they're
*not* supported. Fix the inverted test.

Reported-by: Ronald <ronald645@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c42094b..fd8345c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -751,7 +751,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			if (comb->num_different_channels > 1)
 				return -EINVAL;
 		}
-
+	} else {
 		/*
 		 * WDS is currently prohibited when channel contexts are used
 		 * because there's no clear definition of which channel WDS
-- 
1.7.10.4

