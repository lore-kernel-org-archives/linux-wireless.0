Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E180BC2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 14:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0D342082D
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 14:12:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0D342082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbeJ2XB0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 19:01:26 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35956 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbeJ2XB0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 19:01:26 -0400
Received: by mail-wm1-f66.google.com with SMTP id a8-v6so8096475wmf.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2018 07:12:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3x+ZbZ8mfhzYuE2cCr/XX5QsenMExSkzOi3Uzf6QS2c=;
        b=dfnzDZzi+AcYezw9gC3n01q0WMw+cVed47hQDGKXoYdgtzO95p0z/mzINJdwoY6Vj+
         MlFsq265U2EIoRrpXaofJ8nArvxsF7BAIlKXptAvJ0DfOm70Pn8PBPHk68Vt/lMKVzCi
         6a9VKFcnAtZmNMg++zyvKANhEiMExDRPQxIIqLhXR5cmaUfRpeqB2uKPF4Z9E0BLHjsH
         cG+MrZ2lJHNF5seG4/xUfBAQiblYFu4etMfv9NBdbAfTRexFkRSv7fnvuuyy5+dyNTM1
         XSfbIBdYZTWUaiJ3py6QwUFFeWu2jGAFqVbGBN7Yv4ydQh8DZQSloE/Pp4GGq6rC3Lmp
         OMDQ==
X-Gm-Message-State: AGRZ1gJW54Q2m6XKq47Ib9h89tFuK3woaoZbUeXY1jIdia8pzEe7tkBP
        U00CG/J11iBQoiar6LKhHJZnSA==
X-Google-Smtp-Source: AJdET5c6U7+fpQdgSQhKu9nTDKrgEvKAtri50LVZsXbtSrbJp/Q7/76rgH1f24fVBwnHK4P9nAZ7yQ==
X-Received: by 2002:a1c:6483:: with SMTP id y125-v6mr13203228wmb.66.1540822355518;
        Mon, 29 Oct 2018 07:12:35 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id o17-v6sm31412559wro.2.2018.10.29.07.12.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Oct 2018 07:12:34 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2u: init: remove not useful configuration
Date:   Mon, 29 Oct 2018 15:12:22 +0100
Message-Id: <8d4811ae301d72e36dd8143b90629784fcf2289f.1540821963.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1540821963.git.lorenzo.bianconi@redhat.com>
References: <cover.1540821963.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove MT_TSO_CTRL and MT_HEADER_TRANS_CTRL_REG initialization since
it is already done in mt76_write_mac_initvals routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index a7d591610f16..c338ac0433ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -191,9 +191,6 @@ int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 	if (!mt76x02_wait_for_mac(&dev->mt76))
 		return -ETIMEDOUT;
 
-	mt76_wr(dev, MT_HEADER_TRANS_CTRL_REG, 0);
-	mt76_wr(dev, MT_TSO_CTRL, 0);
-
 	mt76x2u_init_dma(dev);
 
 	err = mt76x2u_mcu_init(dev);
-- 
2.17.2

