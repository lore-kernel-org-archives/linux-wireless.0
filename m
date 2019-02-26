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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F8CC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA28E20651
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:11:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZXEVBJP2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfBZNL4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:11:56 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36354 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfBZNLz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:11:55 -0500
Received: by mail-lf1-f67.google.com with SMTP id x206so1574394lff.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2019 05:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fR6S6Qnno7x017ewRlWA+e9Pq5rlzJ9VOVsAW56m6BI=;
        b=ZXEVBJP2p7TeUNhCtmZL7y8Mpc8jp0s80fZX87q/sym+tmAiNiD3zxxb2zIs1l/rkm
         YUXO5nYdqczAgD59VO3tjDO2uZOcyNydqk/PgZaKYdCMk7qRZUs6zYzuVF6MXR6vjq9w
         e/hankF+zPTH+b7K2rNzZ2+s6GpRqcxZBAQ9ynT0XwYLhy6uvhXgXNprcj+IsYi4M7fd
         x4Mn/fD+nnnxoDwDRvsxiWrwKUjGlWaCaErNwDRxztyoo7XLvIwLO8mK0Yw9R4vWC2KE
         TiEmxanxiMQez7LW36tkNqZGlxLSm6k0uGkMUDVOetiACPzIl0rK/sHlDUWrXQy3EYGG
         6bHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fR6S6Qnno7x017ewRlWA+e9Pq5rlzJ9VOVsAW56m6BI=;
        b=lFYxg7FeVwx/p3wwoHvHXORSe80xZSu44VcAejNfMhNbxht+ZTA+8ZtSLfuKykDfPH
         aQk543GdwUYpTZ7VCkugSc32dvJWkoJY7iltrXvnwTXtExiq31UOx2xw7guiTRjJiVzX
         qemGPcrtBoC5p/CIIaIzal6MMLv7g5GopTGX3yRMtMLCFdxdZEOp7sF7Z/QGHM37ZCjN
         KU6pL12Xey/kojFF2SyDyw3NUvvzF80OSs1fk/lRUlO08PJvViBqn6Ag0Jzksm4Q2zLH
         29W7bclf468MNkxaDX2XRw+qG6S/RXcV5wD58v6tgLwTdJv1YA5Gs1qacauMCq8gyQIn
         vv7w==
X-Gm-Message-State: AHQUAuYX3xoXowr5hYkheAOHAyAGE6bFfd0Dq7N8BprsHIsKUrzDP0h3
        +kyiPH7Agxtb2dx5BAOHzTY=
X-Google-Smtp-Source: AHgI3IZPBjN4V+SNwtNx9RCiCc8lrrORx5ruEilxvGIDr7EvK7rjB4SRNK38BYUjadpr4IrfkUfFuQ==
X-Received: by 2002:a19:e601:: with SMTP id d1mr14441897lfh.71.1551186713824;
        Tue, 26 Feb 2019 05:11:53 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f16-v6sm2952518lji.88.2019.02.26.05.11.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 05:11:53 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 2/4] brcmfmac: get RAM info right before downloading PCIe firmware
Date:   Tue, 26 Feb 2019 14:11:17 +0100
Message-Id: <20190226131119.7907-3-zajec5@gmail.com>
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

It's important as brcmf_chip_get_raminfo() also makes sure that memory
is properly setup. Without it the firmware could report invalid RAM
address like 0x04000001.

During a normal brcmfmac lifetime brcmf_chip_get_raminfo() is called on
probe by the brcmf_chip_recognition(). This change allows implementing
further improvements like handling errors by resetting a device with
the brcmf_pcie_reset_device() and redownloading a firmware afterwards.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 6 ++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 6 ++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 22534bf2a90c..fcaf19165891 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -707,8 +707,10 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	return 0;
 }
 
-static int brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
+int brcmf_chip_get_raminfo(struct brcmf_chip *pub)
 {
+	struct brcmf_chip_priv *ci = container_of(pub, struct brcmf_chip_priv,
+						  pub);
 	struct brcmf_core_priv *mem_core;
 	struct brcmf_core *mem;
 
@@ -990,7 +992,7 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 		brcmf_chip_set_passive(&ci->pub);
 	}
 
-	return brcmf_chip_get_raminfo(ci);
+	return brcmf_chip_get_raminfo(&ci->pub);
 }
 
 static void brcmf_chip_disable_arm(struct brcmf_chip_priv *chip, u16 id)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
index 0ae3b33bab62..4794cf38b4d3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
@@ -80,6 +80,7 @@ struct brcmf_buscore_ops {
 	void (*activate)(void *ctx, struct brcmf_chip *chip, u32 rstvec);
 };
 
+int brcmf_chip_get_raminfo(struct brcmf_chip *pub);
 struct brcmf_chip *brcmf_chip_attach(void *ctx,
 				     const struct brcmf_buscore_ops *ops);
 void brcmf_chip_detach(struct brcmf_chip *chip);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 58a6bc379358..39f6421885f6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1727,6 +1727,12 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 	nvram_len = fwreq->items[BRCMF_PCIE_FW_NVRAM].nv_data.len;
 	kfree(fwreq);
 
+	ret = brcmf_chip_get_raminfo(devinfo->ci);
+	if (ret) {
+		brcmf_err(bus, "Failed to get RAM info\n");
+		goto fail;
+	}
+
 	/* Some of the firmwares have the size of the memory of the device
 	 * defined inside the firmware. This is because part of the memory in
 	 * the device is shared and the devision is determined by FW. Parse
-- 
2.20.1

