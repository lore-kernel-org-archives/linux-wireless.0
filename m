Return-Path: <SRS0=Iw3I=PH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5423C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Dec 2018 13:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A06AE2075D
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Dec 2018 13:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbeL3N0s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Dec 2018 08:26:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51028 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbeL3N0r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Dec 2018 08:26:47 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gdb73-0002Oz-B4; Sun, 30 Dec 2018 13:26:41 +0000
From:   Colin King <colin.king@canonical.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: make const array 'data' static, shrinks object size
Date:   Sun, 30 Dec 2018 13:26:40 +0000
Message-Id: <20181230132640.6916-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the const array 'data' on the stack but instead
make it static. Makes the object code smaller by 78 bytes:

Before:
   text    data     bss     dec     hex filename
   5438    1080       0    6518    1976 mediatek/mt76/mt76x2/usb_mcu.o

After:
   text    data     bss     dec     hex filename
   5296    1144       0    6440    1928 mediatek/mt76/mt76x2/usb_mcu.o

(gcc version 8.2.0 x86_64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
index 45a95ee3a415..152d41fe9ff5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
@@ -39,7 +39,7 @@ static void mt76x2u_mcu_load_ivb(struct mt76x02_dev *dev)
 static void mt76x2u_mcu_enable_patch(struct mt76x02_dev *dev)
 {
 	struct mt76_usb *usb = &dev->mt76.usb;
-	const u8 data[] = {
+	static const u8 data[] = {
 		0x6f, 0xfc, 0x08, 0x01,
 		0x20, 0x04, 0x00, 0x00,
 		0x00, 0x09, 0x00,
-- 
2.19.1

