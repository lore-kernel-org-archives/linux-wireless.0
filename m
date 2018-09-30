Return-Path: <SRS0=a98u=MM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B5DC64EAD
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 22:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C0D206B2
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 22:57:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6C0D206B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbeJAFcL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 01:32:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56716 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbeJAFcL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 01:32:11 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1g6keJ-0002lp-J1; Sun, 30 Sep 2018 22:57:15 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]  mt76: fix header guard macro define names
Date:   Sun, 30 Sep 2018 23:57:15 +0100
Message-Id: <20180930225715.18491-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The header guards that are #defined are different from those being
checked.  Fix this by #defining them to the correct name.

Fixes clang warnings:
drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h:17:9:
warning: '__MT76x02_MCU_H' is used as a header guard here, followed
by #define of a different macro [-Wheader-guard]

drivers/net/wireless/mediatek/mt76/mt76x02_usb.h:17:9:
warning: '__MT76x02_USB_H' is used as a header guard here, followed
by #define of a different macro [-Wheader-guard]

Fixes: 905db7470199 ("mt76: usb: move mt76x02 mcu code in mt76x02-usb module")
Fixes: edaa580bc830 ("mt76: move shared mcu_calibrate routine in mt76x02-lib module")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
index 2f5af3dad2bb..6e178bec07d8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
@@ -15,7 +15,7 @@
  */
 
 #ifndef __MT76x02_MCU_H
-#define __MT76x0x_MCU_H
+#define __MT76x02_MCU_H
 
 #define MT_MCU_RESET_CTL		0x070C
 #define MT_MCU_INT_LEVEL		0x0718
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
index 2482f9761fcd..39dcfeee39f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -15,7 +15,7 @@
  */
 
 #ifndef __MT76x02_USB_H
-#define __MT76x0x_USB_H
+#define __MT76x02_USB_H
 
 #include "mt76.h"
 
-- 
2.17.1

