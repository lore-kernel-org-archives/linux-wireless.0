Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E8EC7EE2F
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Jun 2023 07:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbjFIHis (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Jun 2023 03:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238956AbjFIHib (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2023 03:38:31 -0400
Received: from mail.kevlo.org (ns.kevlo.org [220.134.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14254193
        for <linux-wireless@vger.kernel.org>; Fri,  9 Jun 2023 00:38:29 -0700 (PDT)
Received: from localhost (ns.kevlo.org [local])
        by ns.kevlo.org (OpenSMTPD) with ESMTPA id 37234dea;
        Fri, 9 Jun 2023 15:38:25 +0800 (CST)
Date:   Fri, 9 Jun 2023 15:38:25 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: rtw89: use the correct bit in the R_AX_PLE_INI_STATUS
 register
Message-ID: <ZILW8Uct7yUjsVyh@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use the PLE_MGN_INI_RDY bit rather than WDE_MGN_INI_RDY to check if 
PLE cfg ready runs into a timeout.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 512de491a064..4e0cec7c59a2 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -1814,7 +1814,7 @@ static int dle_init(struct rtw89_dev *rtwdev, enum rtw89_qta_mode mode,
 	}
 
 	ret = read_poll_timeout(rtw89_read32, ini,
-				(ini & WDE_MGN_INI_RDY) == WDE_MGN_INI_RDY, 1,
+				(ini & PLE_MGN_INI_RDY) == PLE_MGN_INI_RDY, 1,
 				2000, false, rtwdev, R_AX_PLE_INI_STATUS);
 	if (ret) {
 		rtw89_err(rtwdev, "[ERR]PLE cfg ready\n");

