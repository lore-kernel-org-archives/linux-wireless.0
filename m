Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:45797 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727258AbeHaNX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 09:23:29 -0400
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
Subject: [PATCH] rsi: remove set but not used variable 'header_size'
Date: Fri, 31 Aug 2018 09:27:27 +0000
Message-ID: <1535707647-191888-1-git-send-email-yuehaibing@huawei.com> (sfid-20180831_111714_478091_7A6C831E)
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/rsi/rsi_91x_hal.c: In function 'rsi_send_data_pkt':
drivers/net/wireless/rsi/rsi_91x_hal.c:288:5: warning:
 variable 'header_size' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 01edf96..c4fb319 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -285,7 +285,6 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	struct skb_info *tx_params;
 	struct ieee80211_bss_conf *bss;
 	int status = -EINVAL;
-	u8 header_size;
 
 	if (!skb)
 		return 0;
@@ -298,7 +297,6 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	vif = info->control.vif;
 	bss = &vif->bss_conf;
 	tx_params = (struct skb_info *)info->driver_data;
-	header_size = tx_params->internal_hdr_size;
 
 	if (((vif->type == NL80211_IFTYPE_STATION) ||
 	     (vif->type == NL80211_IFTYPE_P2P_CLIENT)) &&
