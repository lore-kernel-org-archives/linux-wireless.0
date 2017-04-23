Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:49669 "EHLO m50-132.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1044778AbdDWLzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Apr 2017 07:55:24 -0400
From: Pan Bian <bianpan201602@163.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] staging: wilc1000: fix unchecked return value
Date: Sun, 23 Apr 2017 19:53:58 +0800
Message-Id: <1492948438-17389-1-git-send-email-bianpan201602@163.com> (sfid-20170423_135609_699380_544BA2D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pan Bian <bianpan2016@163.com>

Function dev_alloc_skb() will return a NULL pointer if there is no
enough memory. However, in function WILC_WFI_mon_xmit(), its return
value is used without validation. This may result in a bad memory access
bug. This patch fixes the bug.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/staging/wilc1000/linux_mon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index f328d75..c9782d4 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -197,6 +197,8 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 
 	if (skb->data[0] == 0xc0 && (!(memcmp(broadcast, &skb->data[4], 6)))) {
 		skb2 = dev_alloc_skb(skb->len + sizeof(struct wilc_wfi_radiotap_cb_hdr));
+		if (!skb2)
+			return -ENOMEM;
 
 		memcpy(skb_put(skb2, skb->len), skb->data, skb->len);
 
-- 
1.9.1
