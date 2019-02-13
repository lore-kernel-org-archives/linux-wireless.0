Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35069C282CE
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 01:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 050B8222C1
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 01:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733102AbfBMBf0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 20:35:26 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:3192 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728339AbfBMBf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 20:35:26 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 671C0620CCE15458A830;
        Wed, 13 Feb 2019 09:35:21 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.408.0; Wed, 13 Feb 2019 09:35:12 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Colin Ian King <colin.king@canonical.com>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] libertas_tf: remove set but not used variable 'flags'
Date:   Wed, 13 Feb 2019 01:49:17 +0000
Message-ID: <20190213014917.164506-1-yuehaibing@huawei.com>
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

drivers/net/wireless/marvell/libertas_tf/main.c: In function 'lbtf_rx':
drivers/net/wireless/marvell/libertas_tf/main.c:554:15: warning:
 variable 'flags' set but not used [-Wunused-but-set-variable]

It never used and can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/marvell/libertas_tf/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/net/wireless/marvell/libertas_tf/main.c
index a7cb7d06e5e6..d36962528838 100644
--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -551,7 +551,6 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
 	struct ieee80211_rx_status stats;
 	struct rxpd *prxpd;
 	int need_padding;
-	unsigned int flags;
 	struct ieee80211_hdr *hdr;
 
 	lbtf_deb_enter(LBTF_DEB_RX);
@@ -572,7 +571,6 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
 	skb_pull(skb, sizeof(struct rxpd));
 
 	hdr = (struct ieee80211_hdr *)skb->data;
-	flags = le32_to_cpu(*(__le32 *)(skb->data + 4));
 
 	need_padding = ieee80211_is_data_qos(hdr->frame_control);
 	need_padding ^= ieee80211_has_a4(hdr->frame_control);



