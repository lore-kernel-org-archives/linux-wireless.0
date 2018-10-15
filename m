Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28964C070C3
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 02:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E218620652
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 02:06:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E218620652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbeJOJsv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 05:48:51 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43408 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725770AbeJOJsu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 05:48:50 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EFDD35DCD7EF7;
        Mon, 15 Oct 2018 10:05:42 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.399.0; Mon, 15 Oct 2018 10:05:34 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>, Lubomir Rintel <lkundrak@v3.sk>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] libertas: remove set but not used variable 'int_type'
Date:   Mon, 15 Oct 2018 02:16:35 +0000
Message-ID: <1539569795-176889-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/marvell/libertas/if_spi.c: In function 'if_spi_h2c':
drivers/net/wireless/marvell/libertas/if_spi.c:799:6: warning:
 variable 'int_type' set but not used [-Wunused-but-set-variable]

It never used since introduction in
commit d2b21f191753 ("libertas: if_spi, driver for libertas GSPI devices")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
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

