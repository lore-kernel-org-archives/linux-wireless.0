Return-Path: <SRS0=6X5c=S6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BC4C43219
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 21:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22E8A20679
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 21:38:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oj97Xpmf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfD1Viz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Apr 2019 17:38:55 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34809 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfD1Viz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Apr 2019 17:38:55 -0400
Received: by mail-lj1-f195.google.com with SMTP id s7so4845112ljh.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Apr 2019 14:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3LpzNMo7WzTLbD9FEBBaOGlOx/z0LXrnuqvvu7P9Jg0=;
        b=oj97XpmffTFi1lRFzvJEK23p6Qw9qDNzR8NjdwuN4mbUVFLurrPdMqJ3/fby70jkH0
         IJAdzx/jXEMPi3JMxOPW5xETAd9QssnP0y6FbSNJwkFT7XFmq9TIEnbHtyUAnQiUYHnC
         Ut5PUUj7hYGs8AbytJrL93zB6Mrv4RUxWxrSiNyRXhPA22l4+usTSQuoa54Es75no40p
         swT38AycDF/kPbWRYtZX7frHpN9ErKMBMUPLKgcmJSt1x5Wi5VZIr1ysozBSOv0L5Wme
         pfL1uDG5sVHKCAHizbHRKIi4VoI0z8zn9ywXDBTzZgEXzoRWseDwaIZs0Oc7doD44hcj
         8tXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3LpzNMo7WzTLbD9FEBBaOGlOx/z0LXrnuqvvu7P9Jg0=;
        b=Rsjz5K8vIubEvKmxymRID27AAPx0OQGTwAKuzDR+dSMUJzXdrk8mGi+qjW/+2X1cTZ
         42FChnzUS74hfGuzkCM2laJRWYyvUeme2i0O+iU7/GJzR2jG+/cU+l7D3PFBbrh3afDs
         jKhhtAcrPhW10fy1UkzDpgU0PqSqFlF+BjG8M8vTnxFWjJ6RPuRzfvq7AN3VMemnkEhZ
         cqmzTBr1d74KMYHU7Krk/hwqKQ2dp0jTTb3YWcSzWF9wdkY4R1N1ewNS9wDELLaPFlP2
         Ew1fsfHr/WX8jN7CPdXdwMH4u7+VQV6OEox+eqDETvuhElOYw4SkcmRue80btr8dvRc1
         PFMw==
X-Gm-Message-State: APjAAAWep3GzeIyb8B6A4tsb8NcHb8BOTEiERXUn6HIvuXAeTxmf4vVI
        2ICOJGSsBIaTWRxI0HIkgrGZyNNencM=
X-Google-Smtp-Source: APXvYqxFewcYPcqutEbjWMWqPKFGKxwouqpugez8gIKLcVyCZoEG2AJkYAnEsp9MU8XHJIgYZK7SNA==
X-Received: by 2002:a2e:94c7:: with SMTP id r7mr31029530ljh.91.1556487532607;
        Sun, 28 Apr 2019 14:38:52 -0700 (PDT)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id m3sm7004167lfh.94.2019.04.28.14.38.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 14:38:51 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2] brcmfmac: print firmware messages after a firmware crash
Date:   Sun, 28 Apr 2019 23:38:26 +0200
Message-Id: <20190428213826.24526-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190427183008.27111-1-zajec5@gmail.com>
References: <20190427183008.27111-1-zajec5@gmail.com>
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
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
V2: Use "bool" for brcmf_pcie_bus_console_read() error argument
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 637973fe8928..594c14be5df0 100644
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
+					bool error)
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

