Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5ACFC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 16:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B56D206A2
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 16:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388295AbeLQQma (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 11:42:30 -0500
Received: from muru.com ([72.249.23.125]:58570 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388011AbeLQQma (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 11:42:30 -0500
Received: from hillo.muru.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTP id 5FF4E80DB;
        Mon, 17 Dec 2018 16:42:33 +0000 (UTC)
From:   Tony Lindgren <tony@atomide.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH] wlcore: Fix bringing up wlan0 again if powered down briefly
Date:   Mon, 17 Dec 2018 08:42:07 -0800
Message-Id: <20181217164207.20081-1-tony@atomide.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

At least HiKey board can fail to bring up wireless interface again
if the interface is brought down and up with no delay inbetween.

This can be done tested with:

# while true; do ifconfig wlan0 down; ifconfig wlan0 up; done

According to Ricardo Salveti <rsalveti@rsalveti.net>, we need to
wait between 30 - 40 ms on HiKey. This seems to happen when we
get -EBUSY returned by pm_runtime_put() basedon the check in
rpm_check_suspend_allowed(). But as it still unclear if part of
the delay needed is because of capacitance, let's always do a
at least 50 ms msleep even if no -EBUSY is returned.

Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Eyal Reizer <eyalr@ti.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ricardo Salveti <rsalveti@rsalveti.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Reported-by: Ricardo Salveti <rsalveti@rsalveti.net>
Fixes: 60f36637bbbd ("wlcore: sdio: allow pm to handle sdio power")
Signed-off-by: Tony Lindgren <tony@atomide.com>
---

Uffe, do you have some better ideas on how to fix this issue?

---
 drivers/net/wireless/ti/wlcore/sdio.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -174,7 +174,7 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
 {
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 	struct mmc_card *card = func->card;
-	int error;
+	int error, retries = 5;
 
 	sdio_claim_host(func);
 	sdio_disable_func(func);
@@ -188,6 +188,17 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
 		return error;
 	}
 
+	/* Wait a bit to ensure the card gets power off. Otherwise
+	 * bringing interface down and up again may not power off the
+	 * card inbetween. And then firmware load will fail on trying
+	 * to bring the card up again. We need to wait between 30 - 40
+	 * ms for this based on measurements on HiKey board.
+	 */
+	do {
+		msleep(50);
+	} while (error == -EBUSY && !pm_runtime_suspended(&card->dev) &&
+		 retries--);
+
 	return 0;
 }
 
-- 
2.19.2
