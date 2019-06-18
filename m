Return-Path: <SRS0=fWKo=UR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2F9C31E5B
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Jun 2019 15:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 262DE20673
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Jun 2019 15:35:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DUVUxiby"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbfFRPfG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Jun 2019 11:35:06 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33393 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729647AbfFRPfG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jun 2019 11:35:06 -0400
Received: by mail-lj1-f196.google.com with SMTP id h10so42617ljg.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jun 2019 08:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=39AvwfEHlmBtGb6TxK0PyFLzSAjznL8ashWYfCKeN2c=;
        b=DUVUxibyDbzeXA/hk3Zo8He9/+aJwnnN/pWh2NoweNxHStKsgrZcL3ZumTlXIZi9dc
         WeUijBH1Poz8ChLYZL1bKBUZAU3ZR2rj+GsEo6x7xMich3xxY2RV2kmS46NGxJI1MlWJ
         MRV+/JP6Ow8j7mAt22aZqlyJMo58hJW7C1+l5F2aW3gLhq3E6aifPYIMX50uxHGyRfAj
         nyDIqPeURa/a7Fy4aPbWw0kn8Ksosu30TGM/Pb52uAWj/Szv97GuIBw2bLOWuedt4IlD
         CFBVs6KhAozkHAU+vLUcbzP663GUGFkz2FWRwQ9+z//w/fik73WCUrLkrWQCSIWWuAav
         LI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=39AvwfEHlmBtGb6TxK0PyFLzSAjznL8ashWYfCKeN2c=;
        b=BCjQHCjaSot2uG6NXsR7V3ZktBY0M6rnByuv3Y+gSATDY92z/CJWExR4qOO3rHuSnH
         hkfWSW/kPoIr1IDAcdf27vVFwUBt0jH+E8dph9RnxPd45oxeSPMmu1XsBS2x+WD/Ny8A
         4mpazIXUKJ3tnDi+eyi6if4B6K/W+ly65Rs37U6acfnL1ETgkTd3vbLatDdtk4Knvj0X
         PvjGT4wfb8D7qSyQj6sjni+9r1AvWtLLs9HvYPOlJq+moIrYmlXNMDOwl95h8wUhqKRC
         v2MxEUfcYEp31qrN5TZgDshezqnaD4MNyZbf7czFXtL6Pp7XyGvzcwgx9nCGvsbnH6Ha
         EgIQ==
X-Gm-Message-State: APjAAAXQ25A+gmb5ELupiNPyricla/GiizX3/TjUbD4LeUtsCYVdAO4e
        3FEGsPyfFwS4R3MFcNQUfFBLWQ==
X-Google-Smtp-Source: APXvYqzqSuNRPHYXuZYjsrM4vMz/pSEweQAxVCKNSjhT88bGxkBRwG2XZGuS418CXp2VRlIwakP1rw==
X-Received: by 2002:a2e:9c03:: with SMTP id s3mr47966037lji.209.1560872104224;
        Tue, 18 Jun 2019 08:35:04 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id d15sm2203121lfq.76.2019.06.18.08.35.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 08:35:03 -0700 (PDT)
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
Subject: [PATCH 4/7] mmc: sdio: Drop powered-on re-init at runtime resume and HW reset
Date:   Tue, 18 Jun 2019 17:34:45 +0200
Message-Id: <20190618153448.27145-5-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190618153448.27145-1-ulf.hansson@linaro.org>
References: <20190618153448.27145-1-ulf.hansson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

To use the so called powered-on re-initialization of an SDIO card, the
power to the card must obviously have stayed on. If not, the initialization
will simply fail.

In the runtime suspend case, the card is always powered off. Hence, let's
drop the support for powered-on re-initialization during runtime resume, as
it doesn't make sense.

Moreover, during a HW reset, the point is to cut the power to the card and
then do fresh re-initialization. Therefore drop the support for powered-on
re-initialization during HW reset.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/core/sdio.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 29f86c1e9923..a9bfcae8db5b 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -1028,13 +1028,7 @@ static int mmc_sdio_resume(struct mmc_host *host)
 
 static int mmc_sdio_power_restore(struct mmc_host *host)
 {
-	int ret;
-
-	ret = mmc_sdio_reinit_card(host, mmc_card_keep_power(host));
-	if (!ret && host->sdio_irqs)
-		mmc_signal_sdio_irq(host);
-
-	return ret;
+	return mmc_sdio_reinit_card(host, 0);
 }
 
 static int mmc_sdio_runtime_suspend(struct mmc_host *host)
-- 
2.17.1

