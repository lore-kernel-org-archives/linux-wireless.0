Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98227C433FE
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Apr 2022 07:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355307AbiD2H6l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Apr 2022 03:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355298AbiD2H6h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Apr 2022 03:58:37 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CF4369C9;
        Fri, 29 Apr 2022 00:55:18 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VBgAXwM_1651218902;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VBgAXwM_1651218902)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Apr 2022 15:55:15 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     srini.raju@purelifi.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] wireless: Remove unused including <linux/version.h>
Date:   Fri, 29 Apr 2022 15:54:59 +0800
Message-Id: <20220429075459.72029-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Eliminate the follow versioncheck warning:

./drivers/net/wireless/purelifi/plfxlc/usb.c: 20 linux/version.h not
needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/purelifi/plfxlc/usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index 6f338b1572a1..d0e98b2f1365 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <net/mac80211.h>
 #include <asm/unaligned.h>
-#include <linux/version.h>
 #include <linux/sysfs.h>
 
 #include "mac.h"
-- 
2.20.1.7.g153144c

