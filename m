Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10939 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbaEVFDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 01:03:04 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/5] mwifiex: update seq number correctly for packets from TDLS peer
Date: Wed, 21 May 2014 22:02:31 -0700
Message-ID: <1400734951-6851-5-git-send-email-bzhao@marvell.com> (sfid-20140522_070309_181007_7C7FAA68)
In-Reply-To: <1400734951-6851-1-git-send-email-bzhao@marvell.com>
References: <1400734951-6851-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds handling of updating rx sequence number for
packets received from TDLS peer. Current implementation of
mwifiex_queueing_ra_based assumes station would always receive
packets from AP which is not true in case of TDLS.
Fix this by adding this case.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h     |  3 ++-
 drivers/net/wireless/mwifiex/sta_rx.c | 16 ++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index ee59508..42eaeda 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -539,6 +539,7 @@ struct mwifiex_ie_types_data {
 #define MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET 0x01
 #define MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET 0x08
 #define MWIFIEX_TXPD_FLAGS_TDLS_PACKET      0x10
+#define MWIFIEX_RXPD_FLAGS_TDLS_PACKET      0x01
 
 struct txpd {
 	u8 bss_type;
@@ -581,7 +582,7 @@ struct rxpd {
 	 * [Bit 7] Reserved
 	 */
 	u8 ht_info;
-	u8 reserved;
+	u8 flags;
 } __packed;
 
 struct uap_txpd {
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index ed26387..8b639d7 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -183,6 +183,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 	struct rx_packet_hdr *rx_pkt_hdr;
 	u8 ta[ETH_ALEN];
 	u16 rx_pkt_type, rx_pkt_offset, rx_pkt_length, seq_num;
+	struct mwifiex_sta_node *sta_ptr;
 
 	local_rx_pd = (struct rxpd *) (skb->data);
 	rx_pkt_type = le16_to_cpu(local_rx_pd->rx_pkt_type);
@@ -213,14 +214,25 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 	 * If the packet is not an unicast packet then send the packet
 	 * directly to os. Don't pass thru rx reordering
 	 */
-	if (!IS_11N_ENABLED(priv) ||
+	if ((!IS_11N_ENABLED(priv) &&
+	     !(ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
+	       !(local_rx_pd->flags & MWIFIEX_RXPD_FLAGS_TDLS_PACKET))) ||
 	    !ether_addr_equal_unaligned(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest)) {
 		mwifiex_process_rx_packet(priv, skb);
 		return ret;
 	}
 
-	if (mwifiex_queuing_ra_based(priv)) {
+	if (mwifiex_queuing_ra_based(priv) ||
+	    (ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
+	     local_rx_pd->flags & MWIFIEX_RXPD_FLAGS_TDLS_PACKET)) {
 		memcpy(ta, rx_pkt_hdr->eth803_hdr.h_source, ETH_ALEN);
+		if (local_rx_pd->flags & MWIFIEX_RXPD_FLAGS_TDLS_PACKET &&
+		    local_rx_pd->priority < MAX_NUM_TID) {
+			sta_ptr = mwifiex_get_sta_entry(priv, ta);
+			if (sta_ptr)
+				sta_ptr->rx_seq[local_rx_pd->priority] =
+					      le16_to_cpu(local_rx_pd->seq_num);
+		}
 	} else {
 		if (rx_pkt_type != PKT_TYPE_BAR)
 			priv->rx_seq[local_rx_pd->priority] = seq_num;
-- 
1.8.2.3

