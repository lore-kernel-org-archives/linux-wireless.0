Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F93AC433EF
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Apr 2022 00:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356405AbiD0Ae6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244133AbiD0Ae5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Apr 2022 20:34:57 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1744344C6;
        Tue, 26 Apr 2022 17:31:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VBPcZAD_1651019503;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VBPcZAD_1651019503)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Apr 2022 08:31:44 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, kvalo@kernel.org,
        pkshih@realtek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] rtw89: remove unneeded semicolon
Date:   Wed, 27 Apr 2022 08:31:42 +0800
Message-Id: <20220427003142.107916-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Eliminate the following coccicheck warning:
./drivers/net/wireless/realtek/rtw89/rtw8852c.c:2556:2-3: Unneeded
semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8852c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c.c b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
index 858611c64e6b..275568468212 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
@@ -2553,7 +2553,7 @@ do {								\
 	default:
 		val = arg.gnt_bt.data;
 		break;
-	};
+	}
 
 	__write_ctrl(R_AX_PWR_COEXT_CTRL, B_AX_TXAGC_BT_MASK, val,
 		     B_AX_TXAGC_BT_EN, arg.ctrl_gnt_bt != 0xffff);
-- 
2.20.1.7.g153144c

