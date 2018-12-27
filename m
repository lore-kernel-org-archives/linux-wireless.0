Return-Path: <SRS0=u8cq=PE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934D3C43612
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 14:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63D3020873
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 14:05:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RyCdg5/Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbeL0OFm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Dec 2018 09:05:42 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51900 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729614AbeL0OFm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Dec 2018 09:05:42 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so16844963wmj.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Dec 2018 06:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1/CuDaDQerVriTQHpiRoawlGh8I+EFPee65xuDWWdnI=;
        b=RyCdg5/Z4tJ9icKRnvzc3yKHS1vTwwsIP8HXDBWVFFRa2InHet0v8HpVufcKGS6NV4
         g7OPePhZ4Ni6uRS1VkArvDU4b0B9ESMt59av9ConoTvGANGEsdkR80+4ZTM4Q8J8DnZh
         ZaaFf0Ernx5ypkgrE49Suz2y+n7Gw8Z7JdUmIvP8YBPvZMdyvV+oNrhDkW2mZwBS6/nC
         6lKOnEbgsaWtz7+d2T9JxDhqhnKaSA/yAY5nrS5q76E8yMWcWXkyuIokitx8aOfKqWn3
         IvM8oKYmKj55sYV87jqi48QP1AieBW0sZblgvi1/OgUl/YSCW4vpaUhndoO7qBDLFqrM
         A+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1/CuDaDQerVriTQHpiRoawlGh8I+EFPee65xuDWWdnI=;
        b=qtQUrVyotGpTj/pKB93wUY8WnsNJWhp9f3PMrBT2UgJECYopwjvFdqaBFA3mEs36Bm
         eJtx8AfGqFNGs49OWcFj+HsqhJCwe/fXeoScDEfZK9qWvR1t/ipcVgTvFGRG/Z5E/tYX
         JwdR+YqJuXNA80IJ4jIxl8z1tkAEMB9LQlyzZOiJzNdXxGhovPOH70QIeIGS4os+IU9T
         iyK8/Rhd1okoAMX3uvOQQbzV5qSBDln9CT5V+bVG4RrqMhf51pCGUy/n6S5RmUykfVgm
         C847eGqfiU/IXyv88gkVQ95pV/R+mIUfKBnu6SCEvCAOKv9lhtJXHkfZE8GL1EirbS20
         dVzA==
X-Gm-Message-State: AJcUukepmW1eJkQi3SHQNuwJq2/y6xwnJO7h8SgA7JUSqtY0FF4vJ6it
        g9NiveZGkqZ1eXivQ4+j9f7C62HVwnA=
X-Google-Smtp-Source: AFSGD/VFs/N0Ho5URt1OpGhUjOspQxP4oUSzSk58ELd8of4DuMc4XMWY9N0SaS57kOluHQKqnx7jJQ==
X-Received: by 2002:a1c:990c:: with SMTP id b12mr22552746wme.106.1545919539939;
        Thu, 27 Dec 2018 06:05:39 -0800 (PST)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id p6sm38219239wrx.50.2018.12.27.06.05.38
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 27 Dec 2018 06:05:39 -0800 (PST)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, hauke@hauke-m.de, nbd@nbd.name,
        john@phrozen.org, sgruszka@redhat.com, daniel@makrotopia.org
Subject: [PATCH 2/2] rt2x00: define RF5592 in init_eeprom routine
Date:   Thu, 27 Dec 2018 15:05:26 +0100
Message-Id: <1545919526-4074-2-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1545919526-4074-1-git-send-email-pozega.tomislav@gmail.com>
References: <1545919526-4074-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch fixes following crash on Linksys EA2750 during 5GHz wifi
init:

[    7.955153] rt2800pci 0000:01:00.0: card - bus=0x1, slot = 0x0 irq=4
[    7.962259] rt2800pci 0000:01:00.0: loaded eeprom from mtd device "Factory"
[    7.969435] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 5592, rev 0222 detected
[    7.977348] ieee80211 phy0: rt2800_init_eeprom: Error - Invalid RF chipset 0x0000 detected
[    7.985793] ieee80211 phy0: rt2x00lib_probe_dev: Error - Failed to allocate device
[    7.993569] CPU 0 Unable to handle kernel paging request at virtual address 00000024, epc == 800c8f54, ra == 80249ff8
[    8.004408] Oops[#1]:

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 7f813f6..86770e8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -8839,6 +8839,8 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		rf = RF3322;
 	else if (rt2x00_rt(rt2x00dev, RT5350))
 		rf = RF5350;
+	else if (rt2x00_rt(rt2x00dev, RT5592))
+		rf = RF5592;
 	else
 		rf = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
 
-- 
1.7.0.4

