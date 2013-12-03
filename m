Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37003 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043Ab3LCHS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 02:18:26 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 03/12] mwifiex: remove rfc1042_eth_hdr variable
Date: Mon, 2 Dec 2013 23:17:50 -0800
Message-ID: <1386055079-6623-4-git-send-email-bzhao@marvell.com> (sfid-20131203_081830_139300_27DC13D7)
In-Reply-To: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
References: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Use 'rfc1042_header' available in net/wireless/util.c

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_rx.c   | 5 ++---
 drivers/net/wireless/mwifiex/uap_txrx.c | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index bb22664..241c0e5 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -88,15 +88,14 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 	struct rxpd *local_rx_pd;
 	int hdr_chop;
 	struct ethhdr *eth_hdr;
-	u8 rfc1042_eth_hdr[ETH_ALEN] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
 
 	local_rx_pd = (struct rxpd *) (skb->data);
 
 	rx_pkt_hdr = (void *)local_rx_pd +
 		     le16_to_cpu(local_rx_pd->rx_pkt_offset);
 
-	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr,
-		    rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr))) {
+	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr, rfc1042_header,
+		    sizeof(rfc1042_header))) {
 		/*
 		 *  Replace the 803 header and rfc1042 header (llc/snap) with an
 		 *    EthernetII header, keep the src/dst and snap_type
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 92f76d6..0d4b7d6 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -98,7 +98,6 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	int hdr_chop;
 	struct timeval tv;
 	struct ethhdr *p_ethhdr;
-	u8 rfc1042_eth_hdr[ETH_ALEN] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
 
 	uap_rx_pd = (struct uap_rxpd *)(skb->data);
 	rx_pkt_hdr = (void *)uap_rx_pd + le16_to_cpu(uap_rx_pd->rx_pkt_offset);
@@ -112,8 +111,8 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 		return;
 	}
 
-	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr,
-		    rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr))) {
+	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr, rfc1042_header,
+		    sizeof(rfc1042_header))) {
 		/* Replace the 803 header and rfc1042 header (llc/snap) with
 		 * an Ethernet II header, keep the src/dst and snap_type
 		 * (ethertype).
-- 
1.8.2.3

