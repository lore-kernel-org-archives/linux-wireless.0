Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34273 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbcL2VgJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Dec 2016 16:36:09 -0500
From: Mike Kofron <mpkofron@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Kofron <mpkofron@gmail.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: Fix endian sparse warning
Date: Thu, 29 Dec 2016 16:35:48 -0500
Message-Id: <1483047348-4653-1-git-send-email-mpkofron@gmail.com> (sfid-20161229_223631_946177_3AE9D87C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/staging/wilc1000/linux_wlan.c:995:18: warning: restricted __be16 degrades to integer

Signed-off-by: Mike Kofron <mpkofron@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e59cab5..f293779 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -992,7 +992,7 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	tx_data->skb  = skb;
 
 	eth_h = (struct ethhdr *)(skb->data);
-	if (eth_h->h_proto == 0x8e88)
+	if (eth_h->h_proto == cpu_to_be16(0x8e88))
 		netdev_dbg(ndev, "EAPOL transmitted\n");
 
 	ih = (struct iphdr *)(skb->data + sizeof(struct ethhdr));
-- 
1.9.1
