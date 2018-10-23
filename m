Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994FEC7112C
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 03:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9306420674
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 03:45:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9306420674
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbeJWMHB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 08:07:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34054 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727012AbeJWMHB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 08:07:01 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5F5A6F07DEA5;
        Tue, 23 Oct 2018 11:45:29 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.408.0; Tue, 23 Oct 2018 11:45:26 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <lkundrak@v3.sk>,
        <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] libertas: remove set but not used variable 'int_type'
Date:   Tue, 23 Oct 2018 11:32:48 +0800
Message-ID: <1540265568-58721-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

int_type is not used after setting its value. It is safe to remove
the unused variable.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/marvell/libertas/if_spi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_spi.c b/drivers/net/wireless/marvell/libertas/if_spi.c
index 504d6e0..7c3224b 100644
--- a/drivers/net/wireless/marvell/libertas/if_spi.c
+++ b/drivers/net/wireless/marvell/libertas/if_spi.c
@@ -796,15 +796,13 @@ static void if_spi_h2c(struct if_spi_card *card,
 {
 	struct lbs_private *priv = card->priv;
 	int err = 0;
-	u16 int_type, port_reg;
+	u16 port_reg;
 
 	switch (type) {
 	case MVMS_DAT:
-		int_type = IF_SPI_CIC_TX_DOWNLOAD_OVER;
 		port_reg = IF_SPI_DATA_RDWRPORT_REG;
 		break;
 	case MVMS_CMD:
-		int_type = IF_SPI_CIC_CMD_DOWNLOAD_OVER;
 		port_reg = IF_SPI_CMD_RDWRPORT_REG;
 		break;
 	default:
-- 
1.7.12.4

