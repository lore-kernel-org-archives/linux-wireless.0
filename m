Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49841 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab3LCHSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 02:18:45 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 05/12] mwifiex: avoid using variable name eth_hdr
Date: Mon, 2 Dec 2013 23:17:52 -0800
Message-ID: <1386055079-6623-6-git-send-email-bzhao@marvell.com> (sfid-20131203_082500_195601_585C1635)
In-Reply-To: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
References: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

eth_hdr is defined in kernel. Use a different variable name in
our functions.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_rx.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 4523899..d74192d 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -36,12 +36,12 @@ mwifiex_discard_gratuitous_arp(struct mwifiex_private *priv,
 			       struct sk_buff *skb)
 {
 	const struct mwifiex_arp_eth_header *arp;
-	struct ethhdr *eth_hdr;
+	struct ethhdr *eth;
 	struct ipv6hdr *ipv6;
 	struct icmp6hdr *icmpv6;
 
-	eth_hdr = (struct ethhdr *)skb->data;
-	switch (ntohs(eth_hdr->h_proto)) {
+	eth = (struct ethhdr *)skb->data;
+	switch (ntohs(eth->h_proto)) {
 	case ETH_P_ARP:
 		arp = (void *)(skb->data + sizeof(struct ethhdr));
 		if (arp->hdr.ar_op == htons(ARPOP_REPLY) ||
@@ -87,7 +87,7 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 	struct rx_packet_hdr *rx_pkt_hdr;
 	struct rxpd *local_rx_pd;
 	int hdr_chop;
-	struct ethhdr *eth_hdr;
+	struct ethhdr *eth;
 
 	local_rx_pd = (struct rxpd *) (skb->data);
 
@@ -109,7 +109,7 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 		 *  To create the Ethernet II, just move the src, dst address
 		 *    right before the snap_type.
 		 */
-		eth_hdr = (struct ethhdr *)
+		eth = (struct ethhdr *)
 			((u8 *) &rx_pkt_hdr->eth803_hdr
 			 + sizeof(rx_pkt_hdr->eth803_hdr) +
 			 sizeof(rx_pkt_hdr->rfc1042_hdr)
@@ -117,14 +117,14 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 			 - sizeof(rx_pkt_hdr->eth803_hdr.h_source)
 			 - sizeof(rx_pkt_hdr->rfc1042_hdr.snap_type));
 
-		memcpy(eth_hdr->h_source, rx_pkt_hdr->eth803_hdr.h_source,
-		       sizeof(eth_hdr->h_source));
-		memcpy(eth_hdr->h_dest, rx_pkt_hdr->eth803_hdr.h_dest,
-		       sizeof(eth_hdr->h_dest));
+		memcpy(eth->h_source, rx_pkt_hdr->eth803_hdr.h_source,
+		       sizeof(eth->h_source));
+		memcpy(eth->h_dest, rx_pkt_hdr->eth803_hdr.h_dest,
+		       sizeof(eth->h_dest));
 
 		/* Chop off the rxpd + the excess memory from the 802.2/llc/snap
 		   header that was removed. */
-		hdr_chop = (u8 *) eth_hdr - (u8 *) local_rx_pd;
+		hdr_chop = (u8 *) eth - (u8 *) local_rx_pd;
 	} else {
 		/* Chop off the rxpd */
 		hdr_chop = (u8 *) &rx_pkt_hdr->eth803_hdr -
-- 
1.8.2.3

