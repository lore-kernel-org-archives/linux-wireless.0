Return-Path: <SRS0=RVLw=S5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEDFC43219
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 18:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 269602087C
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 18:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PPi400xi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfD0Sa1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Apr 2019 14:30:27 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44883 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfD0Sa1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Apr 2019 14:30:27 -0400
Received: by mail-lj1-f193.google.com with SMTP id h16so5763109ljg.11
        for <linux-wireless@vger.kernel.org>; Sat, 27 Apr 2019 11:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ko0+hR3ue92IPeCSp3aObcukxaMwMYr9VrZtV1PCK7E=;
        b=PPi400xi9YHUWwtt4czqqKcJtZmouwceZ/RRWixqrs+c7rL+dRf96TgMrUWxlybAp6
         tgjLK2UeRdk1YhavXW5458NJnGjOye4wH0eIXdYV1OvfkeUhjtcfuINaGP61zIUa86wX
         b6clinCK9B/LQSvedoNSchp3pYvdoCcGxeVyuQ/4vbNQYar/NoBwxEVHLhRBNOAW7rQy
         AKEZw9I7bxIygkphQskGCC95bqtx0TO2HqtdXfw38I5R+CACXz+tai4rZiTXv4VXuxBJ
         Fu41sqzIlr2c1/etLse8uym2yT4YhYD+lefGd7Jy8r+4dC74F5R91E/Y51pzzLmzNrNq
         DDNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ko0+hR3ue92IPeCSp3aObcukxaMwMYr9VrZtV1PCK7E=;
        b=halKl06jR3P37LhZ4XhqfdvvqRmcVBKv6tAO34H47tq8Fh/7otnG8o0WbvMYdiHDur
         eGfm1UoYp+QkIdtVkagjIGFyhNSyPSFfzKxDOFbP4w7ioJQew2CgNvocLBkCzwDjX97w
         0iD8I11RDfq13Sd2hH5A2e7JyV0ZCj697xGyvCS492hlHT8ePStYrQrDECQpK8Y45ZUR
         JFicxbxltqgypxQKcHtb+RTWfwv3cPrO5h++GtRCgd8cxRCbs5P/RVhQXjpDYEikN1xd
         GswzFQ/Ca0hBqzCP5lEjXHO+XafhOwmPmtO+69zWOp1tkceuu4CIS+1x0H7pFIf8Zcm7
         PlRA==
X-Gm-Message-State: APjAAAWFEIdg7iKg4BMGtPzEg9z/AdNf0/Q2urmQbGQL6C38mNHObp+A
        0q9+H9he7iS08gPuCfT25B0=
X-Google-Smtp-Source: APXvYqyGT7xz9j6/wyzPsmblQ8iJuKlmiBdvgqBiJyIzQSIaM7V6OgmNvfPcFqGzKkd876OoiWqoog==
X-Received: by 2002:a2e:7216:: with SMTP id n22mr14637722ljc.172.1556389825158;
        Sat, 27 Apr 2019 11:30:25 -0700 (PDT)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id o24sm3627466lfd.42.2019.04.27.11.30.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Apr 2019 11:30:24 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] brcmfmac: print firmware messages after a firmware crash
Date:   Sat, 27 Apr 2019 20:30:08 +0200
Message-Id: <20190427183008.27111-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Normally firmware messages are printed with debugging enabled only. It's
a good idea as firmware may print a lot of messages that normal users
don't need to care about.

However, on firmware crash, it may be very helpful to log all recent
messages. There is almost always a backtrace available as well as rought
info on the latest actions/state.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 637973fe8928..f519b050aff3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -764,15 +764,22 @@ static void brcmf_pcie_bus_console_init(struct brcmf_pciedev_info *devinfo)
 		  console->base_addr, console->buf_addr, console->bufsize);
 }
 
-
-static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo)
+/**
+ * brcmf_pcie_bus_console_read - reads firmware messages
+ *
+ * @error: specifies if error has occurred (prints messages unconditionally)
+ */
+static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo,
+					int error)
 {
+	struct pci_dev *pdev = devinfo->pdev;
+	struct brcmf_bus *bus = dev_get_drvdata(&pdev->dev);
 	struct brcmf_pcie_console *console;
 	u32 addr;
 	u8 ch;
 	u32 newidx;
 
-	if (!BRCMF_FWCON_ON())
+	if (!error && !BRCMF_FWCON_ON())
 		return;
 
 	console = &devinfo->shared.console;
@@ -796,7 +803,10 @@ static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo)
 		}
 		if (ch == '\n') {
 			console->log_str[console->log_idx] = 0;
-			pr_debug("CONSOLE: %s", console->log_str);
+			if (error)
+				brcmf_err(bus, "CONSOLE: %s", console->log_str);
+			else
+				pr_debug("CONSOLE: %s", console->log_str);
 			console->log_idx = 0;
 		}
 	}
@@ -857,7 +867,7 @@ static irqreturn_t brcmf_pcie_isr_thread(int irq, void *arg)
 							&devinfo->pdev->dev);
 		}
 	}
-	brcmf_pcie_bus_console_read(devinfo);
+	brcmf_pcie_bus_console_read(devinfo, false);
 	if (devinfo->state == BRCMFMAC_PCIE_STATE_UP)
 		brcmf_pcie_intr_enable(devinfo);
 	devinfo->in_irq = false;
@@ -1426,6 +1436,8 @@ static int brcmf_pcie_reset(struct device *dev)
 	struct brcmf_fw_request *fwreq;
 	int err;
 
+	brcmf_pcie_bus_console_read(devinfo, true);
+
 	brcmf_detach(dev);
 
 	brcmf_pcie_release_irq(devinfo);
@@ -1824,7 +1836,7 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 	if (brcmf_attach(&devinfo->pdev->dev, devinfo->settings) == 0)
 		return;
 
-	brcmf_pcie_bus_console_read(devinfo);
+	brcmf_pcie_bus_console_read(devinfo, false);
 
 fail:
 	device_release_driver(dev);
-- 
2.21.0

