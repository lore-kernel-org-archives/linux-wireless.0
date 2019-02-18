Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF97C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 07:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EC212184A
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 07:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbfBRHiY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 02:38:24 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:3761 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfBRHiY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 02:38:24 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 633D6209294E127490E3;
        Mon, 18 Feb 2019 15:38:17 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.408.0; Mon, 18 Feb 2019 15:38:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] rsi: remove set but not used variables 'info, vif'
Date:   Mon, 18 Feb 2019 07:51:56 +0000
Message-ID: <20190218075156.183879-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/rsi/rsi_91x_main.c: In function 'rsi_prepare_skb':
drivers/net/wireless/rsi/rsi_91x_main.c:127:24: warning:
 variable 'vif' set but not used [-Wunused-but-set-variable]

drivers/net/wireless/rsi/rsi_91x_main.c:124:28: warning:
 variable 'info' set but not used [-Wunused-but-set-variable]

They're not used any more since 160ee2a11ce0 ("rsi: fill rx_params only once.")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index ca3a55ed72e4..29d83049c5f5 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -121,11 +121,8 @@ static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
 				       u32 pkt_len,
 				       u8 extended_desc)
 {
-	struct ieee80211_tx_info *info;
 	struct sk_buff *skb = NULL;
 	u8 payload_offset;
-	struct ieee80211_vif *vif;
-	struct ieee80211_hdr *wh;
 
 	if (WARN(!pkt_len, "%s: Dummy pkt received", __func__))
 		return NULL;
@@ -144,10 +141,7 @@ static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
 	payload_offset = (extended_desc + FRAME_DESC_SZ);
 	skb_put(skb, pkt_len);
 	memcpy((skb->data), (buffer + payload_offset), skb->len);
-	wh = (struct ieee80211_hdr *)skb->data;
-	vif = rsi_get_vif(common->priv, wh->addr1);
 
-	info = IEEE80211_SKB_CB(skb);
 	return skb;
 }



