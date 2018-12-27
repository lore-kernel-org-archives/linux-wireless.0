Return-Path: <SRS0=u8cq=PE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBA5C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 14:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 374192148D
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 14:05:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N78BHSW8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbeL0OFk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Dec 2018 09:05:40 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40863 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729469AbeL0OFk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Dec 2018 09:05:40 -0500
Received: by mail-wr1-f66.google.com with SMTP id p4so18360549wrt.7
        for <linux-wireless@vger.kernel.org>; Thu, 27 Dec 2018 06:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=if95ASzOCk1n4rkrJMt0dbDI3WwTIiBNPf8RvdMIJm8=;
        b=N78BHSW85OAzpxBdY2OozZyZYjAg6qKOe0l4D2qxSMPfU6K1kgB9f8YZs5Owl9wPyh
         RC88Px2yQIdVDsFm3Kww1hEalZ+bN2zLqb5+mOWGMXJyEz7VHfWg6+hpYTjHMVohLkg5
         /+OqTEwl8P17YhXJ0KdEk0aHkt4uSi19pLqD+Jp6SzPPnIY+mx6ODeIAWHi3VH6alfre
         plMwZa2EAMcOUCDCygy5ShCJWhXhdeL51VIfYowahUv7xowfw7o5b1+ZihX/DoKGuvHC
         hNQAg9QvDOj6lqHyynD9V0pMgGYSVx2g6MPA8uH3vceV1/vgSkaWTxboyiUylHrlMdIo
         xZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=if95ASzOCk1n4rkrJMt0dbDI3WwTIiBNPf8RvdMIJm8=;
        b=EyuukiKyMQhAsnvAdNATiSxgngxugcTEOlzcC2eOk78pzv8aNJdhWE3+cJLyh1ctj1
         Z/BoIXM298pOrkekyhEZsOnxwGO1p6mrgCBXdoANHvMk93fKtlYT8zNkMZdk6zdXSqBw
         bSm8fD5pgGqoLBJH0swL1lrRkHUXSsBsQgCg1YQegfYoWCgdhAnKYmj3OJca5jqfTlJq
         pL84CtNEgx9GiXNvsaTU8LeFmKU4GVoMmewsR9WRmw9zSoouDXciq0DHtAoBeElHlCjZ
         /8LJQvSLqhONn5xIcFjUdsq3KcqZkCQedwF8WkwVgcA8uksMyKKH0Fj5txHAkeXIyHX3
         IhpA==
X-Gm-Message-State: AJcUukdCD27qMfzN5D3LfBblTlOINVVf3zsHMXqUaYwCxv/GoSStqEqb
        ha65rhfifdjaR9/NVSakmWv3ZuEByO4=
X-Google-Smtp-Source: ALg8bN4sgpNxIiBIAhaU8qSDeso9A0BqyR3EIwbO8UwBaShVrZZ2nAmG7p6zo63420r8KRFPizaXQA==
X-Received: by 2002:a5d:47d1:: with SMTP id l17mr21936207wrs.319.1545919538745;
        Thu, 27 Dec 2018 06:05:38 -0800 (PST)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id p6sm38219239wrx.50.2018.12.27.06.05.37
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 27 Dec 2018 06:05:38 -0800 (PST)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, hauke@hauke-m.de, nbd@nbd.name,
        john@phrozen.org, sgruszka@redhat.com, daniel@makrotopia.org
Subject: [PATCH 1/2] rt2x00: reduce tx power to nominal level on RT6352
Date:   Thu, 27 Dec 2018 15:05:25 +0100
Message-Id: <1545919526-4074-1-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Current implementation of RT6352 support provides too high tx power
at least on iPA/eLNA devices. Reduce amplification of variable gain
amplifier by 6dB to match board target power of 17dBm.
Transmited signal strength with this patch is similar to that of
stock firmware or pandorabox firmware. Throughput measured with iperf
improves. Device tested: Xiaomi Miwifi Mini.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 0e95555..7f813f6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5477,7 +5477,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
 		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
 		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
-		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x06060606);
+		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX0_BB_GAIN_ATTEN, 0x0);
 		rt2800_register_write(rt2x00dev, TX1_BB_GAIN_ATTEN, 0x0);
 		rt2800_register_write(rt2x00dev, TX0_RF_GAIN_ATTEN, 0x6C6C666C);
-- 
1.7.0.4

