Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5B1C433EF
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Apr 2022 00:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiDHADX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiDHADW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Apr 2022 20:03:22 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2FF217977;
        Thu,  7 Apr 2022 17:01:19 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0V9T1PDU_1649376075;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V9T1PDU_1649376075)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 08 Apr 2022 08:01:15 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        loic.poulain@linaro.org, toke@toke.dk, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next 1/2] wcn36xx: clean up some inconsistent indenting
Date:   Fri,  8 Apr 2022 08:01:12 +0800
Message-Id: <20220408000113.129906-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Eliminate the follow smatch warning:
drivers/net/wireless/ath/wcn36xx/smd.c:3151
wcn36xx_smd_gtk_offload_get_info_rsp() warn: inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 872b37875c57..691e637b94f1 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -3148,9 +3148,9 @@ static int wcn36xx_smd_gtk_offload_get_info_rsp(struct wcn36xx *wcn,
 			cpu_to_le64(rsp->key_replay_counter);
 		ieee80211_gtk_rekey_notify(vif, vif->bss_conf.bssid,
 					   (void *)&replay_ctr, GFP_KERNEL);
-		 wcn36xx_dbg(WCN36XX_DBG_HAL,
-			     "GTK replay counter increment %llu\n",
-			     rsp->key_replay_counter);
+		wcn36xx_dbg(WCN36XX_DBG_HAL,
+			    "GTK replay counter increment %llu\n",
+			    rsp->key_replay_counter);
 	}
 
 	wcn36xx_dbg(WCN36XX_DBG_HAL,
-- 
2.20.1.7.g153144c

