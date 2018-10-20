Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAE8ECDE3D
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CF8321529
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CF8321529
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbeJTSvI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:51:08 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37255 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbeJTSvI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:51:08 -0400
Received: by mail-wm1-f68.google.com with SMTP id 185-v6so5908703wmt.2
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2SSIxX/qBTZrmnhv7ldQ8v/0b2zPSk6xkpoiJonomBk=;
        b=H9h/Mqn4kGBATPfx2LbZF+m9ds4wvkwEgRmA/zvX9BVvtUXBfklWhVC+EPjRGJf3pS
         Bb1GcACsYyVZ4S5R1KM3S5Jc9a/GVXWkwsDn2QslgCyZFO8lTpE6H3sZe8H5gLLAYE+1
         xuYCvxMa9ayau5PfNkfOvANdCYKWUQ8MLaVv8mrxxB+2snuiFVHLmDNIhdAxQttmFuMf
         6qvExY7gtCgMAmEQM2gf/JNVcIDspWLsZh7pLibFb0YAGtpF/ikKbNoFItbqfP1s6jHk
         ihKzbaBBeVeU/7ef/8FNrmsEse74CmHcwmqIHDzdahYchadBmJfDJbP2deL+uzwmKUOk
         06Mg==
X-Gm-Message-State: ABuFfoh4kmBwqWH7azyDtGrrS6KirbGbtF7d2tLxQFMqhd3/THrbRmmb
        wr9CPm1fKz/fX+IsOhbpiWsGzQ==
X-Google-Smtp-Source: ACcGV60LCEyNE4phaaMiVnNOZQFPvF//bkZjZ6crgb9eNqd9AviN6m8ATMtT0Nhsf5177Jo1xh2vEw==
X-Received: by 2002:a1c:c4cc:: with SMTP id u195-v6mr8377927wmf.120.1540032067170;
        Sat, 20 Oct 2018 03:41:07 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id x17-v6sm23205207wrs.84.2018.10.20.03.41.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:41:06 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mt76x0: update init vals for MT_TX_PROT registers
Date:   Sat, 20 Oct 2018 12:40:53 +0200
Message-Id: <24bc2ec68e59bfdd72f1fc139547b313d9a6d8b2.1540031637.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540031637.git.lorenzo.bianconi@redhat.com>
References: <cover.1540031637.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add missing VHT MT_TX_PROT register init values

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/initvals.h  | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
index 236dce6860b4..a1657922758e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
@@ -37,14 +37,14 @@ static const struct mt76_reg_pair common_mac_reg_table[] = {
 	{ MT_PBF_RX_MAX_PCNT,		0x0000fe9f },
 	{ MT_TX_RETRY_CFG,		0x47d01f0f },
 	{ MT_AUTO_RSP_CFG,		0x00000013 },
-	{ MT_CCK_PROT_CFG,		0x05740003 },
-	{ MT_OFDM_PROT_CFG,		0x05740003 },
+	{ MT_CCK_PROT_CFG,		0x07f40003 },
+	{ MT_OFDM_PROT_CFG,		0x07f42004 },
 	{ MT_PBF_CFG,			0x00f40006 },
 	{ MT_WPDMA_GLO_CFG,		0x00000030 },
-	{ MT_GF20_PROT_CFG,		0x01744004 },
-	{ MT_GF40_PROT_CFG,		0x03f44084 },
-	{ MT_MM20_PROT_CFG,		0x01744004 },
-	{ MT_MM40_PROT_CFG,		0x03f54084 },
+	{ MT_GF20_PROT_CFG,		0x01742004 },
+	{ MT_GF40_PROT_CFG,		0x03f42084 },
+	{ MT_MM20_PROT_CFG,		0x01742004 },
+	{ MT_MM40_PROT_CFG,		0x03f42084 },
 	{ MT_TXOP_CTRL_CFG,		0x0000583f },
 	{ MT_TX_RTS_CFG,		0x00092b20 },
 	{ MT_EXP_ACK_TIME,		0x002400ca },
@@ -85,6 +85,9 @@ static const struct mt76_reg_pair mt76x0_mac_reg_table[] = {
 	{ MT_HT_CTRL_CFG,		0x000001FF },
 	{ MT_TXOP_HLDR_ET,		0x00000000 },
 	{ MT_PN_PAD_MODE,		0x00000003 },
+	{ MT_TX_PROT_CFG6,		0xe3f42004 },
+	{ MT_TX_PROT_CFG7,		0xe3f42084 },
+	{ MT_TX_PROT_CFG8,		0xe3f42104 },
 };
 
 static const struct mt76_reg_pair mt76x0_bbp_init_tab[] = {
-- 
2.19.1

