Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63378 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142Ab3LCHSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 02:18:42 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 04/12] mwifiex: fix an issue with Appletalk devices
Date: Mon, 2 Dec 2013 23:17:51 -0800
Message-ID: <1386055079-6623-5-git-send-email-bzhao@marvell.com> (sfid-20131203_081854_736434_18A336FD)
In-Reply-To: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
References: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

SNAP/LLC header in the AARP packet is being stripped off while
preparing an EthernetII header.
Annex M, Table M.3 in 802.11 spec says that some header
(ex. AppleTalk AARP(2)) should pass through untouched.
This patch modifies the check to exclude/include EthernetII
header translation for special cases.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_rx.c   | 8 ++++++--
 drivers/net/wireless/mwifiex/uap_txrx.c | 8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 241c0e5..4523899 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -94,8 +94,12 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 	rx_pkt_hdr = (void *)local_rx_pd +
 		     le16_to_cpu(local_rx_pd->rx_pkt_offset);
 
-	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr, rfc1042_header,
-		    sizeof(rfc1042_header))) {
+	if ((!memcmp(&rx_pkt_hdr->rfc1042_hdr, bridge_tunnel_header,
+		     sizeof(bridge_tunnel_header))) ||
+	    (!memcmp(&rx_pkt_hdr->rfc1042_hdr, rfc1042_header,
+		     sizeof(rfc1042_header)) &&
+	     ntohs(rx_pkt_hdr->rfc1042_hdr.snap_type) != ETH_P_AARP &&
+	     ntohs(rx_pkt_hdr->rfc1042_hdr.snap_type) != ETH_P_IPX)) {
 		/*
 		 *  Replace the 803 header and rfc1042 header (llc/snap) with an
 		 *    EthernetII header, keep the src/dst and snap_type
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 0d4b7d6..a0bd954 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -111,8 +111,12 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 		return;
 	}
 
-	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr, rfc1042_header,
-		    sizeof(rfc1042_header))) {
+	if ((!memcmp(&rx_pkt_hdr->rfc1042_hdr, bridge_tunnel_header,
+		     sizeof(bridge_tunnel_header))) ||
+	    (!memcmp(&rx_pkt_hdr->rfc1042_hdr, rfc1042_header,
+		     sizeof(rfc1042_header)) &&
+	     ntohs(rx_pkt_hdr->rfc1042_hdr.snap_type) != ETH_P_AARP &&
+	     ntohs(rx_pkt_hdr->rfc1042_hdr.snap_type) != ETH_P_IPX)) {
 		/* Replace the 803 header and rfc1042 header (llc/snap) with
 		 * an Ethernet II header, keep the src/dst and snap_type
 		 * (ethertype).
-- 
1.8.2.3

