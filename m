Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:39654 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbeCLJjf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 05:39:35 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com
Cc: hariprasath.elango@gmail.com, vbabu3@visteon.com,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] staging: wilc1000: use pre-defined macro is_broadcast_ether_addr
Date: Mon, 12 Mar 2018 15:09:03 +0530
Message-Id: <20180312093903.9147-1-hariprasath.elango@gmail.com> (sfid-20180312_103950_774220_27DCB3DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

Use the kernel pre-defined macro is_broadcast_ether_addr() instead of
doing a memcmp here.

Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index bbdfc7a..f93f411 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -27,7 +27,6 @@ static struct net_device *wilc_wfi_mon; /* global monitor netdev */
 
 static u8 srcadd[6];
 static u8 bssid[6];
-static u8 broadcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 /**
  *  @brief      WILC_WFI_monitor_rx
  *  @details
@@ -193,7 +192,7 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 
 	skb_pull(skb, rtap_len);
 
-	if (skb->data[0] == 0xc0 && (!(memcmp(broadcast, &skb->data[4], 6)))) {
+	if (skb->data[0] == 0xc0 && is_broadcast_ether_addr(&skb->data[4])) {
 		skb2 = dev_alloc_skb(skb->len + sizeof(struct wilc_wfi_radiotap_cb_hdr));
 		if (!skb2)
 			return -ENOMEM;
-- 
2.10.0.GIT
