Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:33576 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0LGXMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 18:12:08 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: replace struct eth_II_hdr with ethhdr
Date: Tue,  7 Dec 2010 15:11:54 -0800
Message-Id: <1291763515-1203-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"struct ethhdr" is defined in include/linux/if_ether.h

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h     |    3 +++
 drivers/net/wireless/mwifiex/sta_rx.c |   22 ++++++----------------
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index ed691ac..86e8a96 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -20,6 +20,9 @@
 #ifndef _MWIFIEX_FW_H_
 #define _MWIFIEX_FW_H_
 
+#include <linux/if_ether.h>
+
+
 #define INTF_HEADER_LEN     4
 
 struct eth_803_hdr {
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 504c377..022ae4b 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -26,16 +26,6 @@
 #include "11n_aggr.h"
 #include "11n_rxreorder.h"
 
-/** Ethernet II header */
-struct eth_II_hdr {
-	/** Ethernet II header destination address */
-	u8 dest_addr[MWIFIEX_MAC_ADDR_LENGTH];
-	/** Ethernet II header source address */
-	u8 src_addr[MWIFIEX_MAC_ADDR_LENGTH];
-	/** Ethernet II header length */
-	u16 ethertype;
-};
-
 /*
  * This function processes the received packet and forwards it
  * to kernel/upper layer.
@@ -58,7 +48,7 @@ mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 	struct rx_packet_hdr *rx_pkt_hdr;
 	struct rxpd *local_rx_pd;
 	int hdr_chop;
-	struct eth_II_hdr *eth_hdr;
+	struct ethhdr *eth_hdr;
 	u8 rfc1042_eth_hdr[MWIFIEX_MAC_ADDR_LENGTH] = { 0xaa, 0xaa, 0x03,
 							0x00, 0x00, 0x00 };
 
@@ -114,7 +104,7 @@ mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 		 *  To create the Ethernet II, just move the src, dst address
 		 *    right before the snap_type.
 		 */
-		eth_hdr = (struct eth_II_hdr *)
+		eth_hdr = (struct ethhdr *)
 			((u8 *) &rx_pkt_hdr->eth803_hdr
 			 + sizeof(rx_pkt_hdr->eth803_hdr) +
 			 sizeof(rx_pkt_hdr->rfc1042_hdr)
@@ -122,10 +112,10 @@ mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 			 - sizeof(rx_pkt_hdr->eth803_hdr.src_addr)
 			 - sizeof(rx_pkt_hdr->rfc1042_hdr.snap_type));
 
-		memcpy(eth_hdr->src_addr, rx_pkt_hdr->eth803_hdr.src_addr,
-		       sizeof(eth_hdr->src_addr));
-		memcpy(eth_hdr->dest_addr, rx_pkt_hdr->eth803_hdr.dest_addr,
-		       sizeof(eth_hdr->dest_addr));
+		memcpy(eth_hdr->h_source, rx_pkt_hdr->eth803_hdr.src_addr,
+		       sizeof(eth_hdr->h_source));
+		memcpy(eth_hdr->h_dest, rx_pkt_hdr->eth803_hdr.dest_addr,
+		       sizeof(eth_hdr->h_dest));
 
 		/* Chop off the rxpd + the excess memory from the 802.2/llc/snap
 		   header that was removed. */
-- 
1.7.0.2

