Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CBCC169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3ED0217F9
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:28:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dkJTLF5l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfBFL2b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:28:31 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36237 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfBFL2b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:28:31 -0500
Received: by mail-lj1-f195.google.com with SMTP id g11-v6so5712528ljk.3
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2019 03:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z1a86flMn7/O/+P7pD28X1By5G5bBYE1uHToC77cj5o=;
        b=dkJTLF5lGBoVo0HX2Go+7UTNrFOqRIhSF9zcYAgmHwyLlFKMsfSyhFiOBd2jTRLwts
         IhwTsMWFKStz8/4agn8fltF30Lt3jDJHomP+Rh9HQMz6qcGxS9g7T1uQGmRLTWoOqZoL
         hychrs/VCzF3fss8Xv4GqwVCE5qf+tP92r8zc3ZADTuiXpe38WQtwDG+pf+5Am0DK89E
         ZnZN7S/9Td2jIwOfweTXMsbtVKF8Pb6oFGbGeJMHG4/iUWN1TarVtcS0/+XeHl2WTTwV
         Y7Llns+7NeoQaJFQropWddWZmQo+dkRV2o2ivppO3cnrzBbT3rNZ1gfXxG7gNZE3v1Fe
         EUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z1a86flMn7/O/+P7pD28X1By5G5bBYE1uHToC77cj5o=;
        b=A3Zo+HVRiCAHLLMsaMRac8nJIrcFyeyaXGCDVTeLj2pXcubvk6rnwSaeUTMdIqiz1O
         qFj8oLV6iuF/bBltS+TUoGuB+NKHUreH3dKUgXRxJy9g/bifTgGuOVrD82JjAELH5Fgz
         G7QLeaVWzhT7zO49yZx8SMZIOJgQ1kQNnRhWyiE4MXd/7u82VeOI2omKLKAvOWajNd5s
         UWxeeUqdggFeZ0crt5Mc6v1pwDr8CP0xXfE3oA492UJ+8B+5U+HcFcYjjDGZxJhE6eUh
         odTZyfHgKM6lfvlQd+OUayBAWl35CS5+VhjwRcwhpK+carl6fpJOPqYJY9MPver35NXz
         s/Ig==
X-Gm-Message-State: AHQUAuZZFkcJPA9dKmfnJUb/B7buPTOaodWdpcH7yYI6XzoxDBMkG4wv
        bHK5k7ygI8z7grO1LWZnu4Q=
X-Google-Smtp-Source: AHgI3Ib7u+zIQQNDlwJoWjR5AskI+UbJanTNkmqtmG+p/tk2YplZCxcuhu01q7dbEesGLZG3P7yTxg==
X-Received: by 2002:a2e:9556:: with SMTP id t22-v6mr6086625ljh.36.1549452507054;
        Wed, 06 Feb 2019 03:28:27 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id h22-v6sm4111894lji.45.2019.02.06.03.28.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 03:28:26 -0800 (PST)
From:   "=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?=" <rafal.milecki@gmail.com>
X-Google-Original-From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V3 2/2] brcmfmac: pass bus to the __brcmf_err() in pcie.c
Date:   Wed,  6 Feb 2019 12:28:16 +0100
Message-Id: <20190206112816.563-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206112816.563-1-zajec5@gmail.com>
References: <20190206112816.563-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This enables dev_err() usage (instead of pr_err()) in the __brcmf_err().
It makes error messages more meaningful and is important for debugging
errors/bugs on systems with multiple brcmfmac supported devices.

All bus files should follow & get updated similarly (soon).

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Modify pcie.c & not cfg80211.c. The later should use wiphy_err()
V3: Fix CONFIG_PM=y compliation errors:
    error: redeclaration of 'bus' with no linkage
---
 .../broadcom/brcm80211/brcmfmac/debug.h       |  2 +
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 59 +++++++++++--------
 2 files changed, 38 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index b499f90d94f6..c1f260718c8e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -52,6 +52,7 @@ void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...);
 /* Macro for error messages. When debugging / tracing the driver all error
  * messages are important to us.
  */
+#ifndef brcmf_err
 #define brcmf_err(fmt, ...)						\
 	do {								\
 		if (IS_ENABLED(CONFIG_BRCMDBG) ||			\
@@ -59,6 +60,7 @@ void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...);
 		    net_ratelimit())					\
 			__brcmf_err(NULL, __func__, fmt, ##__VA_ARGS__);\
 	} while (0)
+#endif
 
 #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 16d7dda965d8..8f68e30fa5fa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -30,6 +30,15 @@
 #include <brcmu_wifi.h>
 #include <brcm_hw_ids.h>
 
+/* Custom brcmf_err() that takes bus arg and passes it further */
+#define brcmf_err(bus, fmt, ...)					\
+	do {								\
+		if (IS_ENABLED(CONFIG_BRCMDBG) ||			\
+		    IS_ENABLED(CONFIG_BRCM_TRACING) ||			\
+		    net_ratelimit())					\
+			__brcmf_err(bus, __func__, fmt, ##__VA_ARGS__);	\
+	} while (0)
+
 #include "debug.h"
 #include "bus.h"
 #include "commonring.h"
@@ -531,6 +540,7 @@ static void
 brcmf_pcie_select_core(struct brcmf_pciedev_info *devinfo, u16 coreid)
 {
 	const struct pci_dev *pdev = devinfo->pdev;
+	struct brcmf_bus *bus = dev_get_drvdata(&pdev->dev);
 	struct brcmf_core *core;
 	u32 bar0_win;
 
@@ -548,7 +558,7 @@ brcmf_pcie_select_core(struct brcmf_pciedev_info *devinfo, u16 coreid)
 			}
 		}
 	} else {
-		brcmf_err("Unsupported core selected %x\n", coreid);
+		brcmf_err(bus, "Unsupported core selected %x\n", coreid);
 	}
 }
 
@@ -848,9 +858,8 @@ static irqreturn_t brcmf_pcie_isr_thread(int irq, void *arg)
 
 static int brcmf_pcie_request_irq(struct brcmf_pciedev_info *devinfo)
 {
-	struct pci_dev *pdev;
-
-	pdev = devinfo->pdev;
+	struct pci_dev *pdev = devinfo->pdev;
+	struct brcmf_bus *bus = dev_get_drvdata(&pdev->dev);
 
 	brcmf_pcie_intr_disable(devinfo);
 
@@ -861,7 +870,7 @@ static int brcmf_pcie_request_irq(struct brcmf_pciedev_info *devinfo)
 				 brcmf_pcie_isr_thread, IRQF_SHARED,
 				 "brcmf_pcie_intr", devinfo)) {
 		pci_disable_msi(pdev);
-		brcmf_err("Failed to request IRQ %d\n", pdev->irq);
+		brcmf_err(bus, "Failed to request IRQ %d\n", pdev->irq);
 		return -EIO;
 	}
 	devinfo->irq_allocated = true;
@@ -871,15 +880,14 @@ static int brcmf_pcie_request_irq(struct brcmf_pciedev_info *devinfo)
 
 static void brcmf_pcie_release_irq(struct brcmf_pciedev_info *devinfo)
 {
-	struct pci_dev *pdev;
+	struct pci_dev *pdev = devinfo->pdev;
+	struct brcmf_bus *bus = dev_get_drvdata(&pdev->dev);
 	u32 status;
 	u32 count;
 
 	if (!devinfo->irq_allocated)
 		return;
 
-	pdev = devinfo->pdev;
-
 	brcmf_pcie_intr_disable(devinfo);
 	free_irq(pdev->irq, devinfo);
 	pci_disable_msi(pdev);
@@ -891,7 +899,7 @@ static void brcmf_pcie_release_irq(struct brcmf_pciedev_info *devinfo)
 		count++;
 	}
 	if (devinfo->in_irq)
-		brcmf_err("Still in IRQ (processing) !!!\n");
+		brcmf_err(bus, "Still in IRQ (processing) !!!\n");
 
 	status = brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT);
 	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT, status);
@@ -1102,6 +1110,7 @@ static void brcmf_pcie_release_ringbuffers(struct brcmf_pciedev_info *devinfo)
 
 static int brcmf_pcie_init_ringbuffers(struct brcmf_pciedev_info *devinfo)
 {
+	struct brcmf_bus *bus = dev_get_drvdata(&devinfo->pdev->dev);
 	struct brcmf_pcie_ringbuf *ring;
 	struct brcmf_pcie_ringbuf *rings;
 	u32 d2h_w_idx_ptr;
@@ -1254,7 +1263,7 @@ static int brcmf_pcie_init_ringbuffers(struct brcmf_pciedev_info *devinfo)
 	return 0;
 
 fail:
-	brcmf_err("Allocating ring buffers failed\n");
+	brcmf_err(bus, "Allocating ring buffers failed\n");
 	brcmf_pcie_release_ringbuffers(devinfo);
 	return -ENOMEM;
 }
@@ -1277,6 +1286,7 @@ brcmf_pcie_release_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 
 static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 {
+	struct brcmf_bus *bus = dev_get_drvdata(&devinfo->pdev->dev);
 	u64 address;
 	u32 addr;
 
@@ -1316,7 +1326,7 @@ static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 	return 0;
 
 fail:
-	brcmf_err("Allocating scratch buffers failed\n");
+	brcmf_err(bus, "Allocating scratch buffers failed\n");
 	brcmf_pcie_release_scratchbuffers(devinfo);
 	return -ENOMEM;
 }
@@ -1437,6 +1447,7 @@ static int
 brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
 			       u32 sharedram_addr)
 {
+	struct brcmf_bus *bus = dev_get_drvdata(&devinfo->pdev->dev);
 	struct brcmf_pcie_shared_info *shared;
 	u32 addr;
 
@@ -1448,7 +1459,8 @@ brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
 	brcmf_dbg(PCIE, "PCIe protocol version %d\n", shared->version);
 	if ((shared->version > BRCMF_PCIE_MAX_SHARED_VERSION) ||
 	    (shared->version < BRCMF_PCIE_MIN_SHARED_VERSION)) {
-		brcmf_err("Unsupported PCIE version %d\n", shared->version);
+		brcmf_err(bus, "Unsupported PCIE version %d\n",
+			  shared->version);
 		return -EINVAL;
 	}
 
@@ -1490,6 +1502,7 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 					const struct firmware *fw, void *nvram,
 					u32 nvram_len)
 {
+	struct brcmf_bus *bus = dev_get_drvdata(&devinfo->pdev->dev);
 	u32 sharedram_addr;
 	u32 sharedram_addr_written;
 	u32 loop_counter;
@@ -1544,7 +1557,7 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 		loop_counter--;
 	}
 	if (sharedram_addr == sharedram_addr_written) {
-		brcmf_err("FW failed to initialize\n");
+		brcmf_err(bus, "FW failed to initialize\n");
 		return -ENODEV;
 	}
 	brcmf_dbg(PCIE, "Shared RAM addr: 0x%08x\n", sharedram_addr);
@@ -1555,16 +1568,15 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 
 static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 {
-	struct pci_dev *pdev;
+	struct pci_dev *pdev = devinfo->pdev;
+	struct brcmf_bus *bus = dev_get_drvdata(&pdev->dev);
 	int err;
 	phys_addr_t  bar0_addr, bar1_addr;
 	ulong bar1_size;
 
-	pdev = devinfo->pdev;
-
 	err = pci_enable_device(pdev);
 	if (err) {
-		brcmf_err("pci_enable_device failed err=%d\n", err);
+		brcmf_err(bus, "pci_enable_device failed err=%d\n", err);
 		return err;
 	}
 
@@ -1577,7 +1589,7 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 	/* read Bar-1 mapped memory range */
 	bar1_size = pci_resource_len(pdev, 2);
 	if ((bar1_size == 0) || (bar1_addr == 0)) {
-		brcmf_err("BAR1 Not enabled, device size=%ld, addr=%#016llx\n",
+		brcmf_err(bus, "BAR1 Not enabled, device size=%ld, addr=%#016llx\n",
 			  bar1_size, (unsigned long long)bar1_addr);
 		return -EINVAL;
 	}
@@ -1586,7 +1598,7 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 	devinfo->tcm = ioremap_nocache(bar1_addr, bar1_size);
 
 	if (!devinfo->regs || !devinfo->tcm) {
-		brcmf_err("ioremap() failed (%p,%p)\n", devinfo->regs,
+		brcmf_err(bus, "ioremap() failed (%p,%p)\n", devinfo->regs,
 			  devinfo->tcm);
 		return -EINVAL;
 	}
@@ -1873,7 +1885,7 @@ brcmf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	kfree(bus->msgbuf);
 	kfree(bus);
 fail:
-	brcmf_err("failed %x:%x\n", pdev->vendor, pdev->device);
+	brcmf_err(NULL, "failed %x:%x\n", pdev->vendor, pdev->device);
 	brcmf_pcie_release_resource(devinfo);
 	if (devinfo->ci)
 		brcmf_chip_detach(devinfo->ci);
@@ -1947,7 +1959,7 @@ static int brcmf_pcie_pm_enter_D3(struct device *dev)
 	wait_event_timeout(devinfo->mbdata_resp_wait, devinfo->mbdata_completed,
 			   BRCMF_PCIE_MBDATA_TIMEOUT);
 	if (!devinfo->mbdata_completed) {
-		brcmf_err("Timeout on response for entering D3 substate\n");
+		brcmf_err(bus, "Timeout on response for entering D3 substate\n");
 		brcmf_bus_change_state(bus, BRCMF_BUS_UP);
 		return -EIO;
 	}
@@ -1993,7 +2005,7 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
 
 	err = brcmf_pcie_probe(pdev, NULL);
 	if (err)
-		brcmf_err("probe after resume failed, err=%d\n", err);
+		brcmf_err(bus, "probe after resume failed, err=%d\n", err);
 
 	return err;
 }
@@ -2064,7 +2076,8 @@ void brcmf_pcie_register(void)
 	brcmf_dbg(PCIE, "Enter\n");
 	err = pci_register_driver(&brcmf_pciedrvr);
 	if (err)
-		brcmf_err("PCIE driver registration failed, err=%d\n", err);
+		brcmf_err(NULL, "PCIE driver registration failed, err=%d\n",
+			  err);
 }
 
 
-- 
2.20.1

