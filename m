Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5467FC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E930208D9
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:21:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E930208D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbeJAU7G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:59:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41108 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729749AbeJAU7F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:59:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id j15-v6so14176455wrt.8
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 07:21:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y6bC53qgv8afpPYUfnR9/L3HFFkLMo6QmDvmN6dhI3w=;
        b=oyhFaV90v2eiQGEIhr4w6fnVlo0lzafXARV5XZI2ufCIG7R5vc7ZnmtfOmoOVj8ZFQ
         CxJMA6IeGrP3EiwprLdEpu31SAiHYp2zcvWq62hzWqv3pItWzpQspne2rDNP8zPnDRr3
         bP3/X7NHk2iKd4lChNUy/iZlT1eVoBvaA4NANlBcc8BvFRxLC0eaJZK3ovnApY37lFm5
         /djNeAdF5P1I7ihZFmc1zV469UzHq+3vEBa8kj534ja+kQw1jkMu7zS6phVlvqqBBevt
         aL231Zuqf/bM3iychTodERhEk5CWXWO+PUI6RQzGAwEaR1CoYdJQDbMrMV8o2rKqqw0g
         ZDOg==
X-Gm-Message-State: ABuFfohQHfkstV8HdX/vUjIBDMnlB+FGPA95e5Q1opoResNLNcvWIRuH
        XvwRVLz+oRecyc0TIb8MINpxiKLrn5Q=
X-Google-Smtp-Source: ACcGV60gcbmdD4CbtSUW3c+Ys2TrRpAfqAKBnaNxW9c1wKvxC89WRvGJPiom/6xoCXhEjuiPTIDRgg==
X-Received: by 2002:a05:6000:12c5:: with SMTP id l5mr6018210wrx.215.1538403661613;
        Mon, 01 Oct 2018 07:21:01 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r16-v6sm1292372wrv.21.2018.10.01.07.21.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Oct 2018 07:21:00 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2] mt76x0: init: remove unnecessary configurations
Date:   Mon,  1 Oct 2018 16:20:49 +0200
Message-Id: <4c7c809d3af118f388e6140b6570a94a63dbc133.1538403562.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538403562.git.lorenzo.bianconi@redhat.com>
References: <cover.1538403562.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove leftover configuration for legacy devices in
mt76x0_init_mac_registers routine. Moreover remove
unnecessary msleep delay

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
Changes since v1
- remove msleep delay
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index edfd5d94d197..d64594205491 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -172,12 +172,6 @@ static void mt76x0_init_mac_registers(struct mt76x0_dev *dev)
 	reg &= ~0x000003FF;
 	reg |= 0x00000201;
 	mt76_wr(dev, MT_WMM_CTRL, reg);
-
-	/* TODO: Probably not needed */
-	mt76_wr(dev, 0x7028, 0);
-	mt76_wr(dev, 0x7010, 0);
-	mt76_wr(dev, 0x7024, 0);
-	msleep(10);
 }
 
 static int mt76x0_init_wcid_mem(struct mt76x0_dev *dev)
-- 
2.17.1

