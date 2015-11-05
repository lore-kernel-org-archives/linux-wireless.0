Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27182 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbbKEFhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:37:10 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 38/38] staging: wilc1000: rename pu8UdpBuffer of mac_xmit function
Date: Thu, 5 Nov 2015 14:36:39 +0900
Message-ID: <1446701799-24870-38-git-send-email-glen.lee@atmel.com> (sfid-20151105_063719_788642_3706F045)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename pu8UdpBuffer variable of mac_xmit function to udp_buf
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7a07e43..f82ecb9 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1219,7 +1219,7 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	perInterface_wlan_t *nic;
 	struct tx_complete_data *tx_data = NULL;
 	int queue_count;
-	char *pu8UdpBuffer;
+	char *udp_buf;
 	struct iphdr *ih;
 	struct ethhdr *eth_h;
 	struct wilc *wilc;
@@ -1252,10 +1252,11 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	ih = (struct iphdr *)(skb->data + sizeof(struct ethhdr));
 
-	pu8UdpBuffer = (char *)ih + sizeof(struct iphdr);
-	if ((pu8UdpBuffer[1] == 68 && pu8UdpBuffer[3] == 67) ||
-	    (pu8UdpBuffer[1] == 67 && pu8UdpBuffer[3] == 68))
-		PRINT_D(GENERIC_DBG, "DHCP Message transmitted, type:%x %x %x\n", pu8UdpBuffer[248], pu8UdpBuffer[249], pu8UdpBuffer[250]);
+	udp_buf = (char *)ih + sizeof(struct iphdr);
+	if ((udp_buf[1] == 68 && udp_buf[3] == 67) ||
+	    (udp_buf[1] == 67 && udp_buf[3] == 68))
+		PRINT_D(GENERIC_DBG, "DHCP Message transmitted, type:%x %x %x\n",
+			udp_buf[248], udp_buf[249], udp_buf[250]);
 
 	PRINT_D(TX_DBG, "Sending packet - Size = %d - Address = %p - SKB = %p\n", tx_data->size, tx_data->buff, tx_data->skb);
 	PRINT_D(TX_DBG, "Adding tx packet to TX Queue\n");
-- 
1.9.1

