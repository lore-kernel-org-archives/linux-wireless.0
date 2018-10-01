Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFD6C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E1BC2084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:05:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E1BC2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbeJAPlw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 11:41:52 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:52955 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbeJAPlw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 11:41:52 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w9194qti004185, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w9194qti004185
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Mon, 1 Oct 2018 17:04:52 +0800
Received: from localhost.localdomain (172.21.69.146) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Mon, 1 Oct 2018 17:04:51 +0800
From:   <pkshih@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <joe@perches.com>,
        <rickveens92@gmail.com>, <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi: Removed unused define and code efuse_re_pg* from wifi.h
Date:   Mon, 1 Oct 2018 17:04:24 +0800
Message-ID: <20181001090424.13862-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.15.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.69.146]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rick Veens <rickveens92@gmail.com>

The following:
 bool efuse_re_pg_sec1flag;
 u8 efuse_re_pg_data[8];
are not referenced anywhere in the rtlwifi code.

This patch is originally created by Rick Veens <rickveens92@gmail.com>,
and Joe Perches <joe@perches.com> reminded to apply it to rtlwifi.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 0f3b98c5227f..87bc21bb5e8b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -1905,10 +1905,6 @@ struct rtl_efuse {
 	u8 efuse_map[2][EFUSE_MAX_LOGICAL_SIZE];
 	u16 efuse_usedbytes;
 	u8 efuse_usedpercentage;
-#ifdef EFUSE_REPG_WORKAROUND
-	bool efuse_re_pg_sec1flag;
-	u8 efuse_re_pg_data[8];
-#endif
 
 	u8 autoload_failflag;
 	u8 autoload_status;
-- 
2.15.1

