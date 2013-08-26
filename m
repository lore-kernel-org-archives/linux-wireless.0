Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:41226 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3HZHc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 03:32:59 -0400
Received: by mail-bk0-f42.google.com with SMTP id my10so961536bkb.15
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 00:32:58 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 26 Aug 2013 15:32:58 +0800
Message-ID: <CAPgLHd-GQuhYuKXBj6FVjtpGYWZYVwuGR-Sj3w19JSMcTm1JLg@mail.gmail.com> (sfid-20130826_093303_664307_FE807DDA)
Subject: [PATCH] mac80211_hwsim: fix error return code in init_mac80211_hwsim()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the netdev alloc error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index cb34c78..9e0ebee 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2525,8 +2525,10 @@ static int __init init_mac80211_hwsim(void)
 	}
 
 	hwsim_mon = alloc_netdev(0, "hwsim%d", hwsim_mon_setup);
-	if (hwsim_mon == NULL)
+	if (hwsim_mon == NULL) {
+		err = -ENOMEM;
 		goto failed;
+	}
 
 	rtnl_lock();
 

