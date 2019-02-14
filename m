Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A40D3C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72052222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbfBNI76 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:59:58 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39609 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730797AbfBNI7l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 03:59:41 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1E8xO2h005900, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1E8xO2h005900
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:59:25 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 14 Feb 2019 16:59:24 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>
Subject: [PATCH v2 17/24] rtw88: 8822c: fix RSC setting
Date:   Thu, 14 Feb 2019 16:58:56 +0800
Message-ID: <1550134743-17443-18-git-send-email-yhchuang@realtek.com>
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

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Hardware default value is 0x11 and its wrong.
Set [22:21] to zero for primary 20Mhz BW mode.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index df76ce6..74cbf4e 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -857,6 +857,7 @@ static int rtw8822c_mac_init(struct rtw_dev *rtwdev)
 	rtw_write8(rtwdev, REG_FAST_EDCA_BEBK_SETTING + 2, FAST_EDCA_BK_TH);
 	/* close BA parser */
 	rtw_write8_clr(rtwdev, REG_LIFETIME_EN, BIT_BA_PARSER_EN);
+	rtw_write32_clr(rtwdev, REG_RRSR, BITS_RRSR_RSC);
 
 	/* EDCA configuration */
 	rtw_write32(rtwdev, REG_EDCA_VO_PARAM, WLAN_EDCA_VO_PARAM);
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index 6a64640..74396ad 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -123,6 +123,8 @@ struct rtw8822c_efuse {
 
 #define REG_ANAPARLDO_POW_MAC	0x0029
 #define BIT_LDOE25_PON		BIT(0)
+#define REG_RRSR		0x0440
+#define BITS_RRSR_RSC		(BIT(21) | BIT(22))
 
 #define REG_TXDFIR0	0x808
 #define REG_DFIRBW	0x810
-- 
2.7.4

