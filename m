Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C372FC4338F
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Aug 2021 17:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7D6160527
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Aug 2021 17:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhHLRDk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 12 Aug 2021 13:03:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37181 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234363AbhHLRDh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Aug 2021 13:03:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628787792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J954MLxa9gOHhPQ2vkkolUzmWyf9ox971ksqXH7Ids8=;
        b=enW7iMNkHW1Cii4xdOwLIBkPD7ci6Z/lLH6WhCbw42G19T8G3OOenj23ycafhuz43E0Uu+
        9GDyFlN57xCNMSfxGl3Sd29LMz5/+iYtcNOnNft1TS9SVsPYARMBW8Py2q/IU8Qd7nZ60E
        sCSaYdBB48gpYbaelEpye6g9v+VmXL0=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-ublCGPPrMV2Pk8RS040xYg-1; Thu, 12 Aug 2021 13:03:09 -0400
X-MC-Unique: ublCGPPrMV2Pk8RS040xYg-1
Received: by mail-oi1-f199.google.com with SMTP id c6-20020aca35060000b029025c5504f461so3130051oia.22
        for <linux-wireless@vger.kernel.org>; Thu, 12 Aug 2021 10:03:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J954MLxa9gOHhPQ2vkkolUzmWyf9ox971ksqXH7Ids8=;
        b=kAp0LrfbDbG+NVmGjGc0oVFKvQA+00WD2oYZSMxWjjWkn2oNKrwFVXzv+1sWttrrcU
         5bLhloDymY7u/pAwaUtF8txg2Ak7zeGt11NDZzv7H2k4asXwg0XZ3rjNkj0WmXUK7pGo
         efkbmMBuaB/jejgKCPPTBkJXzf+DphhoBOO5OXsdB8qyleYRMJSUSt1ieKDKcykeR0+9
         nu0ul6xtRp317DRE9sAiq3lJSd/L9MREdMgESGBk1VTKgwlriN6JQ53nTEYnJguDpG9p
         qFNgkCgZxTxdXP4r6wVdHnYhvqDY7uuQqbM1QGVkKs3d1inbFyCZp9Xz0eXSQYGtphqf
         u2vA==
X-Gm-Message-State: AOAM530Bu8YdYXE/IO0Ym30PEUdQtkQ0cdYWAtmLWJGmtdsOq2Fu4v39
        1uD9Im6TCGsfOnDJb3k0cvrefMFQORaQ7GoqznCaEAXk0kUe9YW5vTE5lEnCz+Bh7DsQxHiYNTJ
        aC4WTjAk93a1Ka50Mwi1s4En1IiM=
X-Received: by 2002:a05:6830:11d4:: with SMTP id v20mr4113240otq.358.1628787789326;
        Thu, 12 Aug 2021 10:03:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykzvJTl7IgT9ugEjGH3GRxKniSCfzdb1tXmDjHVTSGHXjRu3xi7zcEhXGhRmIzmuNwDKlWyw==
X-Received: by 2002:a05:6830:11d4:: with SMTP id v20mr4113216otq.358.1628787789169;
        Thu, 12 Aug 2021 10:03:09 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id g20sm733386otj.9.2021.08.12.10.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 10:03:08 -0700 (PDT)
From:   trix@redhat.com
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        zhengyongjun3@huawei.com, linus.walleij@linaro.org,
        lee.jones@linaro.org
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] brcmfmac: Fix fallback logic to use firmware's canonical path
Date:   Thu, 12 Aug 2021 10:03:00 -0700
Message-Id: <20210812170300.1047330-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Static analysis reports this problem
firmware.c:709:6: warning: Branch condition evaluates to a garbage value
        if (ret) {
            ^~~

In brcmf_fw_get_firmwares(), ret is only set if the alt_path control
flow is taken.  Initialize ret to -1, so the canonical path is taken
if alt_path is not.

Fixes: 5ff013914c62 ("brcmfmac: firmware: Allow per-board firmware binaries")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index adfdfc654b104..e11f1a3a38a59 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -680,7 +680,7 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 	struct brcmf_fw_item *first = &req->items[0];
 	struct brcmf_fw *fwctx;
 	char *alt_path;
-	int ret;
+	int ret = -1;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(dev));
 	if (!fw_cb)
-- 
2.26.3

