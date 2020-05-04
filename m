Return-Path: <SRS0=yCsk=6S=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6C8C3A5A9
	for <linux-wireless@archiver.kernel.org>; Mon,  4 May 2020 11:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E2692073E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 May 2020 11:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgEDLd6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 May 2020 07:33:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55808 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728630AbgEDLd6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 May 2020 07:33:58 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C928BC0AEEF31254BEE3;
        Mon,  4 May 2020 19:33:56 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Mon, 4 May 2020
 19:33:48 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <linux-wireless@vger.kernel.org>,
        <b43-dev@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] b43: remove Comparison of 0/1 to bool variable in pio.c
Date:   Mon, 4 May 2020 19:33:11 +0800
Message-ID: <20200504113311.41026-1-yanaijie@huawei.com>
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

drivers/net/wireless/broadcom/b43/pio.c:768:10-25: WARNING: Comparison
of 0/1 to bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/broadcom/b43/pio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/pio.c b/drivers/net/wireless/broadcom/b43/pio.c
index 69f8b46c9015..1a11c5dfb8d9 100644
--- a/drivers/net/wireless/broadcom/b43/pio.c
+++ b/drivers/net/wireless/broadcom/b43/pio.c
@@ -765,7 +765,7 @@ void b43_pio_rx(struct b43_pio_rxqueue *q)
 	bool stop;
 
 	while (1) {
-		stop = (pio_rx_frame(q) == 0);
+		stop = !pio_rx_frame(q);
 		if (stop)
 			break;
 		cond_resched();
-- 
2.21.1

