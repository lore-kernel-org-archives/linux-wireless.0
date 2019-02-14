Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CFDC4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 876C8222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392161AbfBNI7y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:59:54 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39623 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732827AbfBNI7n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 03:59:43 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1E8xQ3n005909, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1E8xQ3n005909
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:59:26 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 14 Feb 2019 16:59:25 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>
Subject: [PATCH v2 19/24] rtw88: 8822c: do not reset MAC Rx before sending CCK packet
Date:   Thu, 14 Feb 2019 16:58:58 +0800
Message-ID: <1550134743-17443-20-git-send-email-yhchuang@realtek.com>
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

Hardware can enter low power RX mode. If we enable CCKRST under this
mode will cause BB hang.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 4bde3fc..d20f45f 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -917,7 +917,7 @@ static int rtw8822c_mac_init(struct rtw_dev *rtwdev)
 	value16 = BIT_SET_RXPSF_PKTLENTHR(value16, 1);
 	value16 |= BIT_RXPSF_CTRLEN | BIT_RXPSF_VHTCHKEN | BIT_RXPSF_HTCHKEN
 		| BIT_RXPSF_OFDMCHKEN | BIT_RXPSF_CCKCHKEN
-		| BIT_RXPSF_OFDMRST | BIT_RXPSF_CCKRST;
+		| BIT_RXPSF_OFDMRST;
 	rtw_write16(rtwdev, REG_RXPSF_CTRL, value16);
 	rtw_write32(rtwdev, REG_RXPSF_TYPE_CTRL, 0xFFFFFFFF);
 	/* rx ignore configuration */
-- 
2.7.4

