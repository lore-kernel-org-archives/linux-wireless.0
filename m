Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C83FC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED1E0218AC
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732552AbfAaMWS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:22:18 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53745 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732839AbfAaMWP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 07:22:15 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0VCM2xt016839, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0VCM2xt016839
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 31 Jan 2019 20:22:02 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 31 Jan 2019 20:22:01 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 24/24] rtw88: 8822b: turn rtw_write32s_mask into macro
Date:   Thu, 31 Jan 2019 20:21:37 +0800
Message-ID: <1548937297-14660-25-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.143]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

The inlined rtw_write32s_mask has to check range of addr with
BUILD_BUG_ON. But with some variants of gcc version the function might
not get inlined, and it will have no idea to know how to do, then
results in a compile error. Turn it into a macro to make sure the values
are known when compile time.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 10 ----------
 drivers/net/wireless/realtek/rtw88/rtw8822b.h | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index c0e5d1f..22b880a 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -224,16 +224,6 @@ static int rtw8822b_mac_init(struct rtw_dev *rtwdev)
 	return 0;
 }
 
-static inline void
-rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
-{
-	BUILD_BUG_ON(addr < 0xC00 || addr >= 0xD00);
-
-	rtw_write32_mask(rtwdev, addr, mask, data);
-	/* 0xC00-0xCFF and 0xE00-0xEFF have the same layout */
-	rtw_write32_mask(rtwdev, addr + 0x200, mask, data);
-}
-
 static void rtw8822b_set_channel_rfe_efem(struct rtw_dev *rtwdev, u8 channel)
 {
 	struct rtw_hal *hal = &rtwdev->hal;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.h b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
index 311fe8a..4cf193b1 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
@@ -97,6 +97,21 @@ struct rtw8822b_efuse {
 	};
 };
 
+static inline void
+_rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
+{
+	rtw_write32_mask(rtwdev, addr, mask, data);
+	rtw_write32_mask(rtwdev, addr + 0x200, mask, data);
+}
+
+/* 0xC00-0xCFF and 0xE00-0xEFF have the same layout */
+#define rtw_write32s_mask(rtwdev, addr, mask, data)			       \
+	do {								       \
+		BUILD_BUG_ON(addr < 0xC00 || addr >= 0xD00);		       \
+									       \
+		_rtw_write32s_mask(rtwdev, addr, mask, data);		       \
+	} while (0)
+
 /* phy status page0 */
 #define GET_PHY_STAT_P0_PWDB(phy_stat)                                         \
 	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(15, 8))
-- 
2.7.4

