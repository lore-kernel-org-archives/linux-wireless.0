Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:33577 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0LGXL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 18:11:57 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: replace struct eth_803_hdr with ethhdr
Date: Tue,  7 Dec 2010 15:11:55 -0800
Message-Id: <1291763515-1203-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1291763515-1203-1-git-send-email-bzhao@marvell.com>
References: <1291763515-1203-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"struct ethhdr" is defined in include/linux/if_ether.h

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |   24 +++++++++---------------
 drivers/net/wireless/mwifiex/fw.h       |   10 +---------
 drivers/net/wireless/mwifiex/sta_rx.c   |   20 ++++++++++----------
 3 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index a9a28ed..e100ffc 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -169,16 +169,10 @@ mwifiex_11n_get_num_aggr_pkts(u8 *data, int total_pkt_len)
 					(data
 					 +
 					 (2 * MWIFIEX_MAC_ADDR_LENGTH))));
-		pad = (((pkt_len + sizeof(struct eth_803_hdr)) & 3)) ? (4 -
-				((pkt_len
-				  +
-				  sizeof
-				  (struct
-				   eth_803_hdr))
-				 & 3)) :
-			0;
-		data += pkt_len + pad + sizeof(struct eth_803_hdr);
-		total_pkt_len -= pkt_len + pad + sizeof(struct eth_803_hdr);
+		pad = (((pkt_len + sizeof(struct ethhdr)) & 3)) ?
+			(4 - ((pkt_len + sizeof(struct ethhdr)) & 3)) : 0;
+		data += pkt_len + pad + sizeof(struct ethhdr);
+		total_pkt_len -= pkt_len + pad + sizeof(struct ethhdr);
 		++pkt_count;
 	}
 
@@ -237,21 +231,21 @@ mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 			break;
 		}
 
-		pad = (((pkt_len + sizeof(struct eth_803_hdr)) & 3)) ?
-			(4 - ((pkt_len + sizeof(struct eth_803_hdr)) & 3)) : 0;
+		pad = (((pkt_len + sizeof(struct ethhdr)) & 3)) ?
+			(4 - ((pkt_len + sizeof(struct ethhdr)) & 3)) : 0;
 
-		total_pkt_len -= pkt_len + pad + sizeof(struct eth_803_hdr);
+		total_pkt_len -= pkt_len + pad + sizeof(struct ethhdr);
 
 		if (memcmp(&rx_pkt_hdr->rfc1042_hdr,
 			   rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr)) == 0) {
 			memmove(data + LLC_SNAP_LEN, data,
 				(2 * MWIFIEX_MAC_ADDR_LENGTH));
 			data += LLC_SNAP_LEN;
-			pkt_len += sizeof(struct eth_803_hdr) - LLC_SNAP_LEN;
+			pkt_len += sizeof(struct ethhdr) - LLC_SNAP_LEN;
 		} else {
 			*(u16 *) (data + (2 * MWIFIEX_MAC_ADDR_LENGTH))
 				= (u16) 0;
-			pkt_len += sizeof(struct eth_803_hdr);
+			pkt_len += sizeof(struct ethhdr);
 		}
 
 		mbuf_daggr = mwifiex_alloc_buffer(pkt_len);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 86e8a96..95b3d2f 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -25,25 +25,17 @@
 
 #define INTF_HEADER_LEN     4
 
-struct eth_803_hdr {
-	u8 dest_addr[MWIFIEX_MAC_ADDR_LENGTH];
-	u8 src_addr[MWIFIEX_MAC_ADDR_LENGTH];
-	u16 h803_len;
-};
-
 struct rfc_1042_hdr {
 	u8 llc_dsap;
 	u8 llc_ssap;
 	u8 llc_ctrl;
 	u8 snap_oui[3];
 	u16 snap_type;
-
 };
 
 struct rx_packet_hdr {
-	struct eth_803_hdr eth803_hdr;
+	struct ethhdr eth803_hdr;
 	struct rfc_1042_hdr rfc1042_hdr;
-
 };
 
 #define B_SUPPORTED_RATES               5
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 022ae4b..47e20ad 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -88,10 +88,10 @@ mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 	       mbuf->data_len, local_rx_pd->rx_pkt_offset,
 	       mbuf->data_len - local_rx_pd->rx_pkt_offset);
 
-	HEXDUMP("RX Data: Dest", rx_pkt_hdr->eth803_hdr.dest_addr,
-		sizeof(rx_pkt_hdr->eth803_hdr.dest_addr));
-	HEXDUMP("RX Data: Src", rx_pkt_hdr->eth803_hdr.src_addr,
-		sizeof(rx_pkt_hdr->eth803_hdr.src_addr));
+	HEXDUMP("RX Data: Dest", rx_pkt_hdr->eth803_hdr.h_dest,
+		sizeof(rx_pkt_hdr->eth803_hdr.h_dest));
+	HEXDUMP("RX Data: Src", rx_pkt_hdr->eth803_hdr.h_source,
+		sizeof(rx_pkt_hdr->eth803_hdr.h_source));
 
 	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr,
 		    rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr))) {
@@ -108,13 +108,13 @@ mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 			((u8 *) &rx_pkt_hdr->eth803_hdr
 			 + sizeof(rx_pkt_hdr->eth803_hdr) +
 			 sizeof(rx_pkt_hdr->rfc1042_hdr)
-			 - sizeof(rx_pkt_hdr->eth803_hdr.dest_addr)
-			 - sizeof(rx_pkt_hdr->eth803_hdr.src_addr)
+			 - sizeof(rx_pkt_hdr->eth803_hdr.h_dest)
+			 - sizeof(rx_pkt_hdr->eth803_hdr.h_source)
 			 - sizeof(rx_pkt_hdr->rfc1042_hdr.snap_type));
 
-		memcpy(eth_hdr->h_source, rx_pkt_hdr->eth803_hdr.src_addr,
+		memcpy(eth_hdr->h_source, rx_pkt_hdr->eth803_hdr.h_source,
 		       sizeof(eth_hdr->h_source));
-		memcpy(eth_hdr->h_dest, rx_pkt_hdr->eth803_hdr.dest_addr,
+		memcpy(eth_hdr->h_dest, rx_pkt_hdr->eth803_hdr.h_dest,
 		       sizeof(eth_hdr->h_dest));
 
 		/* Chop off the rxpd + the excess memory from the 802.2/llc/snap
@@ -217,14 +217,14 @@ mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	 * directly to os. Don't pass thru rx reordering
 	 */
 	if (!IS_11N_ENABLED(priv) ||
-	    memcmp(priv->curr_addr, rx_pkt_hdr->eth803_hdr.dest_addr,
+	    memcmp(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest,
 		   MWIFIEX_MAC_ADDR_LENGTH)) {
 		mwifiex_process_rx_packet(adapter, mbuf);
 		goto done;
 	}
 
 	if (mwifiex_queuing_ra_based(priv)) {
-		memcpy(ta, rx_pkt_hdr->eth803_hdr.src_addr,
+		memcpy(ta, rx_pkt_hdr->eth803_hdr.h_source,
 		       MWIFIEX_MAC_ADDR_LENGTH);
 	} else {
 		if (rx_pkt_type != PKT_TYPE_BAR)
-- 
1.7.0.2

