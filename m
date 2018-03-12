Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:43251 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbeCLIrh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 04:47:37 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com
Cc: hariprasath.elango@gmail.com, vbabu3@visteon.com,
        Hari Prasath <hgujulan@visteon.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: use pre-defined macro is_broadcast_ether_addr
Date: Mon, 12 Mar 2018 14:17:15 +0530
Message-Id: <20180312084715.30103-1-hariprasath.elango@gmail.com> (sfid-20180312_094757_873563_BCAB43F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hari Prasath <hgujulan@visteon.com>

Use the kernel pre-defined macro is_broadcast_ether_addr() instead of
doing a memcmp here.

Signed-off-by: Hari Prasath <hgujulan@visteon.com>
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
