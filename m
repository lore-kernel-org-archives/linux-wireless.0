Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35275 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934630AbcKXBZ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 20:25:57 -0500
Received: by mail-pg0-f65.google.com with SMTP id p66so2206576pga.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2016 17:25:57 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Wed, 23 Nov 2016 17:25:50 -0800
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 4/7] mwifiex: Remove unused 'adapter'variable
Message-ID: <776792b748b49db285a739a26f585539726076e0.1479950323.git.kirtika@google.com> (sfid-20161124_022600_485427_59435EC4)
References: <cover.1479950323.git.kirtika@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479950323.git.kirtika@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 3935ccc14d2c introduced mwifiex_tm_cmd() which initializes
struct mwifiex_adapter* adapter, but doesn't use it.
Compiling with W=1 gives the following warning, fix it.
mwifiex/cfg80211.c: In function ‘mwifiex_tm_cmd’:
mwifiex/cfg80211.c:3973:26: warning: variable ‘adapter’ set but not used [-Wunused-but-set-variable]

Fixes: 3935ccc14d2c ("mwifiex: add cfg80211 testmode support")
Cc: Xinming Hu <huxm@marvell.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index c26469a..a231f09 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3980,13 +3980,11 @@ static int mwifiex_tm_cmd(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
 	struct mwifiex_ds_misc_cmd *hostcmd;
 	struct nlattr *tb[MWIFIEX_TM_ATTR_MAX + 1];
-	struct mwifiex_adapter *adapter;
 	struct sk_buff *skb;
 	int err;
 
 	if (!priv)
 		return -EINVAL;
-	adapter = priv->adapter;
 
 	err = nla_parse(tb, MWIFIEX_TM_ATTR_MAX, data, len,
 			mwifiex_tm_policy);
-- 
2.8.0.rc3.226.g39d4020
