Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:32868 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932221AbcI2O6H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Sep 2016 10:58:07 -0400
Received: by mail-pa0-f65.google.com with SMTP id oz2so3552719pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2016 07:58:07 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH -next] mwifiex: fix missing destroy_workqueue() on error in mwifiex_add_virtual_intf()
Date: Thu, 29 Sep 2016 14:57:56 +0000
Message-Id: <1475161076-1409-1-git-send-email-weiyj.lk@gmail.com> (sfid-20160929_165811_800235_9D0C0DEF)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Add the missing destroy_workqueue() before return from
mwifiex_add_virtual_intf() in the error handling case.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 39ce76a..5fd5876 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3016,6 +3016,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->netdev = NULL;
 		memset(&priv->wdev, 0, sizeof(priv->wdev));
 		priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+		destroy_workqueue(priv->dfs_cac_workqueue);
+		priv->dfs_cac_workqueue = NULL;
 		return ERR_PTR(-ENOMEM);
 	}
 
