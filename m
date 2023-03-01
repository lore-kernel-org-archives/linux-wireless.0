Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FCAC64EC4
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Mar 2023 03:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjCADGZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 28 Feb 2023 22:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjCADGY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2023 22:06:24 -0500
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE3B32CEC;
        Tue, 28 Feb 2023 19:06:22 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VclyQEq_1677639937;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VclyQEq_1677639937)
          by smtp.aliyun-inc.com;
          Wed, 01 Mar 2023 11:06:20 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     pkshih@realtek.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH v2] rtlwifi: rtl8192se: Remove some unused variables
Date:   Wed,  1 Mar 2023 11:05:34 +0800
Message-Id: <20230301030534.2102-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Variable bcntime_cfg, bcn_cw and bcn_ifs are not effectively used, so
delete it.

drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:6: warning:
variable 'bcntime_cfg' set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4240
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  -Remove bcn_cw and bcn_ifs.

 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index bd0b7e365edb..a8b5bf45b1bb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -1552,8 +1552,6 @@ void rtl92se_set_beacon_related_registers(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	u16 bcntime_cfg = 0;
-	u16 bcn_cw = 6, bcn_ifs = 0xf;
 	u16 atim_window = 2;
 
 	/* ATIM Window (in unit of TU). */
@@ -1576,13 +1574,6 @@ void rtl92se_set_beacon_related_registers(struct ieee80211_hw *hw)
 	 * other ad hoc STA */
 	rtl_write_byte(rtlpriv, BCN_ERR_THRESH, 100);
 
-	/* Beacon Time Configuration */
-	if (mac->opmode == NL80211_IFTYPE_ADHOC)
-		bcntime_cfg |= (bcn_cw << BCN_TCFG_CW_SHIFT);
-
-	/* TODO: bcn_ifs may required to be changed on ASIC */
-	bcntime_cfg |= bcn_ifs << BCN_TCFG_IFS;
-
 	/*for beacon changed */
 	rtl92s_phy_set_beacon_hwreg(hw, mac->beacon_interval);
 }
-- 
2.20.1.7.g153144c

