Return-Path: <SRS0=fWKo=UR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A33C31E5B
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Jun 2019 15:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 500552147A
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Jun 2019 15:35:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NJtQhNNg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfFRPfL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Jun 2019 11:35:11 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38208 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729647AbfFRPfK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jun 2019 11:35:10 -0400
Received: by mail-lj1-f195.google.com with SMTP id r9so7582ljg.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jun 2019 08:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TrltWt+RtwnpkQQYwVLsi9uq9P2cQCYA5NaB1ic9l5s=;
        b=NJtQhNNg78seUtT1XUqdcun+UMhElbfhoNIrmqOJPrg/y7Ye3phqcqBR+aZ98PY7ym
         zUS1Vbkl7gJo+0odr3yJ5u8RTMX6IrzSFKnETVm9+PgQwUE27CphCmVDe6yrgYsFAe+A
         vUp+Xg+bcEVLGDGlBNWf6iJoXoKGOvCDpSqPsgD/pvHpgLSzQiptjF3BsGaopi4BMqp+
         XFjo3sJS4EJsFBOZwpsS36awBA+3QlazSpplPuyNVvJiLweDSIgfVFA1ryUwTPf7mA7O
         HRVjx/ouXbr276JXXyh6bEZedldNFLG48LVgbS6Ogn5U+GFfUUTNBtwEZLpg9XIZ3GJz
         sqrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TrltWt+RtwnpkQQYwVLsi9uq9P2cQCYA5NaB1ic9l5s=;
        b=tsdtCVN9Or6pmgLmFH6Lq6EHYNsbHLqlny3+OfrRcTXjnlg6cxIRDPYrLroxt/5Z2V
         H+vuQ2EjNQ9I5jMlrIaUAILyrt4i+bjOm6JVxfj57JWdtUkpVYTFCg9wG12ncMrBPAGw
         qe4eeurk6Q7PHpAjwg0jgSpNWtHv9xl6TaI4gLrO0gJp/7FTqwT9CjMReBdfg/NR0ost
         CiDia3tLJQe9qZgfTKsH3na7Rva7jQW/2Cwyvo2Z7Nc+citCQY6ltKaZAn8dFm+T3uxU
         Cv1n7SkU1FV3lNFrzSBdfOmlKhAHxBWkLTqtSnTH7kCHkSUt5IFFwKOf94tB2+HbuZ38
         6nPg==
X-Gm-Message-State: APjAAAU0uxzd1hQkxIiso+ByMTb+g49F8OAqgD5ojYe2xQn5Ddsj7SEY
        VuxC1Ctq0nhMuCx0CtaieRQgtw==
X-Google-Smtp-Source: APXvYqxung57/e+YH3aN47rF4dI9dtCp6RtpYgXnvVsMJBceOG9OE7z7rJ0srhWqzysCxn/FVJaEtQ==
X-Received: by 2002:a2e:9685:: with SMTP id q5mr14919419lji.227.1560872108802;
        Tue, 18 Jun 2019 08:35:08 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id d15sm2203121lfq.76.2019.06.18.08.35.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 08:35:08 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Douglas Anderson <dianders@chromium.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Guenter Roeck <groeck@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 7/7] mmc: sdio: Drop unused in-parameter from mmc_sdio_init_card()
Date:   Tue, 18 Jun 2019 17:34:48 +0200
Message-Id: <20190618153448.27145-8-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190618153448.27145-1-ulf.hansson@linaro.org>
References: <20190618153448.27145-1-ulf.hansson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The "powered_resume" in-parameter to mmc_sdio_init_card() has now become
redundant as all callers set it to 0. Therefore let's just drop it.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/core/sdio.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 0bf603670f61..8dd8fc32ecca 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -559,7 +559,7 @@ static void mmc_sdio_resend_if_cond(struct mmc_host *host,
  * we're trying to reinitialise.
  */
 static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
-			      struct mmc_card *oldcard, int powered_resume)
+			      struct mmc_card *oldcard)
 {
 	struct mmc_card *card;
 	int err;
@@ -582,11 +582,9 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	/*
 	 * Inform the card of the voltage
 	 */
-	if (!powered_resume) {
-		err = mmc_send_io_op_cond(host, ocr, &rocr);
-		if (err)
-			goto err;
-	}
+	err = mmc_send_io_op_cond(host, ocr, &rocr);
+	if (err)
+		goto err;
 
 	/*
 	 * For SPI, enable CRC as appropriate.
@@ -645,7 +643,7 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	 * try to init uhs card. sdio_read_cccr will take over this task
 	 * to make sure which speed mode should work.
 	 */
-	if (!powered_resume && (rocr & ocr & R4_18V_PRESENT)) {
+	if (rocr & ocr & R4_18V_PRESENT) {
 		err = mmc_set_uhs_voltage(host, ocr_card);
 		if (err == -EAGAIN) {
 			mmc_sdio_resend_if_cond(host, card);
@@ -659,7 +657,7 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	/*
 	 * For native busses:  set card RCA and quit open drain mode.
 	 */
-	if (!powered_resume && !mmc_host_is_spi(host)) {
+	if (!mmc_host_is_spi(host)) {
 		err = mmc_send_relative_addr(host, &card->rca);
 		if (err)
 			goto remove;
@@ -687,7 +685,7 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	/*
 	 * Select card, as all following commands rely on that.
 	 */
-	if (!powered_resume && !mmc_host_is_spi(host)) {
+	if (!mmc_host_is_spi(host)) {
 		err = mmc_select_card(card);
 		if (err)
 			goto remove;
@@ -845,7 +843,7 @@ static int mmc_sdio_reinit_card(struct mmc_host *host)
 	if (ret)
 		return ret;
 
-	return mmc_sdio_init_card(host, host->card->ocr, host->card, 0);
+	return mmc_sdio_init_card(host, host->card->ocr, host->card);
 }
 
 /*
@@ -1113,7 +1111,7 @@ int mmc_attach_sdio(struct mmc_host *host)
 	/*
 	 * Detect and init the card.
 	 */
-	err = mmc_sdio_init_card(host, rocr, NULL, 0);
+	err = mmc_sdio_init_card(host, rocr, NULL);
 	if (err)
 		goto err;
 
-- 
2.17.1

