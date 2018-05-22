Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:39476 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbeEVAVw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 20:21:52 -0400
Received: by mail-ot0-f193.google.com with SMTP id l12-v6so18916408oth.6
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2018 17:21:52 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: johannes@sipsolutions.net, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH] nl80211: Fix compilation
Date: Mon, 21 May 2018 19:21:42 -0500
Message-Id: <20180522002142.26149-1-denkenz@gmail.com> (sfid-20180522_022156_146393_E44B7BAC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 7ea3e110f2f8ba23f330c2f702f556acd539bcb8 seems to have
introduced:

net/wireless/nl80211.c: In function ‘nl80211_get_station’:
net/wireless/nl80211.c:4802:34: error: incompatible type for argument 1 of ‘cfg80211_sinfo_release_content’
   cfg80211_sinfo_release_content(sinfo);
                                  ^~~~~
In file included from net/wireless/nl80211.c:24:0:
./include/net/cfg80211.h:5721:20: note: expected ‘struct station_info *’ but argument is of type ‘struct station_info’
 static inline void cfg80211_sinfo_release_content(struct station_info *sinfo)
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fd2b1646e81a..376cb66d164c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4799,7 +4799,7 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg) {
-		cfg80211_sinfo_release_content(sinfo);
+		cfg80211_sinfo_release_content(&sinfo);
 		return -ENOMEM;
 	}
 
-- 
2.13.5
