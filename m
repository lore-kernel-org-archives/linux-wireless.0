Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:32636 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbeEBHPx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:53 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 19/21] staging: wilc1000: use is_broadcast_ether_addr check for broadcast address
Date: Wed, 2 May 2018 12:43:45 +0530
Message-ID: <1525245227-3924-20-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_093237_028615_590EBFFD)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make use of is_broadcast_ether_addr() to check if mac address is broadcast
address. Remove static 'broadcast', as its not needed after use of
is_broadcast_ether_addr().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index a659110..2f4b3f5 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -17,7 +17,6 @@ static struct net_device *wilc_wfi_mon; /* global monitor netdev */
 
 static u8 srcadd[6];
 static u8 bssid[6];
-static u8 broadcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 #define IEEE80211_RADIOTAP_F_TX_RTS	0x0004  /* used rts/cts handshake */
 #define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001  /* failed due to excessive*/
@@ -164,7 +163,7 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 
 	skb_pull(skb, rtap_len);
 
-	if (skb->data[0] == 0xc0 && (!(memcmp(broadcast, &skb->data[4], 6)))) {
+	if (skb->data[0] == 0xc0 && is_broadcast_ether_addr(&skb->data[4])) {
 		skb2 = dev_alloc_skb(skb->len + sizeof(struct wilc_wfi_radiotap_cb_hdr));
 		if (!skb2)
 			return -ENOMEM;
-- 
2.7.4
