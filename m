Return-Path: <SRS0=yCsk=6S=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E41CC3A5A9
	for <linux-wireless@archiver.kernel.org>; Mon,  4 May 2020 11:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 761102073E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 May 2020 11:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgEDLec (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 May 2020 07:34:32 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56308 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726756AbgEDLec (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 May 2020 07:34:32 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D845BA2CDDE5F054BD5C;
        Mon,  4 May 2020 19:34:30 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Mon, 4 May 2020
 19:34:24 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] brcmfmac: remove Comparison to bool in brcmf_p2p_send_action_frame()
Date:   Mon, 4 May 2020 19:33:46 +0800
Message-ID: <20200504113346.41342-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:1781:9-12:
WARNING: Comparison to bool
drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:1785:5-8:
WARNING: Comparison to bool

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 1f5deea5a288..16b193d13a2f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1777,12 +1777,11 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 	}
 
 	tx_retry = 0;
-	while (!p2p->block_gon_req_tx &&
-	       (ack == false) && (tx_retry < P2P_AF_TX_MAX_RETRY)) {
+	while (!p2p->block_gon_req_tx && !ack && (tx_retry < P2P_AF_TX_MAX_RETRY)) {
 		ack = !brcmf_p2p_tx_action_frame(p2p, af_params);
 		tx_retry++;
 	}
-	if (ack == false) {
+	if (!ack) {
 		bphy_err(drvr, "Failed to send Action Frame(retry %d)\n",
 			 tx_retry);
 		clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
-- 
2.21.1

