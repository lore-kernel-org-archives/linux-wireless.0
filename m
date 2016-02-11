Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:33642 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbcBKACL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 19:02:11 -0500
Received: by mail-wm0-f42.google.com with SMTP id g62so930461wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 16:02:11 -0800 (PST)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] nl80211: Zero out the connection keys memory when freeing them.
Date: Thu, 11 Feb 2016 01:00:22 +0100
Message-Id: <1455148822-13849-1-git-send-email-ola1olsson@gmail.com> (sfid-20160211_010301_984531_86D251C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The connection keys are zeroed out in all other cases except this
one. Let's fix the last one as well.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 net/wireless/nl80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 72de698..c1ef6ce 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7547,7 +7547,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 
 		if ((ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT) &&
 		    no_ht) {
-			kfree(connkeys);
+			kzfree(connkeys);
 			return -EINVAL;
 		}
 	}
-- 
1.7.9.5

