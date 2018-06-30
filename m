Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:59719 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751861AbeF3Gfo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 02:35:44 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <simon@thekelleys.org.uk>, <kvalo@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <davem@davemloft.net>,
        <andy.shevchenko@gmail.com>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2] atmel: using strlcpy() to avoid possible buffer overflows
Date: Sat, 30 Jun 2018 14:33:41 +0800
Message-ID: <20180630063341.9900-1-yuehaibing@huawei.com> (sfid-20180630_083627_106412_CAC0082F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'firmware' is a module param which may been longer than firmware_id,
so using strlcpy() to guard against overflows. Also priv is allocated
with zeroed memory,no need to set firmware_id[0] to '\0'.

v1 -> v2: remove priv->firmware_id[0] = '\0';

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/atmel/atmel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index b01dc34..cec715b 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -1516,10 +1516,9 @@ struct net_device *init_atmel_card(unsigned short irq, unsigned long port,
 	priv->present_callback = card_present;
 	priv->card = card;
 	priv->firmware = NULL;
-	priv->firmware_id[0] = '\0';
 	priv->firmware_type = fw_type;
 	if (firmware) /* module parameter */
-		strcpy(priv->firmware_id, firmware);
+		strlcpy(priv->firmware_id, firmware, sizeof(priv->firmware_id));
 	priv->bus_type = card_present ? BUS_TYPE_PCCARD : BUS_TYPE_PCI;
 	priv->station_state = STATION_STATE_DOWN;
 	priv->do_rx_crc = 0;
-- 
2.7.0
