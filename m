Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33001ECE561
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E352121580
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E352121580
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbeI0PT2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43846 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbeI0PT2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id z14-v6so1680060wrs.10
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3hxuk7PlkZ6Iht7kOcfBQHxZSHKIe7i+J5Ani14CkBI=;
        b=ublxptGVspi6mAgTQFXM2PSEQfLs7bq2wdcS2+CIElhHW+8VVMtNoEJBYmlH5qT//Q
         4gjDfsvWj3qW6PhZ1ePxjcXQO0vRkpOYvSwEY9vorQF0K6hNRFssTYw1h26TFe+7GE9d
         UKAYxYbay3IFpV4BxC9J91tryA8HMUlEV2MbnsKwQMgb/jULq0V1EK6Gqc7A55zgHt4j
         JcXkLqLBTp0YT23K1Be3FS/Ul68tg9GZPvnqYce6e8B2TGFqBu1lbBXU+FXNrKjb7vz8
         +9l3E2BT3OtzYvNCCQLbyuo6smVMRa3GxtRxbQV7DEJJLlHVFx6YMKX8vaDSg3n3hfsX
         7aZA==
X-Gm-Message-State: ABuFfogCqtBmsXYyxQXeP+aG5yDBi2b45FkXKyGETO/v6LjanTBaq1W1
        QzcZewVpiCtjQGCTE+T6k3RLiw==
X-Google-Smtp-Source: ACcGV636Y4nu2sy3XhNEXAFgmK9ZYJi2chWV0LlTk64EDvttK4MrJ/Nti8hj04ug0ImerdEz82TssQ==
X-Received: by 2002:a05:6000:100f:: with SMTP id a15mr7776367wrx.271.1538038934672;
        Thu, 27 Sep 2018 02:02:14 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:13 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 13/26] mt76x0: init: remove duplicated initialization
Date:   Thu, 27 Sep 2018 11:01:42 +0200
Message-Id: <b3b279dee9a7184dd84b5da72c8d2a932013e6e1.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove MT_HEADER_TRANS_CTRL_REG/MT_TSO_CTRL configuration
since they are already initialized in mt76x0_init_mac_registers
routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 35aa2d8fae81..f04fd0163f94 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -363,9 +363,6 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 	mt76x0_reset_csr_bbp(dev);
 	mt76x0_init_usb_dma(dev);
 
-	mt76_wr(dev, MT_HEADER_TRANS_CTRL_REG, 0x0);
-	mt76_wr(dev, MT_TSO_CTRL, 0x0);
-
 	ret = mt76x02_mcu_function_select(&dev->mt76, Q_SELECT, 1, false);
 	if (ret)
 		return ret;
-- 
2.17.1

