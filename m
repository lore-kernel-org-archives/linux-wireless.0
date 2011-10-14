Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60387 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab1JNMw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 08:52:57 -0400
Received: by ggnb1 with SMTP id b1so344031ggn.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 05:52:56 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, patches@linaro.org,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH 2/5] ath6kl: Add SDIO polling function hook into SDIO init time
Date: Fri, 14 Oct 2011 13:50:43 +0100
Message-Id: <1318596646-19495-3-git-send-email-sangwook.lee@linaro.org> (sfid-20111014_145328_504218_C3E8D0E9)
In-Reply-To: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org>
References: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add SDIO polling function into SDIO related file

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index f48af45..f3520d9 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -447,6 +447,9 @@ static void ath6kl_sdio_irq_handler(struct sdio_func *func)
 	int status;
 	struct ath6kl_sdio *ar_sdio;
 
+	if (ath6kl_wd_poll_is_ture())
+		return;
+
 	ath6kl_dbg(ATH6KL_DBG_SDIO, "irq\n");
 
 	ar_sdio = sdio_get_drvdata(func);
@@ -858,6 +861,8 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 
 	sdio_release_host(func);
 
+	ath6kl_wd_init(ar);
+
 	ret = ath6kl_core_init(ar);
 	if (ret) {
 		ath6kl_err("Failed to init ath6kl core\n");
@@ -891,6 +896,8 @@ static void ath6kl_sdio_remove(struct sdio_func *func)
 	ath6kl_stop_txrx(ar_sdio->ar);
 	cancel_work_sync(&ar_sdio->wr_async_work);
 
+	ath6kl_wd_cleanup(ar_sdio->ar);
+
 	ath6kl_unavail_ev(ar_sdio->ar);
 
 	ath6kl_sdio_power_off(ar_sdio);
-- 
1.7.4.1

