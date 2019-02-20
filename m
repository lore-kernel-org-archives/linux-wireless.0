Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 171D3C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DED002086A
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:31:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gK28b5tn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfBTKbD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:31:03 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42989 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbfBTKbD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 05:31:03 -0500
Received: by mail-lj1-f195.google.com with SMTP id d14so9160105ljl.9
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2019 02:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jTH4h8NYY/GPpagkmifVcrICWQ9e9yR4IZoOrfdP/7I=;
        b=gK28b5tne64+LsdvEkKr5B0gi50nPXkAsBGbsv4LaXkhOsAhghRjYXDXU8kbPRnbbo
         IDlx+/h4Jnr15Q50ADLZi2BhVfUtxpfx1RdR+/16n0nXKewOy03gDas0Fp+g7rX8m195
         A70lCBCuvVUYxWpKzK6rCmet6nrSvAxoXEValDGFUB5dICyyAUme3yACxBLndpwCEc+P
         XV+jpAAgsKpRLJLa+Q4bW2JU41SbB43f5cI/o2nJtXqejwIfsHV5rD1UApxMa6RsT+6x
         PLDguXMaGhsC7wN5tDbyFlSHY8oqHCroihRorp18egqg6S4T/El/bYXMrLTv2Wigj+/4
         luKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jTH4h8NYY/GPpagkmifVcrICWQ9e9yR4IZoOrfdP/7I=;
        b=dyQfrcttH1gC7WBYivNmuWU5YffnTiFJikHcRNKM7hKez+IKbO53qUj2FVtxvCaB+E
         FKZLrVMX7vxJYfgPGMLy1I7M5CG1D9Czq/N8RJhx+1W6pjokbD9zP5BszTMPEVBY+56F
         LylTFWDwLGvR5ZzJKgvLEphBpQiiZs0pX7FhY4uZpdiKaQ1TfxzgxS6Po2wlCKs8lw6L
         58v7Dz5cVOtD0kvBiaa6T++DmXxZ2aZSFA4PtM5mAlzWrQ4rQcC5wS+Bja7aQuNyJzC3
         hMJ6Cep1PlOmoaCTx9FNWEdXUE2C0nwiiuzpypLKnSuFeSxXPit6Ew7w4HNgzwhZMRsa
         dUzw==
X-Gm-Message-State: AHQUAubJ2wXWrQ5QrPpe4viP7Si3eWI5ZQ8i4e668JUDeA8+fbOvrZtA
        1YI6L6MHcd1UgfkltT91OtU=
X-Google-Smtp-Source: AHgI3Ib7x1qb3AK5qo1X7qPu0O/zO6bmxmPWTacWuvKnmM1JxQK8IelJgfDRhFmHaDFDFZAlfOYDtg==
X-Received: by 2002:a2e:9e93:: with SMTP id f19-v6mr20504814ljk.122.1550658661278;
        Wed, 20 Feb 2019 02:31:01 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id p3sm4033664ljj.14.2019.02.20.02.31.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Feb 2019 02:31:00 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH wireless-drivers-next] brcmfmac: add basic validation of shared RAM address
Date:   Wed, 20 Feb 2019 11:30:47 +0100
Message-Id: <20190220103047.8960-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

While experimenting with firmware loading I ended up in a state of
firmware reporting shared RAM address 0x04000001. It was causing:
[   94.448015] Unable to handle kernel paging request at virtual address cd680001
due to reading out of the mapped memory.

This patch adds some basic validation to avoid kernel crashes due to the
unexpected firmware behavior.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 257f919c52cc..58a6bc379358 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1560,6 +1560,12 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 		brcmf_err(bus, "FW failed to initialize\n");
 		return -ENODEV;
 	}
+	if (sharedram_addr < devinfo->ci->rambase ||
+	    sharedram_addr >= devinfo->ci->rambase + devinfo->ci->ramsize) {
+		brcmf_err(bus, "Invalid shared RAM address 0x%08x\n",
+			  sharedram_addr);
+		return -ENODEV;
+	}
 	brcmf_dbg(PCIE, "Shared RAM addr: 0x%08x\n", sharedram_addr);
 
 	return (brcmf_pcie_init_share_ram_info(devinfo, sharedram_addr));
-- 
2.20.1

