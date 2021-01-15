Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF4FC433E6
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Jan 2021 10:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 671C5235F9
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Jan 2021 10:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbhAOKHm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Jan 2021 05:07:42 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:46210 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbhAOKHm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jan 2021 05:07:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0ULoF6Qe_1610705212;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0ULoF6Qe_1610705212)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Jan 2021 18:06:57 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        Larry.Finger@lwfinger.net, chiu@endlessos.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] rtlwifi/rtl8192se: Simplify bool comparison.
Date:   Fri, 15 Jan 2021 18:06:51 +0800
Message-Id: <1610705211-22865-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix the follow coccicheck warnings:

./drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:2305:6-27:
WARNING: Comparison of 0/1 to bool variable.

./drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1376:5-26:
WARNING: Comparison of 0/1 to bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index 47fabce..aff8ab0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -1373,7 +1373,7 @@ static void _rtl92se_gen_refreshledstate(struct ieee80211_hw *hw)
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 
-	if (rtlpci->up_first_time == 1)
+	if (rtlpci->up_first_time)
 		return;
 
 	if (rtlpriv->psc.rfoff_reason == RF_CHANGE_BY_IPS)
@@ -2302,7 +2302,7 @@ bool rtl92se_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid)
 	bool turnonbypowerdomain = false;
 
 	/* just 8191se can check gpio before firstup, 92c/92d have fixed it */
-	if ((rtlpci->up_first_time == 1) || (rtlpci->being_init_adapter))
+	if (rtlpci->up_first_time || rtlpci->being_init_adapter)
 		return false;
 
 	if (ppsc->swrf_processing)
-- 
1.8.3.1

