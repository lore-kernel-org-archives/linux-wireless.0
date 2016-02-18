Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:30001 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425347AbcBRLd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 06:33:56 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V2 08/24] staging: wilc1000: linux_mon.c: removes comments
Date: Thu, 18 Feb 2016 20:30:08 +0900
Message-ID: <1455795024-26978-8-git-send-email-leo.kim@atmel.com> (sfid-20160218_123359_711815_2D54BBF5)
In-Reply-To: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
References: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unnecessary comments.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_mon.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 7e7cff4..28e52eb 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -191,8 +191,6 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	if (skb->len < rtap_len)
 		return -1;
 
-	/* skip the radiotap header */
-	/* Skip the ratio tap header */
 	skb_pull(skb, rtap_len);
 
 	if (skb->data[0] == 0xc0 && (!(memcmp(broadcast, &skb->data[4], 6)))) {
@@ -227,8 +225,6 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	}
 	skb->dev = mon_priv->real_ndev;
 
-	/* actual deliver of data is device-specific, and not shown here */
-
 	/* Identify if Ethernet or MAC header (data or mgmt) */
 	memcpy(srcAdd, &skb->data[10], 6);
 	memcpy(bssid, &skb->data[16], 6);
-- 
1.9.1

