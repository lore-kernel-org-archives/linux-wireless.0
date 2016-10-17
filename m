Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36107 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753816AbcJQPZf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 11:25:35 -0400
Received: by mail-pf0-f194.google.com with SMTP id r16so12986306pfg.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2016 08:25:35 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH -next] cfg80211: fix possible memory leak in cfg80211_iter_combinations()
Date: Mon, 17 Oct 2016 15:25:16 +0000
Message-Id: <1476717916-23302-1-git-send-email-weiyj.lk@gmail.com> (sfid-20161017_172539_300706_364E701C)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

'limits' is malloced in cfg80211_iter_combinations() and should be freed
before leaving from the error handling cases, otherwise it will cause
memory leak.

Fixes: 0c317a02ca98 ("cfg80211: support virtual interfaces with different
beacon intervals")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/wireless/util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index dd545ff..e36dbae 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1672,8 +1672,10 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 
 		if (params->beacon_int_gcd) {
 			if (c->beacon_int_min_gcd &&
-			    params->beacon_int_gcd < c->beacon_int_min_gcd)
+			    params->beacon_int_gcd < c->beacon_int_min_gcd) {
+				kfree(limits);
 				return -EINVAL;
+			}
 			if (!c->beacon_int_min_gcd &&
 			    params->beacon_int_different)
 				goto cont;
