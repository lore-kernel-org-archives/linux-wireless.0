Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:41590 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S966685AbeF2Cvz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 22:51:55 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <simon@thekelleys.org.uk>, <kvalo@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] atmel: using strlcpy() to avoid possible buffer overflows
Date: Fri, 29 Jun 2018 10:51:35 +0800
Message-ID: <20180629025135.12236-1-yuehaibing@huawei.com> (sfid-20180629_045218_884239_DBE6FB9C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'firmware' is a module param which may been longer than firmware_id,
so using strlcpy() to guard against overflows

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/atmel/atmel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index b01dc34..604d5ac 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -1519,7 +1519,7 @@ struct net_device *init_atmel_card(unsigned short irq, unsigned long port,
 	priv->firmware_id[0] = '\0';
 	priv->firmware_type = fw_type;
 	if (firmware) /* module parameter */
-		strcpy(priv->firmware_id, firmware);
+		strlcpy(priv->firmware_id, firmware, sizeof(priv->firmware_id));
 	priv->bus_type = card_present ? BUS_TYPE_PCCARD : BUS_TYPE_PCI;
 	priv->station_state = STATION_STATE_DOWN;
 	priv->do_rx_crc = 0;
-- 
2.7.0
