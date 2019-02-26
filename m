Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80E8C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6D3820651
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:12:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BA6p9a7I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfBZNL7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:11:59 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37337 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfBZNL6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:11:58 -0500
Received: by mail-lf1-f66.google.com with SMTP id z196so8891377lff.4
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2019 05:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jng1uOZNBVq9j3PPM2U2Wcz60YlWQy6CcHxqFFVm1is=;
        b=BA6p9a7IDuq6xHPZ99C2YH4Sybfu4xhki6IgP5dDXnYHQdOB1sVkUpEuobU1b/OfBf
         PRRt+fE66wuJ/qwBnJKt0nnwxkwZUTxPib2X5e25qQOeC/6iQ33FSBaYpcWAXwkVkQUR
         SIJPvDNgjS7yr2QPTo7pz9REVK7H4a4IThiWMdXKuAAok9IvDTrtl3vSiCzjjd/BQc+z
         KSglo9e1fNc12RGl73bn39ImLHAI71vhGpypvg63KdXjDsYZZcrEzIeqAkTkJ5+r84F2
         0QlrFa7W+aV6vzRAiFn+To9NOYhfXLxcwWZ8GI1zcemXRDv6lMdVGGHSyQ2c6w0kUikc
         jeZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jng1uOZNBVq9j3PPM2U2Wcz60YlWQy6CcHxqFFVm1is=;
        b=fva7iGzmQGXl8NPxGPmJ4xuzg3Mmnz8kISejzsyQscxUMa1mxkKDFC7R9u2XRMB+Ay
         SJvIZttMcznKNCXSTrJ2ClWo9iIR9bQI/dwMjfDZuSXLgue4jktzpBzfXfTSYm3JFHld
         XlPf+ivRfvC5dXxUvWlSAL6qRx6SHipUeAVR1kgSllAcPCONRhvkIS7jjnodOuYDO/XQ
         tuGTQ9wT6K2qZLvZM+ziiULm1Kpt0NXigjfUv7sBIEJ+QD7ONTl/fw6w8g9Fisx0KTId
         7tbPamdL31A46zUNNdV0Ogr2jO3Lw1naZOACnSec/DMt2GHVRib8MfwXhKdbWEjSDFbJ
         OwWw==
X-Gm-Message-State: AHQUAuZeRj7eu+R5Nnw3q9ldMYPcDQXnif/fNjGveqIpaM5ceo6qRjxP
        jIMT77mfs8GmKaWzR40Ik1A=
X-Google-Smtp-Source: AHgI3IZ0k1NfOGmtKf5ecCfoxUnlLLb4yVIXI7uoAuKgNQBp4jMw184aeiztB26FKw0BUTv8965E0A==
X-Received: by 2002:a19:c616:: with SMTP id w22mr12775515lff.31.1551186716079;
        Tue, 26 Feb 2019 05:11:56 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f16-v6sm2952518lji.88.2019.02.26.05.11.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 05:11:55 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 3/4] brcmfmac: add a function designated for handling firmware fails
Date:   Tue, 26 Feb 2019 14:11:18 +0100
Message-Id: <20190226131119.7907-4-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190226131119.7907-1-zajec5@gmail.com>
References: <20190226131119.7907-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This improves handling PCIe firmware halts by printing a clear error
message and replaces a similar code in the SDIO bus support.

It will also allow further improvements like trying to recover from a
firmware crash.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  2 ++
 .../net/wireless/broadcom/brcm80211/brcmfmac/core.c    | 10 ++++++++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  4 ++--
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 3d441c5c745c..801106583ae7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -262,6 +262,8 @@ void brcmf_detach(struct device *dev);
 void brcmf_dev_reset(struct device *dev);
 /* Request from bus module to initiate a coredump */
 void brcmf_dev_coredump(struct device *dev);
+/* Indication that firmware has halted or crashed */
+void brcmf_fw_crashed(struct device *dev);
 
 /* Configure the "global" bus state used by upper layers */
 void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 4fbe8791f674..7f4d9356b79e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1273,6 +1273,16 @@ void brcmf_dev_coredump(struct device *dev)
 		brcmf_dbg(TRACE, "failed to create coredump\n");
 }
 
+void brcmf_fw_crashed(struct device *dev)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+
+	bphy_err(drvr, "Firmware has halted or crashed\n");
+
+	brcmf_dev_coredump(dev);
+}
+
 void brcmf_detach(struct device *dev)
 {
 	s32 i;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 39f6421885f6..cfa34672315f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -730,7 +730,7 @@ static void brcmf_pcie_handle_mb_data(struct brcmf_pciedev_info *devinfo)
 	}
 	if (dtoh_mb_data & BRCMF_D2H_DEV_FWHALT) {
 		brcmf_dbg(PCIE, "D2H_MB_DATA: FW HALT\n");
-		brcmf_dev_coredump(&devinfo->pdev->dev);
+		brcmf_fw_crashed(&devinfo->pdev->dev);
 	}
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 4d104ab80fd8..a06af0cd4a7f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1090,8 +1090,8 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 
 	/* dongle indicates the firmware has halted/crashed */
 	if (hmb_data & HMB_DATA_FWHALT) {
-		brcmf_err("mailbox indicates firmware halted\n");
-		brcmf_dev_coredump(&sdiod->func1->dev);
+		brcmf_dbg(SDIO, "mailbox indicates firmware halted\n");
+		brcmf_fw_crashed(&sdiod->func1->dev);
 	}
 
 	/* Dongle recomposed rx frames, accept them again */
-- 
2.20.1

