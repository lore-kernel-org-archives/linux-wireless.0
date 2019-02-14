Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8507C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98F2C222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390651AbfBNI7q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:59:46 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39624 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733184AbfBNI7o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 03:59:44 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1E8xS5e005920, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1E8xS5e005920
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:59:28 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 14 Feb 2019 16:59:27 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>
Subject: [PATCH v2 21/24] rtw88: do not count dummy tail into rx counter
Date:   Thu, 14 Feb 2019 16:59:00 +0800
Message-ID: <1550134743-17443-22-git-send-email-yhchuang@realtek.com>
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

If BIT_DUMMY_FCS_READY_MASK_EN is not enabled, hardware will not mask
out dummy tails and takes them into VHT rx count. Enable the mask to get
expected RX counter.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/reg.h      | 2 ++
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 27732a1..97bcd90 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -396,6 +396,8 @@
 	(BIT_CLEAR_RXPSF_ERRTHR(x) | BIT_RXPSF_ERRTHR(v))
 
 #define REG_RXPSF_TYPE_CTRL	0x1614
+#define REG_GENERAL_OPTION	0x1664
+#define BIT_DUMMY_FCS_READY_MASK_EN BIT(9)
 
 #define REG_WL2LTECOEX_INDIRECT_ACCESS_CTRL_V1		0x1700
 #define REG_WL2LTECOEX_INDIRECT_ACCESS_WRITE_DATA_V1	0x1704
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 3e22597..ec0e62f 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -905,6 +905,7 @@ static int rtw8822c_mac_init(struct rtw_dev *rtwdev)
 	rtw_write8(rtwdev, REG_RX_PKT_LIMIT, WLAN_RXPKT_MAX_SZ_512);
 	rtw_write8(rtwdev, REG_TCR + 2, WLAN_TX_FUNC_CFG2);
 	rtw_write8(rtwdev, REG_TCR + 1, WLAN_TX_FUNC_CFG1);
+	rtw_write32_set(rtwdev, REG_GENERAL_OPTION, BIT_DUMMY_FCS_READY_MASK_EN);
 	rtw_write32(rtwdev, REG_WMAC_OPTION_FUNCTION + 8, WLAN_MAC_OPT_FUNC2);
 	rtw_write8(rtwdev, REG_WMAC_OPTION_FUNCTION_1, WLAN_MAC_OPT_NORM_FUNC1);
 
-- 
2.7.4

