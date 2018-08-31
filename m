Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11212 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbeHaPVV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 11:21:21 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <kvalo@codeaurora.org>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <amit.karwar@redpinesignals.com>,
        <pavani.muthyala@redpinesignals.com>, <keescook@chromium.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2] rsi: remove set but not used variable 'header_size'
Date: Fri, 31 Aug 2018 19:13:25 +0800
Message-ID: <20180831111325.16984-1-yuehaibing@huawei.com> (sfid-20180831_131459_167298_92CA464A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/rsi/rsi_91x_hal.c: In function 'rsi_send_data_pkt':
drivers/net/wireless/rsi/rsi_91x_hal.c:288:5: warning:
 variable 'header_size' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: remove unused 'tx_params'
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 01edf96..182b066 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -282,10 +282,8 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	struct rsi_hw *adapter = common->priv;
 	struct ieee80211_vif *vif;
 	struct ieee80211_tx_info *info;
-	struct skb_info *tx_params;
 	struct ieee80211_bss_conf *bss;
 	int status = -EINVAL;
-	u8 header_size;
 
 	if (!skb)
 		return 0;
@@ -297,8 +295,6 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 		goto err;
 	vif = info->control.vif;
 	bss = &vif->bss_conf;
-	tx_params = (struct skb_info *)info->driver_data;
-	header_size = tx_params->internal_hdr_size;
 
 	if (((vif->type == NL80211_IFTYPE_STATION) ||
 	     (vif->type == NL80211_IFTYPE_P2P_CLIENT)) &&
-- 
2.7.0
