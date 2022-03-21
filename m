Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F063BC433FE
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Mar 2022 11:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346934AbiCULxw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Mar 2022 07:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346923AbiCULwt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Mar 2022 07:52:49 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBB61575A2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2022 04:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=WqN5GinpQ6GaOH
        m+NbWUDUynB6s3adKS8MwbgKgGEGw=; b=urhrVmn82vKxahoXY7wN8ma9p08gyC
        ymgZc+ozWpv435AAaT8AxVIN5PS0H78AhUDebx2xPHrkB27d8Gb2kU/YO6GANqNE
        A82vlgtD1s7Gu49coOaNO4gClr+m51VolaT0HLgW1ZwB8okxfPZWHGUhtkfpI3yB
        fgvkNDVtLPzHE=
Received: (qmail 860372 invoked from network); 21 Mar 2022 12:51:09 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Mar 2022 12:51:09 +0100
X-UD-Smtp-Session: l3s3148p1@qMWyHLnaCqcgAQnoAFxnAN8BywfgXJ9V
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-mmc@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 05/10] wlcore: sdio: update to new MMC API for resetting cards
Date:   Mon, 21 Mar 2022 12:50:51 +0100
Message-Id: <20220321115059.21803-6-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321115059.21803-1-wsa+renesas@sang-engineering.com>
References: <20220321115059.21803-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

No functional change, only the name and the argument type change to
avoid confusion between resetting a card and a host controller.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

RFC, please do not apply yet.

 drivers/net/wireless/ti/wlcore/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 72fc41ac83c0..62246a98bbc9 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -146,7 +146,7 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
 	 * To guarantee that the SDIO card is power cycled, as required to make
 	 * the FW programming to succeed, let's do a brute force HW reset.
 	 */
-	mmc_hw_reset(card->host);
+	mmc_card_hw_reset(card);
 
 	sdio_enable_func(func);
 	sdio_release_host(func);
-- 
2.30.2

