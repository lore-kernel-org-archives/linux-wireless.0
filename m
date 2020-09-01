Return-Path: <SRS0=DC1C=CK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EA9C433E6
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Sep 2020 03:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAE7A2078B
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Sep 2020 03:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIAD4e (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 31 Aug 2020 23:56:34 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43986 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726112AbgIAD4e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Aug 2020 23:56:34 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9C380E6D8739009A1E6D;
        Tue,  1 Sep 2020 11:56:31 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Tue, 1 Sep 2020
 11:56:21 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ath11k: Mark two variables as __maybe_unused
Date:   Tue, 1 Sep 2020 11:56:03 +0800
Message-ID: <20200901035603.25180-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix -Wunused-variable warnings:

drivers/net/wireless/ath/ath11k/debug.c:36:20: warning: ‘htt_bp_lmac_ring’ defined but not used [-Wunused-variable]
drivers/net/wireless/ath/ath11k/debug.c:15:20: warning: ‘htt_bp_umac_ring’ defined but not used [-Wunused-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath11k/debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debug.c b/drivers/net/wireless/ath/ath11k/debug.c
index 0a3cfa716390..0b7842e8cc58 100644
--- a/drivers/net/wireless/ath/ath11k/debug.c
+++ b/drivers/net/wireless/ath/ath11k/debug.c
@@ -12,7 +12,7 @@
 #include "debug_htt_stats.h"
 #include "peer.h"
 
-static const char *htt_bp_umac_ring[HTT_SW_UMAC_RING_IDX_MAX] = {
+static const __maybe_unused char *htt_bp_umac_ring[HTT_SW_UMAC_RING_IDX_MAX] = {
 	"REO2SW1_RING",
 	"REO2SW2_RING",
 	"REO2SW3_RING",
@@ -33,7 +33,7 @@ static const char *htt_bp_umac_ring[HTT_SW_UMAC_RING_IDX_MAX] = {
 	"REO_STATUS_RING",
 };
 
-static const char *htt_bp_lmac_ring[HTT_SW_LMAC_RING_IDX_MAX] = {
+static const __maybe_unused char *htt_bp_lmac_ring[HTT_SW_LMAC_RING_IDX_MAX] = {
 	"FW2RXDMA_BUF_RING",
 	"FW2RXDMA_STATUS_RING",
 	"FW2RXDMA_LINK_RING",
-- 
2.17.1


