Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC302C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C515D222B6
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390472AbfBNI7q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:59:46 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39625 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387436AbfBNI7o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 03:59:44 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1E8xSkw005924, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1E8xSkw005924
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:59:28 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 14 Feb 2019 16:59:28 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>
Subject: [PATCH v2 22/24] rtw88: set OFDM ctx to receive ack after cts2self
Date:   Thu, 14 Feb 2019 16:59:01 +0800
Message-ID: <1550134743-17443-23-git-send-email-yhchuang@realtek.com>
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

8822B originally set OFDM CTX to 0xA, but this period was too short to
receive ack, enlarge it to 0xE to fix it.

For 8822C, also set it to the same value to synchronize their behavior.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index 95af97f..76a5a64 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -127,7 +127,7 @@ static void rtw8822b_phy_set_param(struct rtw_dev *rtwdev)
 #define WLAN_SLOT_TIME		0x05
 #define WLAN_PIFS_TIME		0x19
 #define WLAN_SIFS_CCK_CONT_TX	0xA
-#define WLAN_SIFS_OFDM_CONT_TX	0xA
+#define WLAN_SIFS_OFDM_CONT_TX	0xE
 #define WLAN_SIFS_CCK_TRX	0x10
 #define WLAN_SIFS_OFDM_TRX	0x10
 #define WLAN_VO_TXOP_LIMIT	0x186 /* unit : 32us */
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index ec0e62f..83dfb1d 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -726,7 +726,7 @@ static void rtw8822c_phy_set_param(struct rtw_dev *rtwdev)
 #define WLAN_SLOT_TIME		0x05
 #define WLAN_PIFS_TIME		0x1C
 #define WLAN_SIFS_CCK_CONT_TX	0x0A
-#define WLAN_SIFS_OFDM_CONT_TX	0x10
+#define WLAN_SIFS_OFDM_CONT_TX	0x0E
 #define WLAN_SIFS_CCK_TRX	0x0A
 #define WLAN_SIFS_OFDM_TRX	0x10
 #define WLAN_NAV_MAX		0xC8
-- 
2.7.4

