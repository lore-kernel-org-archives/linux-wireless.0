Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33199 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbcKRIpo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 03:45:44 -0500
Received: by mail-pf0-f196.google.com with SMTP id 144so13206218pfv.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 00:45:44 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Fri, 18 Nov 2016 00:45:37 -0800
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: [PATCH 4/7] mwifiex: Remove unused 'adapter'variable
Message-ID: <5a001da4fa5bc1365c7d463e7ce9f96b4a029d90.1479458373.git.kirtika@google.com> (sfid-20161118_094547_438938_36790B04)
References: <cover.1479458373.git.kirtika@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479458373.git.kirtika@google.com>
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
index 39ce76a..dd93cda 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3970,13 +3970,11 @@ static int mwifiex_tm_cmd(struct wiphy *wiphy, struct wireless_dev *wdev,
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
