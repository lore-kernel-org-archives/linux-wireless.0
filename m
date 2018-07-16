Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40887 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbeGPODz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jul 2018 10:03:55 -0400
Received: by mail-pg1-f195.google.com with SMTP id x5-v6so7514430pgp.7
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jul 2018 06:36:26 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Amol Hanwate <amol.hanwate@redpinesignals.com>
Subject: [PATCH 6/6] rsi: move init_done flag to end of rsi_91x_init().
Date: Mon, 16 Jul 2018 19:09:37 +0530
Message-Id: <1531748377-29215-7-git-send-email-siva8118@gmail.com> (sfid-20180716_153637_466112_33B19657)
In-Reply-To: <1531748377-29215-1-git-send-email-siva8118@gmail.com>
References: <1531748377-29215-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amol Hanwate <amol.hanwate@redpinesignals.com>

common->init_done flag should set after basic initialization. Hence,
moving init_done flag at end of rsi_91x_init().

Signed-off-by: Amol Hanwate <amol.hanwate@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 34a5d9c..01d99ed 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -331,7 +331,6 @@ struct rsi_hw *rsi_91x_init(u16 oper_mode)
 	spin_lock_init(&adapter->ps_lock);
 	timer_setup(&common->roc_timer, rsi_roc_timeout, 0);
 	init_completion(&common->wlan_init_completion);
-	common->init_done = true;
 	adapter->device_model = RSI_DEV_9113;
 	common->oper_mode = oper_mode;
 
@@ -369,6 +368,7 @@ struct rsi_hw *rsi_91x_init(u16 oper_mode)
 	}
 #endif
 
+	common->init_done = true;
 	return adapter;
 
 err:
-- 
2.5.5
