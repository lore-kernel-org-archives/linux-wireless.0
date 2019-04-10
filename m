Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5822FC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 22:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B8F720850
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 22:13:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OsP7Cut6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfDJWNN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 18:13:13 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34996 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfDJWNN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 18:13:13 -0400
Received: by mail-pf1-f195.google.com with SMTP id t21so2303085pfh.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2019 15:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AH2uWeWDVR1mKb5UAk5tRyEUAJH8N7Eurp9zoekYiQU=;
        b=OsP7Cut6FInUipEpueQhoM9lNib/w8hk1yiqRF+1mc/dd2bmRMfLOEw2SXAQL57PXG
         3mmzQXAH8wUAVCzsP5BpP1BWMv/bfuxWx7RpDYmNe9++bWSyqEEtH3+zGuBhyCurjs6a
         Xhvt2IsFoVl2XQMkjc+D/RUWrW2QMgE4Hue90=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AH2uWeWDVR1mKb5UAk5tRyEUAJH8N7Eurp9zoekYiQU=;
        b=T5oxpJ2wkjMRVsJ1SdVNreOfXLm0CwQCCdXN7vNzzkW4rwaseAr7kRLlPLXkekVENa
         mpBhegB2ZlSkyyvMjYJ489X+dfSTQTzZrT1VSSqXvmA3SnQr2Clnc4vaK7Dm3HhcE5p+
         zw+vwQfsGfXwGkdo0e0/3Xw4QSgc0TlY6GCxDod3Pkj/EcCi7Mw1j+tKrHcyOw6Vfw82
         j3kTSpqP4Zv3IPGLSWgmBdPXdnHUtBuHYhWhdsCf0owQ2K5hbocx9PAWyZ3+Cu8WdTbz
         T6aLTAKeCCI6iLXVoemyzah+HxrUigcv8dNWoH0t2PZjMaMvQXHXlBRwEgkau/tMTHL5
         EfAQ==
X-Gm-Message-State: APjAAAVckJvegWYO/P/VD7M1FXw6LUv82ED71ugZoTNF11pkFNtpsOOb
        XTObA3cBu0kv6zv95d0Gi2rnvQ==
X-Google-Smtp-Source: APXvYqyI8bCAO2UYjcTV3MDBFvmsCYKpD6+GnngdyzBL/hybJjO2DHEYI0+ypyL7BZHSxQga3nyg4g==
X-Received: by 2002:a63:6fc1:: with SMTP id k184mr42588592pgc.239.1554934392261;
        Wed, 10 Apr 2019 15:13:12 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id m16sm92042429pfi.29.2019.04.10.15.13.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Apr 2019 15:13:11 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, heiko@sntech.de,
        linux-rockchip@lists.infradead.org, briannorris@chromium.org,
        linux-wireless@vger.kernel.org, mka@chromium.org,
        ryandcase@chromium.org, Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: dw_mmc: Disable SDIO interrupts while suspended to fix suspend/resume
Date:   Wed, 10 Apr 2019 15:12:37 -0700
Message-Id: <20190410221237.160856-1-dianders@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Processing SDIO interrupts while dw_mmc is suspended (or partly
suspended) seems like a bad idea.  We really don't want to be
processing them until we've gotten ourselves fully powered up.

You might be wondering how it's even possible to become suspended when
an SDIO interrupt is active.  As can be seen in
dw_mci_enable_sdio_irq(), we explicitly keep dw_mmc out of runtime
suspend when the SDIO interrupt is enabled.  ...but even though we
stop normal runtime suspend transitions when SDIO interrupts are
enabled, the dw_mci_runtime_suspend() can still get called for a full
system suspend.

Let's handle all this by explicitly masking SDIO interrupts in the
suspend call and unmasking them later in the resume call.  To do this
cleanly I'll keep track of whether the client requested that SDIO
interrupts be enabled so that we can reliably restore them regardless
of whether we're masking them for one reason or another.

Without this fix it can be seen that rk3288-veyron Chromebooks with
Marvell WiFi would sometimes fail to resume WiFi even after picking my
recent mwifiex patch [1].  Specifically you'd see messages like this:
  mwifiex_sdio mmc1:0001:1: Firmware wakeup failed
  mwifiex_sdio mmc1:0001:1: PREP_CMD: FW in reset state

...and tracing through the resume code in the failing cases showed
that we were processing a SDIO interrupt really early in the resume
call.

NOTE: downstream in Chrome OS 3.14 and 3.18 kernels (both of which
support the Marvell SDIO WiFi card) we had a patch ("CHROMIUM: sdio:
Defer SDIO interrupt handling until after resume") [2].  Presumably
this is the same problem that was solved by that patch.

[1] https://lkml.kernel.org/r/20190404040106.40519-1-dianders@chromium.org
[2] https://crrev.com/c/230765

Cc: <stable@vger.kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
I didn't put any "Fixes" tag here, but presumably this could be
backported to whichever kernels folks found it useful for.  I have at
least confirmed that kernels v4.14 and v4.19 (as well as v5.1-rc2)
show the problem.  It is very easy to pick this to v4.19 and it
definitely fixes the problem there.

I haven't spent the time to pick this to 4.14 myself, but presumably
it wouldn't be too hard to backport this as far as v4.13 since that
contains commit 32dba73772f8 ("mmc: dw_mmc: Convert to use
MMC_CAP2_SDIO_IRQ_NOTHREAD for SDIO IRQs").  Prior to that it might
make sense for anyone experiencing this problem to just pick the old
CHROMIUM patch to fix them.

 drivers/mmc/host/dw_mmc.c | 24 ++++++++++++++++++++----
 drivers/mmc/host/dw_mmc.h |  3 +++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 80dc2fd6576c..432f6e3ddd43 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1664,7 +1664,8 @@ static void dw_mci_init_card(struct mmc_host *mmc, struct mmc_card *card)
 	}
 }
 
-static void __dw_mci_enable_sdio_irq(struct dw_mci_slot *slot, int enb)
+static void __dw_mci_enable_sdio_irq(struct dw_mci_slot *slot, bool enb,
+				     bool client_requested)
 {
 	struct dw_mci *host = slot->host;
 	unsigned long irqflags;
@@ -1672,6 +1673,17 @@ static void __dw_mci_enable_sdio_irq(struct dw_mci_slot *slot, int enb)
 
 	spin_lock_irqsave(&host->irq_lock, irqflags);
 
+	/*
+	 * If this was requested by the client save the request.  If this
+	 * wasn't required by the client then logically AND it with the
+	 * client request since we want to disable if either the client
+	 * disabled OR we have some other reason to disable.
+	 */
+	if (client_requested)
+		host->client_sdio_enb = enb;
+	else if (!host->client_sdio_enb)
+		enb = 0;
+
 	/* Enable/disable Slot Specific SDIO interrupt */
 	int_mask = mci_readl(host, INTMASK);
 	if (enb)
@@ -1688,7 +1700,7 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
 	struct dw_mci_slot *slot = mmc_priv(mmc);
 	struct dw_mci *host = slot->host;
 
-	__dw_mci_enable_sdio_irq(slot, enb);
+	__dw_mci_enable_sdio_irq(slot, enb, true);
 
 	/* Avoid runtime suspending the device when SDIO IRQ is enabled */
 	if (enb)
@@ -1701,7 +1713,7 @@ static void dw_mci_ack_sdio_irq(struct mmc_host *mmc)
 {
 	struct dw_mci_slot *slot = mmc_priv(mmc);
 
-	__dw_mci_enable_sdio_irq(slot, 1);
+	__dw_mci_enable_sdio_irq(slot, true, false);
 }
 
 static int dw_mci_execute_tuning(struct mmc_host *mmc, u32 opcode)
@@ -2734,7 +2746,7 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 		if (pending & SDMMC_INT_SDIO(slot->sdio_id)) {
 			mci_writel(host, RINTSTS,
 				   SDMMC_INT_SDIO(slot->sdio_id));
-			__dw_mci_enable_sdio_irq(slot, 0);
+			__dw_mci_enable_sdio_irq(slot, false, false);
 			sdio_signal_irq(slot->mmc);
 		}
 
@@ -3424,6 +3436,8 @@ int dw_mci_runtime_suspend(struct device *dev)
 {
 	struct dw_mci *host = dev_get_drvdata(dev);
 
+	__dw_mci_enable_sdio_irq(host->slot, false, false);
+
 	if (host->use_dma && host->dma_ops->exit)
 		host->dma_ops->exit(host);
 
@@ -3490,6 +3504,8 @@ int dw_mci_runtime_resume(struct device *dev)
 	/* Now that slots are all setup, we can enable card detect */
 	dw_mci_enable_cd(host);
 
+	__dw_mci_enable_sdio_irq(host->slot, true, false);
+
 	return 0;
 
 err:
diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
index 46e9f8ec5398..dfbace0f5043 100644
--- a/drivers/mmc/host/dw_mmc.h
+++ b/drivers/mmc/host/dw_mmc.h
@@ -127,6 +127,7 @@ struct dw_mci_dma_slave {
  * @cmd11_timer: Timer for SD3.0 voltage switch over scheme.
  * @cto_timer: Timer for broken command transfer over scheme.
  * @dto_timer: Timer for broken data transfer over scheme.
+ * @client_sdio_enb: The value last passed to enable_sdio_irq.
  *
  * Locking
  * =======
@@ -234,6 +235,8 @@ struct dw_mci {
 	struct timer_list       cmd11_timer;
 	struct timer_list       cto_timer;
 	struct timer_list       dto_timer;
+
+	bool			client_sdio_enb;
 };
 
 /* DMA ops for Internal/External DMAC interface */
-- 
2.21.0.392.gf8f6787159e-goog

