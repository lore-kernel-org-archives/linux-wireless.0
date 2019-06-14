Return-Path: <SRS0=mNjQ=UN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98390C31E44
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 07:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AC252073F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 07:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfFNHYe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Jun 2019 03:24:34 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:48185 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfFNHYb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Jun 2019 03:24:31 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x5E7ORUA024976, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw [172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTP id x5E7ORUA024976;
        Fri, 14 Jun 2019 15:24:27 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.439.0; Fri, 14 Jun 2019 15:24:26 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 11/11] rtw88: fix typo rtw_writ16_set
Date:   Fri, 14 Jun 2019 15:24:15 +0800
Message-ID: <1560497055-17197-12-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560497055-17197-1-git-send-email-yhchuang@realtek.com>
References: <1560497055-17197-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Tzu-En Huang <tehuang@realtek.com>

rtw_writ16_set should be rtw_write16_set

Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/hci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/hci.h b/drivers/net/wireless/realtek/rtw88/hci.h
index 2676582..aba329c 100644
--- a/drivers/net/wireless/realtek/rtw88/hci.h
+++ b/drivers/net/wireless/realtek/rtw88/hci.h
@@ -97,7 +97,7 @@ static inline void rtw_write8_set(struct rtw_dev *rtwdev, u32 addr, u8 bit)
 	rtw_write8(rtwdev, addr, val | bit);
 }
 
-static inline void rtw_writ16_set(struct rtw_dev *rtwdev, u32 addr, u16 bit)
+static inline void rtw_write16_set(struct rtw_dev *rtwdev, u32 addr, u16 bit)
 {
 	u16 val;
 
-- 
2.7.4

