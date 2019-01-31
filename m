Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC66C3E8A4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6B05218AC
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732829AbfAaMWM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:22:12 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53735 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732798AbfAaMWL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 07:22:11 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0VCLv9J016809, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0VCLv9J016809
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 31 Jan 2019 20:21:57 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 31 Jan 2019 20:21:57 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 18/24] rtw88: 8822c: set ack timeout
Date:   Thu, 31 Jan 2019 20:21:31 +0800
Message-ID: <1548937297-14660-19-git-send-email-yhchuang@realtek.com>
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

For 8822C, driver needs to set ack timeout after hardware powered-on.
There are two values required for both CCK and OFDM rate sets.
But only OFDM ack timeout was set, and the value did not meet the
hardware specification (aSIFSTime + aSlotTime). For CCK, the ack
timeout should be 106us and for OFDM it should be 33us.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/reg.h      | 1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 7fc2b8f..81eec3c 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -278,6 +278,7 @@
 #define REG_RX_DRVINFO_SZ	0x060F
 #define BIT_APP_PHYSTS		BIT(28)
 #define REG_USTIME_EDCA		0x0638
+#define REG_ACKTO_CCK		0x0639
 #define REG_RESP_SIFS_CCK	0x063C
 #define REG_RESP_SIFS_OFDM	0x063E
 #define REG_ACKTO		0x0640
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index b2bc362..3634e41 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -767,7 +767,8 @@ static void rtw8822c_phy_set_param(struct rtw_dev *rtwdev)
 #define WLAN_BAR_ACK_TYPE		0x05
 #define WLAN_RA_TRY_RATE_AGG_LIMIT	0x08
 #define WLAN_RESP_TXRATE		0x84
-#define WLAN_ACK_TO			0x40
+#define WLAN_ACK_TO			0x21
+#define WLAN_ACK_TO_CCK			0x6A
 #define WLAN_DATA_RATE_FB_CNT_1_4	0x01000000
 #define WLAN_DATA_RATE_FB_CNT_5_8	0x08070504
 #define WLAN_RTS_RATE_FB_CNT_5_8	0x08070504
@@ -889,6 +890,7 @@ static int rtw8822c_mac_init(struct rtw_dev *rtwdev)
 	/* WMAC configuration */
 	rtw_write8(rtwdev, REG_BBPSF_CTRL + 2, WLAN_RESP_TXRATE);
 	rtw_write8(rtwdev, REG_ACKTO, WLAN_ACK_TO);
+	rtw_write8(rtwdev, REG_ACKTO_CCK, WLAN_ACK_TO_CCK);
 	rtw_write16(rtwdev, REG_EIFS, WLAN_EIFS_DUR_TUNE);
 	rtw_write8(rtwdev, REG_NAV_CTRL + 2, WLAN_NAV_MAX);
 	rtw_write8(rtwdev, REG_WMAC_TRXPTCL_CTL_H  + 2, WLAN_BAR_ACK_TYPE);
-- 
2.7.4

