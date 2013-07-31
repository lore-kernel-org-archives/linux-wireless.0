Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42466 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab3GaIsK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 04:48:10 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: implement rx checksum offloading
Date: Wed, 31 Jul 2013 10:47:56 +0200
Message-ID: <1375260477-17030-2-git-send-email-michal.kazior@tieto.com> (sfid-20130731_104816_204078_5809B1C1)
In-Reply-To: <1375260477-17030-1-git-send-email-michal.kazior@tieto.com>
References: <1375260477-17030-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HW supports L3/L4 rx checksum offloading.

This should reduce CPU load and improve
performance on slow host machines.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   40 ++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 04f08d9..e784c40 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -804,6 +804,37 @@ static bool ath10k_htt_rx_has_fcs_err(struct sk_buff *skb)
 	return false;
 }
 
+static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb)
+{
+	struct htt_rx_desc *rxd;
+	u32 flags, info;
+	bool is_ip4, is_ip6;
+	bool is_tcp, is_udp;
+	bool ip_csum_ok, tcpudp_csum_ok;
+
+	rxd = (void *)skb->data - sizeof(*rxd);
+	flags = __le32_to_cpu(rxd->attention.flags);
+	info = __le32_to_cpu(rxd->msdu_start.info1);
+
+	is_ip4 = !!(info & RX_MSDU_START_INFO1_IPV4_PROTO);
+	is_ip6 = !!(info & RX_MSDU_START_INFO1_IPV6_PROTO);
+	is_tcp = !!(info & RX_MSDU_START_INFO1_TCP_PROTO);
+	is_udp = !!(info & RX_MSDU_START_INFO1_UDP_PROTO);
+	ip_csum_ok = !(flags & RX_ATTENTION_FLAGS_IP_CHKSUM_FAIL);
+	tcpudp_csum_ok = !(flags & RX_ATTENTION_FLAGS_TCP_UDP_CHKSUM_FAIL);
+
+	if (!is_ip4 && !is_ip6)
+		return CHECKSUM_NONE;
+	if (!is_tcp && !is_udp)
+		return CHECKSUM_NONE;
+	if (!ip_csum_ok)
+		return CHECKSUM_NONE;
+	if (!tcpudp_csum_ok)
+		return CHECKSUM_NONE;
+
+	return CHECKSUM_UNNECESSARY;
+}
+
 static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				  struct htt_rx_indication *rx)
 {
@@ -815,6 +846,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	u8 *fw_desc;
 	int i, j;
 	int ret;
+	int ip_summed;
 
 	memset(&info, 0, sizeof(info));
 
@@ -889,6 +921,11 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				continue;
 			}
 
+			/* The skb is not yet processed and it may be
+			 * reallocated. Since the offload is in the original
+			 * skb extract the checksum now and assign it later */
+			ip_summed = ath10k_htt_rx_get_csum_state(msdu_head);
+
 			info.skb     = msdu_head;
 			info.fcs_err = ath10k_htt_rx_has_fcs_err(msdu_head);
 			info.signal  = ATH10K_DEFAULT_NOISE_FLOOR;
@@ -914,6 +951,8 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			if (ath10k_htt_rx_hdr_is_amsdu((void *)info.skb->data))
 				ath10k_dbg(ATH10K_DBG_HTT, "htt mpdu is amsdu\n");
 
+			info.skb->ip_summed = ip_summed;
+
 			ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt mpdu: ",
 					info.skb->data, info.skb->len);
 			ath10k_process_rx(htt->ar, &info);
@@ -980,6 +1019,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	info.status = HTT_RX_IND_MPDU_STATUS_OK;
 	info.encrypt_type = MS(__le32_to_cpu(rxd->mpdu_start.info0),
 				RX_MPDU_START_INFO0_ENCRYPT_TYPE);
+	info.skb->ip_summed = ath10k_htt_rx_get_csum_state(info.skb);
 
 	if (tkip_mic_err) {
 		ath10k_warn("tkip mic error\n");
-- 
1.7.9.5

