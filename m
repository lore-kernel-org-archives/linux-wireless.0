Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17191 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755723Ab3KEXCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 18:02:16 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.13 2/2] mwifiex: fix wrong eth_hdr usage for bridged packets in AP mode
Date: Tue, 5 Nov 2013 15:01:45 -0800
Message-ID: <1383692505-12654-2-git-send-email-bzhao@marvell.com> (sfid-20131106_000219_139313_D5B6D8F2)
In-Reply-To: <1383692505-12654-1-git-send-email-bzhao@marvell.com>
References: <1383692505-12654-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ujjal Roy <royujjal@gmail.com>

The eth_hdr is never defined in this driver but it gets compiled
without any warning/error because kernel has defined eth_hdr.

Fix it by defining our own p_ethhdr and use it instead of eth_hdr.

Cc: <stable@vger.kernel.org> # 3.7+
Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_txrx.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 1cfe5a7..92f76d6 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -97,6 +97,7 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	struct mwifiex_txinfo *tx_info;
 	int hdr_chop;
 	struct timeval tv;
+	struct ethhdr *p_ethhdr;
 	u8 rfc1042_eth_hdr[ETH_ALEN] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
 
 	uap_rx_pd = (struct uap_rxpd *)(skb->data);
@@ -112,14 +113,36 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	}
 
 	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr,
-		    rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr)))
+		    rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr))) {
+		/* Replace the 803 header and rfc1042 header (llc/snap) with
+		 * an Ethernet II header, keep the src/dst and snap_type
+		 * (ethertype).
+		 *
+		 * The firmware only passes up SNAP frames converting all RX
+		 * data from 802.11 to 802.2/LLC/SNAP frames.
+		 *
+		 * To create the Ethernet II, just move the src, dst address
+		 * right before the snap_type.
+		 */
+		p_ethhdr = (struct ethhdr *)
+			((u8 *)(&rx_pkt_hdr->eth803_hdr)
+			 + sizeof(rx_pkt_hdr->eth803_hdr)
+			 + sizeof(rx_pkt_hdr->rfc1042_hdr)
+			 - sizeof(rx_pkt_hdr->eth803_hdr.h_dest)
+			 - sizeof(rx_pkt_hdr->eth803_hdr.h_source)
+			 - sizeof(rx_pkt_hdr->rfc1042_hdr.snap_type));
+		memcpy(p_ethhdr->h_source, rx_pkt_hdr->eth803_hdr.h_source,
+		       sizeof(p_ethhdr->h_source));
+		memcpy(p_ethhdr->h_dest, rx_pkt_hdr->eth803_hdr.h_dest,
+		       sizeof(p_ethhdr->h_dest));
 		/* Chop off the rxpd + the excess memory from
 		 * 802.2/llc/snap header that was removed.
 		 */
-		hdr_chop = (u8 *)eth_hdr - (u8 *)uap_rx_pd;
-	else
+		hdr_chop = (u8 *)p_ethhdr - (u8 *)uap_rx_pd;
+	} else {
 		/* Chop off the rxpd */
 		hdr_chop = (u8 *)&rx_pkt_hdr->eth803_hdr - (u8 *)uap_rx_pd;
+	}
 
 	/* Chop off the leading header bytes so the it points
 	 * to the start of either the reconstructed EthII frame
-- 
1.8.2.3

