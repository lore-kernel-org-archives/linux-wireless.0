Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:12096 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726563AbeIKRV2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 13:21:28 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: Maya Erez <merez@codeaurora.org>, Kalle Valo <kvalo@codeaurora.org>
CC: YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qti.qualcomm.com>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH] wil6210: remove set but not used variable 'start'
Date: Tue, 11 Sep 2018 12:32:19 +0000
Message-ID: <1536669139-14848-1-git-send-email-yuehaibing@huawei.com> (sfid-20180911_142229_712510_2109341E)
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/ath/wil6210/pm.c: In function 'wil_suspend_keep_radio_on':
drivers/net/wireless/ath/wil6210/pm.c:193:16: warning:
 variable 'start' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/wil6210/pm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index 3a41947..75fe932 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -190,7 +190,7 @@ static int wil_resume_keep_radio_on(struct wil6210_priv *wil)
 static int wil_suspend_keep_radio_on(struct wil6210_priv *wil)
 {
 	int rc = 0;
-	unsigned long start, data_comp_to;
+	unsigned long data_comp_to;
 
 	wil_dbg_pm(wil, "suspend keep radio on\n");
 
@@ -232,7 +232,6 @@ static int wil_suspend_keep_radio_on(struct wil6210_priv *wil)
 	}
 
 	/* Wait for completion of the pending RX packets */
-	start = jiffies;
 	data_comp_to = jiffies + msecs_to_jiffies(WIL_DATA_COMPLETION_TO_MS);
 	if (test_bit(wil_status_napi_en, wil->status)) {
 		while (!wil->txrx_ops.is_rx_idle(wil)) {
