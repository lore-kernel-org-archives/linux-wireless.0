Return-Path: <SRS0=W7N3=2K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EBD5C43603
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Dec 2019 09:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 285EF20716
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Dec 2019 09:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfLTJWm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Dec 2019 04:22:42 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:47449 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfLTJWm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Dec 2019 04:22:42 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID xBK9MRHh025733, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id xBK9MRHh025733
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 20 Dec 2019 17:22:28 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.468.0; Fri, 20 Dec 2019 17:22:27 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <briannorris@chromium.org>
Subject: [PATCH 09/11] rtw88: use rtw_hci_stop() instead of rtwdev->hci.ops->stop()
Date:   Fri, 20 Dec 2019 17:21:54 +0800
Message-ID: <20191220092156.13443-10-yhchuang@realtek.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191220092156.13443-1-yhchuang@realtek.com>
References: <20191220092156.13443-1-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chin-Yen Lee <timlee@realtek.com>

Fix typo, should use rtw_hci_stop()

Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index d6c9cc1806f7..bbdd6aaaf89e 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -879,7 +879,7 @@ int rtw_core_start(struct rtw_dev *rtwdev)
 
 static void rtw_power_off(struct rtw_dev *rtwdev)
 {
-	rtwdev->hci.ops->stop(rtwdev);
+	rtw_hci_stop(rtwdev);
 	rtw_mac_power_off(rtwdev);
 }
 
-- 
2.17.1

