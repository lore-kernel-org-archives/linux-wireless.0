Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14237 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbcA0C5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 21:57:09 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/13] staging: wilc1000: wilc_frmw_to_linux(): fixes null check
Date: Wed, 27 Jan 2016 11:50:25 +0900
Message-ID: <1453863037-31073-1-git-send-email-glen.lee@atmel.com> (sfid-20160127_035713_710896_0147857A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

Null checking wilc_netdev and skb->dev are already done in the begining of the
function and they are just print printing error log, so delete them.
Null checking wilc is needed before is used so add null ckeck before it is
used.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ee779ee..db91a21 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1342,6 +1342,9 @@ void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 	struct net_device *wilc_netdev;
 	struct wilc_vif *vif;
 
+	if (!wilc)
+		return;
+
 	wilc_netdev = get_if_handler(wilc, buff);
 	if (!wilc_netdev)
 		return;
@@ -1358,14 +1361,8 @@ void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 			PRINT_ER("Low memory - packet droped\n");
 			return;
 		}
-
-		if (!wilc || !wilc_netdev)
-			PRINT_ER("wilc_netdev in wilc is NULL");
 		skb->dev = wilc_netdev;
 
-		if (!skb->dev)
-			PRINT_ER("skb->dev is NULL\n");
-
 		memcpy(skb_put(skb, frame_len), buff_to_send, frame_len);
 
 		skb->protocol = eth_type_trans(skb, wilc_netdev);
-- 
1.9.1

