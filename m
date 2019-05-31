Return-Path: <SRS0=dvIt=T7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA64C04AB6
	for <linux-wireless@archiver.kernel.org>; Fri, 31 May 2019 14:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50FED26A28
	for <linux-wireless@archiver.kernel.org>; Fri, 31 May 2019 14:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfEaOOT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 31 May 2019 10:14:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48217 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaOOT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 May 2019 10:14:19 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hWiIP-0001I2-0F; Fri, 31 May 2019 14:14:13 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: remove redundant assignment to variable k
Date:   Fri, 31 May 2019 15:14:12 +0100
Message-Id: <20190531141412.18632-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The assignment of 0 to variable k is never read once we break out of
the loop, so the assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/efuse.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index e68340dfd980..83e5318ca04f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -117,10 +117,8 @@ u8 efuse_read_1byte(struct ieee80211_hw *hw, u16 address)
 						 rtlpriv->cfg->
 						 maps[EFUSE_CTRL] + 3);
 			k++;
-			if (k == 1000) {
-				k = 0;
+			if (k == 1000)
 				break;
-			}
 		}
 		data = rtl_read_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL]);
 		return data;
-- 
2.20.1

