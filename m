Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:40816 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752510AbeC3CBm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 22:01:42 -0400
From: Wei Yongjun <weiyongjun1@huawei.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] cfg80211: fix possible memory leak in regdb_query_country()
Date: Fri, 30 Mar 2018 02:07:05 +0000
Message-ID: <1522375625-135679-1-git-send-email-weiyongjun1@huawei.com> (sfid-20180330_040147_303459_82E6DBD4)
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'wmm_ptrs' is malloced in regdb_query_country() and should be freed
before leaving from the error handling cases, otherwise it will cause
memory leak.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/wireless/reg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 16c7e4e..ac3e12c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1026,6 +1026,7 @@ static int regdb_query_country(const struct fwdb_header *db,
 
 			if (!tmp_rd) {
 				kfree(regdom);
+				kfree(wmm_ptrs);
 				return -ENOMEM;
 			}
 			regdom = tmp_rd;
