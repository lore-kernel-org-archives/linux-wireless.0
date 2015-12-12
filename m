Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38603 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbbLLWRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2015 17:17:24 -0500
Received: by wmpp66 with SMTP id p66so16419456wmp.1
        for <linux-wireless@vger.kernel.org>; Sat, 12 Dec 2015 14:17:23 -0800 (PST)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] nl80211: Fix potential memory leak in nl80211_set_wowlan
Date: Sat, 12 Dec 2015 23:17:17 +0100
Message-Id: <1449958637-2766-1-git-send-email-ola1olsson@gmail.com> (sfid-20151212_231733_718653_E3BE5FF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Compared to cfg80211_rdev_free_wowlan in core.h,
the error goto label lacks the freeing of nd_config.
Fix that.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 net/wireless/nl80211.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4b5ff71..75b0d23 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9505,6 +9505,7 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 	if (new_triggers.tcp && new_triggers.tcp->sock)
 		sock_release(new_triggers.tcp->sock);
 	kfree(new_triggers.tcp);
+	kfree(new_triggers.nd_config);
 	return err;
 }
 #endif
-- 
1.7.9.5

