Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:51823 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab3CTMW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 08:22:56 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm19so796829bkc.16
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 05:22:55 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 20:22:54 +0800
Message-ID: <CAPgLHd_Aepo=sLocJqVawRO_G7ifFLhQaYUxxF9HHXB0gcGbBA@mail.gmail.com> (sfid-20130320_132301_941396_F4F6A96A)
Subject: [PATCH -next] cfg80211: fix error return code in cfg80211_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/wireless/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index f382cae..92e3fd4 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1096,8 +1096,10 @@ static int __init cfg80211_init(void)
 		goto out_fail_reg;
 
 	cfg80211_wq = create_singlethread_workqueue("cfg80211");
-	if (!cfg80211_wq)
+	if (!cfg80211_wq) {
+		err = -ENOMEM;
 		goto out_fail_wq;
+	}
 
 	return 0;
 

