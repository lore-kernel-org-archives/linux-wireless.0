Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28BBC282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A40DA218AC
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732808AbfAaMWF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:22:05 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53700 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732403AbfAaMWD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 07:22:03 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0VCLm9m016756, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0VCLm9m016756
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 31 Jan 2019 20:21:48 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 31 Jan 2019 20:21:48 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/24] rtw88: 8822c: correct crystal setting
Date:   Thu, 31 Jan 2019 20:21:19 +0800
Message-ID: <1548937297-14660-7-git-send-email-yhchuang@realtek.com>
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

8822c crystal setting register is no longer at 0x24 and 0x28.
It is at REG_ANAPAR_XTAL_0 instead.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/reg.h      | 1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 4923a45..e48ea2d 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -296,6 +296,7 @@
 #define REG_WMAC_OPTION_FUNCTION 0x07D0
 #define REG_WMAC_OPTION_FUNCTION_1 0x07D4
 
+#define REG_ANAPAR_XTAL_0	0x1040
 #define REG_CPU_DMEM_CON	0x1080
 #define BIT_WL_PLATFORM_RST	BIT(16)
 #define BIT_WL_SECURITY_CLK	BIT(15)
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 38e770c..71f2af0 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -95,9 +95,9 @@ static void rtw8822c_phy_set_param(struct rtw_dev *rtwdev)
 
 	rtw_phy_load_tables(rtwdev);
 
-	crystal_cap = rtwdev->efuse.crystal_cap & 0x3F;
-	rtw_write32_mask(rtwdev, 0x24, 0x7e000000, crystal_cap);
-	rtw_write32_mask(rtwdev, 0x28, 0x7e, crystal_cap);
+	crystal_cap = rtwdev->efuse.crystal_cap & 0x7f;
+	rtw_write32_mask(rtwdev, REG_ANAPAR_XTAL_0, 0xfffc00,
+			 crystal_cap | (crystal_cap << 7));
 
 	/* post init after header files config */
 	rtw8822c_header_file_init(rtwdev, false);
-- 
2.7.4

