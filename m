Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:50249 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726678AbeIKRRc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 13:17:32 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        "Andrey Shevchenko" <ashevchenko@quantenna.com>
CC: YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] qtnfmac: remove set but not used variable 'vif'
Date: Tue, 11 Sep 2018 12:28:24 +0000
Message-ID: <1536668904-13110-1-git-send-email-yuehaibing@huawei.com> (sfid-20180911_141831_602740_2CE33924)
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/quantenna/qtnfmac/cfg80211.c: In function 'qtnf_dump_survey':
drivers/net/wireless/quantenna/qtnfmac/cfg80211.c:694:19: warning:
 variable 'vif' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 4aa332f..452d4b7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -691,11 +691,8 @@ static int qtnf_set_default_key(struct wiphy *wiphy, struct net_device *dev,
 	const struct cfg80211_chan_def *chandef = &wdev->chandef;
 	struct ieee80211_channel *chan;
 	struct qtnf_chan_stats stats;
-	struct qtnf_vif *vif;
 	int ret;
 
-	vif = qtnf_netdev_get_priv(dev);
-
 	sband = wiphy->bands[NL80211_BAND_2GHZ];
 	if (sband && idx >= sband->n_channels) {
 		idx -= sband->n_channels;
