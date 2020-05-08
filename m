Return-Path: <SRS0=6+7Q=6W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA67C47247
	for <linux-wireless@archiver.kernel.org>; Fri,  8 May 2020 01:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0038420A8B
	for <linux-wireless@archiver.kernel.org>; Fri,  8 May 2020 01:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgEHBaY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 May 2020 21:30:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3904 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726514AbgEHBaY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 May 2020 21:30:24 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3388588B7CDE53CE7966;
        Fri,  8 May 2020 09:29:03 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 09:28:54 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <kvalo@codeaurora.org>
CC:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chenzhou10@huawei.com>
Subject: [PATCH -next] brcmfmac: make non-global functions static
Date:   Fri, 8 May 2020 09:32:49 +0800
Message-ID: <20200508013249.95196-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix sparse warning:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:2206:5:
	warning: symbol 'brcmf_p2p_get_conn_idx' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index e32c24a2670d..2a2440031357 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2203,7 +2203,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	return ERR_PTR(err);
 }
 
-int brcmf_p2p_get_conn_idx(struct brcmf_cfg80211_info *cfg)
+static int brcmf_p2p_get_conn_idx(struct brcmf_cfg80211_info *cfg)
 {
 	int i;
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
-- 
2.20.1

