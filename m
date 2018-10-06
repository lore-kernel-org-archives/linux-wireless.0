Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73EF9C67871
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 18:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49E5321473
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 18:43:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49E5321473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbeJGBrS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 21:47:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60235 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbeJGBrS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 21:47:18 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1g8rXL-0004Ve-EZ; Sat, 06 Oct 2018 18:42:47 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Tsang-Shian Lin <thlin@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8821ae: add in a missing break in switch statement
Date:   Sat,  6 Oct 2018 19:42:46 +0100
Message-Id: <20181006184246.29985-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The switch case RATR_INX_WIRELESS_MC has a missing break, this seems
to be unintentional as the setting of variable ret gets overwritten
when the case falls through to the following RATR_INX_WIRELESS_AC_5N
case.  Fix this by adding in the missing break.

Detected by CoverityScan, CID#1167237 ("Missing break in switch")

Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 317c1b3101da..8af49c1c99db 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -3448,6 +3448,7 @@ static u8 _rtl8821ae_mrate_idx_to_arfr_id(
 			ret = 6;
 		else
 			ret = 7;
+		break;
 	case RATR_INX_WIRELESS_AC_5N:
 		if (rtlphy->rf_type == RF_1T1R)
 			ret = 10;
-- 
2.17.1

