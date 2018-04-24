Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:7192 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932778AbeDXDKR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 23:10:17 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <johannes@sipsolutions.net>
CC: <netdev@vger.kernel.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] mac80211_hwsim: fix a possible memory leak in hwsim_new_radio_nl()
Date: Tue, 24 Apr 2018 11:08:35 +0800
Message-ID: <20180424030835.21776-1-yuehaibing@huawei.com> (sfid-20180424_051022_157130_EA3869E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'hwname' should be freed before leaving from the error handling cases,
otherwise it will cause mem leak

Fixes: cb1a5bae5684 ("mac80211_hwsim: add permanent mac address option for new radios")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 96d26cf..4a017a0 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3236,6 +3236,7 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			GENL_SET_ERR_MSG(info,"MAC is no valid source addr");
 			NL_SET_BAD_ATTR(info->extack,
 					info->attrs[HWSIM_ATTR_PERM_ADDR]);
+			kfree(hwname);
 			return -EINVAL;
 		}
 
-- 
2.7.0
