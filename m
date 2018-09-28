Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF9FC04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 612CB21746
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 612CB21746
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbeI1NCz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37807 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbeI1NCz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:55 -0400
Received: by mail-wr1-f67.google.com with SMTP id u12-v6so5070147wrr.4
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RWJPzrnyWPdsHpuvh6k3Pkui1vkX49ovcjQ8HtYm45Q=;
        b=ChEbg+i0ZjY75Unjfp7Oee65mQC8L7fNVpIR/a8h6XK51cwBwOMvfbfqdPGkrsqLa2
         x/Ocii09Kl6zBk4CgGEF77pnlg0SrD/efnc2vgGdFRO72AZ21xQse2a5Lh+HIfUMBAoS
         nWfH51ztWyq0BTp1/Uta7hHCubDFHxYzvVRC+tLwu4Ic/+PuRoyy8LZUiojf4ZtPmCbl
         wXpMx7uwMK+Z8WmmrQ/EzDKEkO+rh/Jb390Vb4zvuphLWX7z30+HqSxywMfniBtiJ3bk
         gOIKdOER1bFsM/X5BU1xiL9ZYjAr7yode1Iv8J+RtAg4qu14HQwez15Vm6LN1BSB3sHM
         3o7w==
X-Gm-Message-State: ABuFfogCb57kqa4zp5ZzyD8TE+M9BVslhVI5BMRrgUL+nSTwIVp/1nBN
        5f/sxeKcIdiD42qO/6Vaob5BpjYfVkQ=
X-Google-Smtp-Source: ACcGV62QhXw2NuW4pmqztB4D+7qiu9mpInpBWPywNGf+8ri+SUZLmyihjb4Bz+PakCE4/xSwyI9c+w==
X-Received: by 2002:adf:e607:: with SMTP id p7-v6mr3544298wrm.254.1538116841632;
        Thu, 27 Sep 2018 23:40:41 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:41 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 13/24] mt76x0: init: remove duplicated initialization
Date:   Fri, 28 Sep 2018 08:40:06 +0200
Message-Id: <20180928064017.26870-14-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index d7525fcc9f0d..201eb5870269 100644
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
2.19.0

