Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C347CC10F04
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98998222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732263AbfBNI7l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:59:41 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39572 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729841AbfBNI7d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 03:59:33 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1E8xF7I005840, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1E8xF7I005840
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:59:15 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 14 Feb 2019 16:59:15 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>
Subject: [PATCH v2 05/24] rtw88: add a delay after writing a rf register
Date:   Thu, 14 Feb 2019 16:58:44 +0800
Message-ID: <1550134743-17443-6-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
References: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chien-Hsun Liao <ben.liao@realtek.com>

After writing a rf register, driver should wait for several
microseconds. If we write a rf register and read it immediately
without a delay, we could get a wrong value because the writing is
not finished yet. Based on the simulation results, writing a rf
register by pi write needs 13 microsenconds, writing rf register
directly write needs 1 microsecond to complete.

And modify direct write flow to make sure that there is no hardware pi
write simultaneously.

Signed-off-by: Chien-Hsun Liao <ben.liao@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/phy.c | 10 ++++++++++
 drivers/net/wireless/realtek/rtw88/reg.h |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index ae066e6..6cb07b5 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -5,6 +5,7 @@
 #include <linux/bcd.h>
 
 #include "main.h"
+#include "reg.h"
 #include "fw.h"
 #include "phy.h"
 #include "debug.h"
@@ -573,6 +574,8 @@ bool rtw_phy_write_rf_reg_sipi(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
 
 	rtw_write32(rtwdev, sipi_addr[rf_path], data_and_addr);
 
+	udelay(13);
+
 	return true;
 }
 
@@ -593,8 +596,15 @@ bool rtw_phy_write_rf_reg(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
 	direct_addr = base_addr[rf_path] + (addr << 2);
 	mask &= RFREG_MASK;
 
+	rtw_write32_mask(rtwdev, REG_RSV_CTRL, BITS_RFC_DIRECT, DISABLE_PI);
+	rtw_write32_mask(rtwdev, REG_WLRF1, BITS_RFC_DIRECT, DISABLE_PI);
 	rtw_write32_mask(rtwdev, direct_addr, mask, data);
 
+	udelay(1);
+
+	rtw_write32_mask(rtwdev, REG_RSV_CTRL, BITS_RFC_DIRECT, ENABLE_PI);
+	rtw_write32_mask(rtwdev, REG_WLRF1, BITS_RFC_DIRECT, ENABLE_PI);
+
 	return true;
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 05424ec..304c8df 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -14,6 +14,9 @@
 #define BIT_CPU_CLK_EN		BIT(14)
 
 #define REG_RSV_CTRL		0x001C
+#define DISABLE_PI		0x3
+#define ENABLE_PI		0x2
+#define BITS_RFC_DIRECT		(BIT(31) | BIT(30))
 #define BIT_WLMCU_IOIF		BIT(0)
 #define REG_RF_CTRL		0x001F
 #define BIT_RF_SDM_RSTB		BIT(2)
@@ -66,6 +69,7 @@
 				 BIT_CHECK_SUM_OK)
 #define FW_READY_MASK		0xffff
 
+#define REG_WLRF1		0x00EC
 #define REG_SYS_CFG1		0x00F0
 #define	BIT_RTL_ID		BIT(23)
 #define BIT_RF_TYPE_ID		BIT(27)
-- 
2.7.4

