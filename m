Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C92EC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 18:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2097218FE
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 18:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPez2YT0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfCVS7E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 14:59:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41907 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfCVS7E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 14:59:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id p1so3461450wrs.8
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2019 11:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qcdSnDTSowJzKfOwTYCbaCs2fE9AmMZzQfDyywO/xLw=;
        b=NPez2YT05c+LAyKtsD5fnfFI/mIFI1Qak+nnBw2ol2GyUabLMFOyDsoDFzz6ZJ2R2A
         URsx8EXO9gl/AxE7QKgkP+9f+E6CWBt2JA9jVZoDgQ4gzFkjfUS9z1/y5Uf3zIdp/aVo
         DLa6H5M7Q1NxSmwHsFNqRBhOYRgS65JQzl1mjevaf5NC1Hbqq4Bay6mir0IGHyXgRNKU
         vbPqHFAQOraL4GiwlywsBYVTRHWrPe5SIKq724v3fTJMK3fmU2tLYiXj5jrSAlpGReEr
         jcS7WG0p9TwD28TPWvwIb20bxVH82UC4lRp2svfZit95BPcWxGwf2hnJTqKCSCAOKDE1
         +qKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qcdSnDTSowJzKfOwTYCbaCs2fE9AmMZzQfDyywO/xLw=;
        b=Uh+INCiqVVobx7el5whQ/wk79o6CU1wVEkmGUUWF0Ym60x+QSyp1B+AMf0m3QwTlA8
         8VxyiZIBl2SDfVzH8ih0KTxofE680trzlSDhB9DwBtpxox+A3O8Q3D/qoL/nzMKx+dGx
         XDUvGMqGeyfra3BQpwmfKtEeuRiH0+Et8Xo9+y3fD4+u9wAbBcy1kEeNwssrdvDhwiRA
         xe0q340Wa/gDDXQWa6dA7Ur2bI3sgGdMEm+DDSaqIe5DqWFveZhZLwFaiVIxuVf0WyKH
         6ovEi8SnGQ7hgsPTLh63EhEzdsYKukZkM5tJHzd5ZJl8HGVFck47o4cg6C+8XL8lxqRJ
         ujEg==
X-Gm-Message-State: APjAAAUzUH51CA6ON+NcYF6W5m0Een8j0h7ZXy3yzkVBkgDoItCaS+Nn
        BSJWHgnSDT1mxPhH1jXm4kRdyHe5
X-Google-Smtp-Source: APXvYqwgCeaRUDs7BbJK/fjqLAz5OM3F1SPYifNUgUYFFghOFRoPDKSfheEreO4C6kJQ1hGnkaXViQ==
X-Received: by 2002:adf:f80d:: with SMTP id s13mr6608311wrp.38.1553281142741;
        Fri, 22 Mar 2019 11:59:02 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id o8sm6963126wmh.11.2019.03.22.11.59.01
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 22 Mar 2019 11:59:02 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     openwrt-devel@lists.openwrt.org
Subject: [PATCH] ath10k: reset chip after supported check
Date:   Fri, 22 Mar 2019 19:58:40 +0100
Message-Id: <1553281120-22139-1-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When chip reset is done before the chip is checked if supported
there will be crash. Previous behaviour caused bootloops on
Archer C7 v1 units, this patch allows clean device boot without
excluding ath10k driver.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e24403c..ec681da 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3619,12 +3619,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_deinit_irq;
 	}
 
-	ret = ath10k_pci_chip_reset(ar);
-	if (ret) {
-		ath10k_err(ar, "failed to reset chip: %d\n", ret);
-		goto err_free_irq;
-	}
-
 	bus_params.dev_type = ATH10K_DEV_TYPE_LL;
 	bus_params.link_can_suspend = true;
 	bus_params.chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
@@ -3639,6 +3633,12 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_free_irq;
 	}
 
+	ret = ath10k_pci_chip_reset(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to reset chip: %d\n", ret);
+		goto err_free_irq;
+	}
+
 	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
 		ath10k_err(ar, "failed to register driver core: %d\n", ret);
-- 
1.7.0.4

