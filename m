Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 115DBC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 15:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D52F520C01
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551367618;
	bh=9fjNvQiPeQyd4K0FkeQ+YimG+qYmhIbif4GLc5Gu10A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MOpYwW7U4izG+JdRvAUE1TVvX0OOulO5tiVgWcErgvyr5QKIDYeNdMCc94MuBdxYJ
	 YgCOBbZFrya+Q4DWIXdvbHbYLA/GhQuolkrn4mYCjfMsrtmbIQcHmse/JfBYfwu6Nw
	 cTGJdnaR5go4tdBljlOgkzAXiVRPbLvVM/oNNmTA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387988AbfB1PL2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:11:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732712AbfB1PL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 10:11:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7703218C3;
        Thu, 28 Feb 2019 15:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551366686;
        bh=9fjNvQiPeQyd4K0FkeQ+YimG+qYmhIbif4GLc5Gu10A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROvgzuyVL5d8w7lkxmgj97tPPT9LpTbGpYisLsMTL9vKgHXsTBp2kjf+r26wCTRLt
         BcIivXt5s9n2MKToOa57g21PSekZxWEOCve1aHFjgnu6gCPP3f4fZHLTBSY5EVvDaY
         zABGfaUUXZZ2hLpvJTCbElyMokDEnP5MCRrrt5R8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/64] wlcore: sdio: Fixup power on/off sequence
Date:   Thu, 28 Feb 2019 10:10:13 -0500
Message-Id: <20190228151105.11277-12-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190228151105.11277-1-sashal@kernel.org>
References: <20190228151105.11277-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 13e62626c578d9889ebbda7c521be5adff9bef8e ]

During "wlan-up", we are programming the FW into the WiFi-chip. However,
re-programming the FW doesn't work, unless a power cycle of the WiFi-chip
is made in-between the programmings.

To conform to this requirement and to fix the regression in a simple way,
let's start by allowing that the SDIO card (WiFi-chip) may stay powered on
(runtime resumed) when wl12xx_sdio_power_off() returns. The intent with the
current code is to treat this scenario as an error, but unfortunate this
doesn't work as expected, so let's fix this.

The other part is to guarantee that a power cycle of the SDIO card has been
completed when wl12xx_sdio_power_on() returns, as to allow the FW
programming to succeed. However, relying solely on runtime PM to deal with
this isn't sufficient. For example, userspace may prevent runtime suspend
via sysfs for the device that represents the SDIO card, leading to that the
mmc core also keeps it powered on. For this reason, let's instead do a
brute force power cycle in wl12xx_sdio_power_on().

Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM handling")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 750bea3574ee4..627df164b7b6d 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -164,6 +164,12 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
 	}
 
 	sdio_claim_host(func);
+	/*
+	 * To guarantee that the SDIO card is power cycled, as required to make
+	 * the FW programming to succeed, let's do a brute force HW reset.
+	 */
+	mmc_hw_reset(card->host);
+
 	sdio_enable_func(func);
 	sdio_release_host(func);
 
@@ -174,20 +180,13 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
 {
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 	struct mmc_card *card = func->card;
-	int error;
 
 	sdio_claim_host(func);
 	sdio_disable_func(func);
 	sdio_release_host(func);
 
 	/* Let runtime PM know the card is powered off */
-	error = pm_runtime_put(&card->dev);
-	if (error < 0 && error != -EBUSY) {
-		dev_err(&card->dev, "%s failed: %i\n", __func__, error);
-
-		return error;
-	}
-
+	pm_runtime_put(&card->dev);
 	return 0;
 }
 
-- 
2.19.1

