Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:11621 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725964AbeIALtC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Sep 2018 07:49:02 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Pavani Muthyala <pavani.muthyala@redpinesignals.com>,
        Kees Cook <keescook@chromium.org>,
        Colin Ian King <colin.king@canonical.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
CC: YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH v4] rsi: remove set but not used variables 'header_size' and 'tx_params'
Date: Sat, 1 Sep 2018 07:48:27 +0000
Message-ID: <1535788107-171830-1-git-send-email-yuehaibing@huawei.com> (sfid-20180901_093809_318721_3CDE62BC)
In-Reply-To: <1535786170-169698-1-git-send-email-yuehaibing@huawei.com>
References: <1535786170-169698-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/rsi/rsi_91x_hal.c: In function 'rsi_send_data_pkt':
drivers/net/wireless/rsi/rsi_91x_hal.c:288:5: warning:
 variable 'header_size' set but not used [-Wunused-but-set-variable]

'tx_params' only used for 'header_size' dereferenced,so also
can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v4:add missing changlog,also wipe a messy code in commit log
v3:fix patch title as Siva Rebbagondla suggested
v2:remove unused 'tx_params'
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
