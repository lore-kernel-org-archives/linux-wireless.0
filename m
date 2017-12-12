Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:56670 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbdLLJ0J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 04:26:09 -0500
From: Jia-Ju Bai <baijiaju1990@163.com>
To: johannes@sipsolutions.net, kvalo@codeaurora.org, j@w1.fi,
        jlopex@gmail.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] mac80211_hwsim: Fix a possible sleep-in-atomic bug in hwsim_get_radio_nl
Date: Tue, 12 Dec 2017 17:26:36 +0800
Message-Id: <1513070796-24283-1-git-send-email-baijiaju1990@163.com> (sfid-20171212_102619_298152_B34AC96B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver may sleep under a spinlock.
The function call path is:
hwsim_get_radio_nl (acquire the spinlock)
  nlmsg_new(GFP_KERNEL) --> may sleep

To fix it, GFP_KERNEL is replaced with GFP_ATOMIC.

This bug is found by my static analysis tool(DSAC) and checked by my code review.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 10b075a..f2ebf4a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3215,7 +3215,7 @@ static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		if (!net_eq(wiphy_net(data->hw->wiphy), genl_info_net(info)))
 			continue;
 
-		skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+		skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 		if (!skb) {
 			res = -ENOMEM;
 			goto out_err;
-- 
1.7.9.5
