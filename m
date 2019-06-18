Return-Path: <SRS0=fWKo=UR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE21C31E5B
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Jun 2019 15:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5F3520673
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Jun 2019 15:35:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VBR0Zcst"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfFRPfD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Jun 2019 11:35:03 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42974 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729189AbfFRPfC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jun 2019 11:35:02 -0400
Received: by mail-lf1-f67.google.com with SMTP id y13so9628395lfh.9
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jun 2019 08:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZXFe8l122poOCFrcN8cZI3D2EE1Nc366dY+GJ8RNKw4=;
        b=VBR0Zcst/y6Zg7oIQ4mCiOZS9J4Gla0OUrgxhrMyHzEX3xyIlkxoYPJ5WnVcOwRdPe
         xWKodz+F4ubwZAi3LVLAOmbh3sGvqYCT4fb7hu9NqFdIV8folFmY/Iw2nC4vj+54N0DQ
         3rhY0tHUiuUUPz7ADBDPvIzCWmjyiTTvPnzP5PYVyo8DOLizYbCzaRYXvaKR3Jds24pY
         83Z6HVJhtk3eDVKic08lSLmasQr0e3102/hWgIOKrkdAMHO6PgYjuDAvRZJs9o6iJFSR
         mcjHJjyR26i8a4mjI/ZXNE4cTrnxyN94674N5liojrdPmAoewMaZorggNXMMnPNLjTDh
         EVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZXFe8l122poOCFrcN8cZI3D2EE1Nc366dY+GJ8RNKw4=;
        b=SfBBpI+Te1oawINiJQLLnqVr0zbge+Uqb1Leg/dSrrVP9G+UWdvBOBiLdf1MngiTZM
         u0uap2o80ZOeRxciQpH0CaK9g9Qob3uUSE04XnqLy2l/TaBfCpVQCd+dFWJLhFrdm5or
         gwoZvjYv6jYR6pg+3ylPWpgbmQkkc9ECI/PryWu0S+nskmLqZe/9Lt/GyBfPRjNtGMCx
         FzJgv4TUcpb/5vpVOrbQm7G1JlbKKpIwxdFCIyKWzLgTqDrJIhJSDVko/hrUhfHt0EVV
         Claa1k5O9c/fYj+wb7O8fNl4MbRFYs16yJSWn5i+aDMwkTLkw05FOGvyf9PlX51m+lnQ
         udQg==
X-Gm-Message-State: APjAAAWXlXHTGFDnLCptmvWVXC/J2lUMtIzIP/lx8/7UpftpGG0wM0c8
        +AEeDGTn8FcZvv+fnyGJ2lvMAg==
X-Google-Smtp-Source: APXvYqyOREFdkP4FC4HW7yzVMISId5ZhI6EQ+UQ/bNuv27HzdT0y6uvxlbXF6tdziRwwwuG91a5bpw==
X-Received: by 2002:a19:750b:: with SMTP id y11mr21457683lfe.16.1560872099899;
        Tue, 18 Jun 2019 08:34:59 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id d15sm2203121lfq.76.2019.06.18.08.34.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 08:34:59 -0700 (PDT)
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
Subject: [PATCH 1/7] mmc: sdio: Turn sdio_run_irqs() into static
Date:   Tue, 18 Jun 2019 17:34:42 +0200
Message-Id: <20190618153448.27145-2-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190618153448.27145-1-ulf.hansson@linaro.org>
References: <20190618153448.27145-1-ulf.hansson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

All external users of sdio_run_irqs() have converted into using the
preferred sdio_signal_irq() interface, thus not calling the function
directly any more. Avoid further new users of it, by turning it into
static.

Suggested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/core/sdio_irq.c | 3 +--
 include/linux/mmc/host.h    | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index 9f54a259a1b3..0bcc5e83bd1a 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -92,7 +92,7 @@ static int process_sdio_pending_irqs(struct mmc_host *host)
 	return ret;
 }
 
-void sdio_run_irqs(struct mmc_host *host)
+static void sdio_run_irqs(struct mmc_host *host)
 {
 	mmc_claim_host(host);
 	if (host->sdio_irqs) {
@@ -103,7 +103,6 @@ void sdio_run_irqs(struct mmc_host *host)
 	}
 	mmc_release_host(host);
 }
-EXPORT_SYMBOL_GPL(sdio_run_irqs);
 
 void sdio_irq_work(struct work_struct *work)
 {
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index ecb7972e2423..a9b12322c775 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -504,7 +504,6 @@ static inline void mmc_signal_sdio_irq(struct mmc_host *host)
 		wake_up_process(host->sdio_irq_thread);
 }
 
-void sdio_run_irqs(struct mmc_host *host);
 void sdio_signal_irq(struct mmc_host *host);
 
 #ifdef CONFIG_REGULATOR
-- 
2.17.1

