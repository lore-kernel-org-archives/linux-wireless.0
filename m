Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626A1C433F5
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Apr 2022 07:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbiDAHMt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Apr 2022 03:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbiDAHMt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Apr 2022 03:12:49 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2BE1D66FD;
        Fri,  1 Apr 2022 00:10:58 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 1 Apr
 2022 15:10:59 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Fri, 1 Apr
 2022 15:10:56 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ipw2x00: Fix potential NULL dereference in libipw_xmit()
Date:   Fri, 1 Apr 2022 15:10:54 +0800
Message-ID: <1648797055-25730-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-124.meizu.com (172.16.1.124) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

crypt and crypt->ops could be null, so we need to checking null
before dereference

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
index 36d1e6b2568d..4aec1fce1ae2 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
@@ -383,7 +383,7 @@ netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		/* Each fragment may need to have room for encryption
 		 * pre/postfix */
-		if (host_encrypt)
+		if (host_encrypt && crypt && crypt->ops)
 			bytes_per_frag -= crypt->ops->extra_mpdu_prefix_len +
 			    crypt->ops->extra_mpdu_postfix_len;
 
-- 
2.7.4

