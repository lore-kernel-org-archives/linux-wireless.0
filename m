Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E184C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A0892172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A0892172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbeI1NC5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53879 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728958AbeI1NC4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id b19-v6so1034023wme.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C5nm4rGjDsk9tYQo8YpDdXVOGtXk0wjlqzI3Qsrcwbc=;
        b=TwT7m2iJEkPW0t3uqSG8XDbA86Sfe9dh/L9+O7KKsdFhgASJIIhzHG7YvSW9brccwO
         ecaiJw7RRS6o1z7aXnwf2wl7e04UqD+gxqhZKnlutqnODq89AxQF+MIJty4Cqc5j5oCt
         QyJvFmEZjVa4qPDLuYHhZqLqAN3+yrMHMSYAqDo4v+yvMFgZbPEvkQlJb4iuO/N9qWae
         uP7o02HuLKildi+DoXKU41PnOT5N9qgLM6KaeXFBXI1O3p+VQg1hAbDCYTqWKAnMf4tw
         gIoYlT/qLRbaCAwufQBADGUM27OCCOfr4HPLtZautWiUTSKyehiHcdlWJFQweABo33lD
         6LUA==
X-Gm-Message-State: ABuFfogvWKmWxK9oRIO0gfKyzLtSamk/qzuy92kkLeeYxrNUy9MF5HeD
        ap6X9DRP7AC+oBjtz+A6H1uUdg==
X-Google-Smtp-Source: ACcGV61kSt8IUbqShZ4NM53Jk3DDU9rI9dXFjNga4smIrQ4OaRyt4hidNP06VsxG11mc81wr5DPvCA==
X-Received: by 2002:a1c:2905:: with SMTP id p5-v6mr661618wmp.1.1538116842713;
        Thu, 27 Sep 2018 23:40:42 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:41 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 14/24] mt76x0: init: remove MT_PBF_SYS_CTRL configuration in mt76x0_reset_csr_bbp
Date:   Fri, 28 Sep 2018 08:40:07 +0200
Message-Id: <20180928064017.26870-15-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove MT_PBF_SYS_CTRL configuration in mt76x0_reset_csr_bbp since
it is already initialized in mt76x0_init_mac_registers routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 201eb5870269..b0e067114dce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -103,15 +103,9 @@ EXPORT_SYMBOL_GPL(mt76x0_chip_onoff);
 
 static void mt76x0_reset_csr_bbp(struct mt76x0_dev *dev)
 {
-	u32 val;
-
-	val = mt76_rr(dev, MT_PBF_SYS_CTRL);
-	val &= ~0x2000;
-	mt76_wr(dev, MT_PBF_SYS_CTRL, val);
-
-	mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_RESET_CSR |
-					 MT_MAC_SYS_CTRL_RESET_BBP);
-
+	mt76_wr(dev, MT_MAC_SYS_CTRL,
+		MT_MAC_SYS_CTRL_RESET_CSR |
+		MT_MAC_SYS_CTRL_RESET_BBP);
 	msleep(200);
 }
 
-- 
2.19.0

