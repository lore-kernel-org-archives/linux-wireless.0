Return-Path: <SRS0=d7P/=6H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F4DC54FD0
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Apr 2020 06:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DF3E208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Apr 2020 06:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgDWGi1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 Apr 2020 02:38:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54341 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWGi1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Apr 2020 02:38:27 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jRVV7-0002Ha-Le; Thu, 23 Apr 2020 06:38:22 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     yhchuang@realtek.com, kvalo@codeaurora.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtw88)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] rtw88: Use udelay instead of usleep in atomic context
Date:   Thu, 23 Apr 2020 14:38:10 +0800
Message-Id: <20200423063811.2636-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423063811.2636-1-kai.heng.feng@canonical.com>
References: <20200423063811.2636-1-kai.heng.feng@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It's incorrect to use usleep in atomic context.

Switch to a macro which uses udelay instead of usleep to prevent the issue.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 245da96dfddc..8f998b4a7234 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -228,9 +228,9 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 		goto out;
 	}
 
-	ret = read_poll_timeout(rtw_read8, box_state,
-				!((box_state >> box) & 0x1), 100, 3000, false,
-				rtwdev, REG_HMETFR);
+	ret = read_poll_timeout_atomic(rtw_read8, box_state,
+				       !((box_state >> box) & 0x1), 100, 3000,
+				       false, rtwdev, REG_HMETFR);
 
 	if (ret) {
 		rtw_err(rtwdev, "failed to send h2c command\n");
-- 
2.17.1

