Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.50.73]:36508 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbeIDSHu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 14:07:50 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 6C0624BBF3
        for <linux-wireless@vger.kernel.org>; Tue,  4 Sep 2018 08:20:38 -0500 (CDT)
Date: Tue, 4 Sep 2018 08:20:01 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Alexander Wetzel <alexander@wetzel-home.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] mac80211: remove unnecessary NULL check
Message-ID: <20180904132001.GA31932@embeddedor.com> (sfid-20180904_154243_077061_D8AAD236)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both old and new cannot be NULL at the same time, hence checking
new when old is not NULL is unnecessary.

Also, notice that new is being dereferenced before it is checked:
	
	idx = new->conf.keyidx;

The above triggers a static code analysis warning.

Address this by removing the NULL check on new and adding a code
comment based on the following piece of code:

387        /* caller must provide at least one old/new */
388        if (WARN_ON(!new && !old))
389                return 0;

Addresses-Coverity-ID: 1473176 ("Dereference before null check")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/mac80211/key.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d6eeace..4700718 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -401,8 +401,9 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		 * pairwise keys.*/
 		ret = ieee80211_hw_key_replace(old, new, pairwise);
 	} else {
+		/* new must be provided in case old is not */
 		idx = new->conf.keyidx;
-		if (new && !new->local->wowlan)
+		if (!new->local->wowlan)
 			ret = ieee80211_key_enable_hw_accel(new);
 		else
 			ret = 0;
-- 
2.7.4
