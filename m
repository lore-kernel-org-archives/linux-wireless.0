Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC24C65BAF
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 05:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D06D42084E
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 05:13:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D06D42084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbeLLFNr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 00:13:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56008 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbeLLFNr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 00:13:47 -0500
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1gWwq4-0004PK-5P; Wed, 12 Dec 2018 05:13:40 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH] rtlwifi: Fix non-working BSS STA mode
Date:   Wed, 12 Dec 2018 13:13:35 +0800
Message-Id: <20181212051335.22580-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Once BSS STA mode gets started, it can be scanned by other clients but
cannot entablish a connection.

Turns out the set_bcn_reg() and its *_set_beacon_related_registers()
callbacks never get called so it has problem beaconing.

Enable the function in rtl_op_bss_info_changed() can make BSS STA mode
start to work.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 4bf7967590ca..11d27a5cc576 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1054,7 +1054,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 					 "BSS_CHANGED_BEACON_ENABLED\n");
 
 				/*start hw beacon interrupt. */
-				/*rtlpriv->cfg->ops->set_bcn_reg(hw); */
+				rtlpriv->cfg->ops->set_bcn_reg(hw);
 				mac->beacon_enabled = 1;
 				rtlpriv->cfg->ops->update_interrupt_mask(hw,
 						rtlpriv->cfg->maps
-- 
2.17.1

