Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5711C433B4
	for <linux-wireless@archiver.kernel.org>; Thu, 13 May 2021 12:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C937B6127A
	for <linux-wireless@archiver.kernel.org>; Thu, 13 May 2021 12:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhEMMZe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 May 2021 08:25:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34054 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbhEMMZ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 May 2021 08:25:27 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lhANu-0003dX-6U; Thu, 13 May 2021 12:24:10 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8723ae: remove redundant initialization of variable rtstatus
Date:   Thu, 13 May 2021 13:24:09 +0100
Message-Id: <20210513122410.59204-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable rtstatus is being initialized with a value that is never
read, it is being updated later on. The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index f8a1de6e9849..c98f2216734f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -915,7 +915,7 @@ int rtl8723e_hw_init(struct ieee80211_hw *hw)
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	bool rtstatus = true;
+	bool rtstatus;
 	int err;
 	u8 tmp_u1b;
 	unsigned long flags;
-- 
2.30.2

