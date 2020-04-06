Return-Path: <SRS0=FAUf=5W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6388C2BA19
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Apr 2020 12:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F008208E4
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Apr 2020 12:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="NKrsGpqL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgDFMFC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:05:02 -0400
Received: from nbd.name ([46.4.11.11]:35488 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbgDFMFB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Apr 2020 08:05:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dyMsA4uHqgq9WTBI6tCsEhKaBVf+ETwutw6Dp+JJp5g=; b=NKrsGpqLQ8dnh4WicKninBNiMh
        dJXqkWNkU2LWaSqsnopXlogFiOZRQkJyAJTsYIoRmeGl9fjlKGMKX6yoKIpdwklGBpUfBDO5jNZeo
        k0gSIuc4ElE0GGhTXIhv/+AC3LvPaWuE5kmyr2KVPPCPWyHgg2uX8auvr1H3PjKNVqZ4=;
Received: from [80.255.7.105] (helo=maeck.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1jLQUu-0008NQ-NW
        for linux-wireless@vger.kernel.org; Mon, 06 Apr 2020 14:05:00 +0200
Received: by maeck.local (Postfix, from userid 501)
        id EE4F081E97B1; Mon,  6 Apr 2020 14:04:59 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mt76: mt7603: disable merge of OTP ROM data by default
Date:   Mon,  6 Apr 2020 14:04:58 +0200
Message-Id: <20200406120459.61713-1-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The reference driver does not seem to enable it by default, only under certain
conditions, e.g. when a .bin file is loaded.
Make it opt-in via a device tree property for now, in case it is needed on some
boards.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
index 2b6a4d8a8dc7..3ee06e2577b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: ISC
 
+#include <linux/of.h>
 #include "mt7603.h"
 #include "eeprom.h"
 
@@ -100,10 +101,14 @@ mt7603_apply_cal_free_data(struct mt7603_dev *dev, u8 *efuse)
 		MT_EE_TX_POWER_1_START_2G,
 		MT_EE_TX_POWER_1_START_2G + 1,
 	};
+	struct device_node *np = dev->mt76.dev->of_node;
 	u8 *eeprom = dev->mt76.eeprom.data;
 	int n = ARRAY_SIZE(cal_free_bytes);
 	int i;
 
+	if (!np || !of_property_read_bool(np, "mediatek,eeprom-merge-otp"))
+		return;
+
 	if (!mt7603_has_cal_free_data(dev, efuse))
 		return;
 
-- 
2.24.0

