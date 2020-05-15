Return-Path: <SRS0=zRRP=65=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C88C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 15 May 2020 10:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06247206B6
	for <linux-wireless@archiver.kernel.org>; Fri, 15 May 2020 10:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgEOKWh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 May 2020 06:22:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50839 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEOKWf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 May 2020 06:22:35 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jZXU2-0002o7-Q9; Fri, 15 May 2020 10:22:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192ee: remove redundant for-loop
Date:   Fri, 15 May 2020 11:22:26 +0100
Message-Id: <20200515102226.29819-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The for-loop seems to be redundant, the assignments for indexes
0..2 are being over-written by the last index 3 in the loop. Remove
the loop and use index 3 instead.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
index 6dba576aa81e..bb291b951f4d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
@@ -2866,14 +2866,12 @@ void rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 		}
 	}
 
-	for (i = 0; i < 4; i++) {
-		reg_e94 = result[i][0];
-		reg_e9c = result[i][1];
-		reg_ea4 = result[i][2];
-		reg_eb4 = result[i][4];
-		reg_ebc = result[i][5];
-		reg_ec4 = result[i][6];
-	}
+	reg_e94 = result[3][0];
+	reg_e9c = result[3][1];
+	reg_ea4 = result[3][2];
+	reg_eb4 = result[3][4];
+	reg_ebc = result[3][5];
+	reg_ec4 = result[3][6];
 
 	if (final_candidate != 0xff) {
 		reg_e94 = result[final_candidate][0];
-- 
2.25.1

