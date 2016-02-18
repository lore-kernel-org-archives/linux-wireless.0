Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:29858 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424769AbcBRLdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 06:33:16 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 04/24] staging: wilc1000: linux_mon.c: add to check routine
Date: Thu, 18 Feb 2016 20:30:04 +0900
Message-ID: <1455795024-26978-4-git-send-email-leo.kim@atmel.com> (sfid-20160218_123319_655093_D78EE655)
In-Reply-To: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
References: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the return value which needs the check and
prints the error message when it fails.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_mon.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 3048e88..dbb98bf 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -266,7 +266,9 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	/* if source address and bssid fields are equal>>Mac header */
 	/*send it to mgmt frames handler */
 	if (!(memcmp(srcAdd, bssid, 6))) {
-		mon_mgmt_tx(mon_priv->real_ndev, skb->data, skb->len);
+		ret = mon_mgmt_tx(mon_priv->real_ndev, skb->data, skb->len);
+		if (ret)
+			netdev_err(dev, "fail to mgmt tx\n");
 		dev_kfree_skb(skb);
 	} else {
 		ret = wilc_mac_xmit(skb, mon_priv->real_ndev);
-- 
1.9.1

