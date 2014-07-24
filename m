Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58180 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaGXJ0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 05:26:01 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so2452307wes.5
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 02:25:59 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2] ath10k: handle attention flags correctly when using A-MSDU
Date: Thu, 24 Jul 2014 11:25:31 +0200
Message-Id: <1406193931-5478-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140724_112613_353609_6E922CC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of A-MSDU RX we should check attention flags
correctly to be sure we report correct FCS status for
A-MSDU subframes. Without a patch we could report A-MSDU
subframes with wrong FCS as a correct to the stack, next
get a lot of DUP ACK TCP packets. Finally TP drop is seen
and this drop depends on FCS errors ratio for A-MSDU frame.

Example test case when TP drop is seen:
- ath10k configured as an AP
- used ath10k station
- forced A-MSDU (7 frames) on STA
- other traffic on channel (often FCS errors)
- monitor iface added on AP
- TCP STA -> AP traffic (iperf)

a) Iperf logs for case without the patch:

echo "1 64" > htt_max_amsdu_ampdu // disable A-MSDU
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 5.0 sec  56.6 MBytes  95.0 Mbits/sec
[  3]  5.0-10.0 sec  60.4 MBytes   101 Mbits/sec
[  3] 10.0-15.0 sec  60.2 MBytes   101 Mbits/sec
[  3] 15.0-20.0 sec  60.2 MBytes   101 Mbits/sec
[  3] 20.0-25.0 sec  63.8 MBytes   107 Mbits/sec
[  3] 25.0-30.0 sec  64.9 MBytes   109 Mbits/sec

echo "7 64" > htt_max_amsdu_ampdu  // set 7 A-MSDU subframes
[  3] 30.0-35.0 sec  40.0 MBytes  67.1 Mbits/sec
[  3] 35.0-40.0 sec  35.9 MBytes  60.2 Mbits/sec
[  3] 40.0-45.0 sec  36.9 MBytes  61.9 Mbits/sec
[  3] 45.0-50.0 sec  37.9 MBytes  63.5 Mbits/sec
[  3] 50.0-55.0 sec  34.5 MBytes  57.9 Mbits/sec
[  3] 55.0-60.0 sec  25.4 MBytes  42.6 Mbits/sec
[  3] 60.0-65.0 sec  48.2 MBytes  81.0 Mbits/sec
[  3] 65.0-70.0 sec  28.8 MBytes  48.2 Mbits/sec
[  3] 70.0-75.0 sec  29.2 MBytes  49.1 Mbits/sec
[  3] 75.0-80.0 sec  22.9 MBytes  38.4 Mbits/sec
[  3] 80.0-85.0 sec  26.4 MBytes  44.2 Mbits/sec
[  3] 85.0-90.0 sec  31.5 MBytes  52.8 Mbits/sec

b) Iperf logs for case with patch:

echo "1 64" > htt_max_amsdu_ampdu // disable A-MSDU
[  3] local 192.168.12.2 port 57512 connected with 192.168.12.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 5.0 sec  60.8 MBytes   102 Mbits/sec
[  3]  5.0-10.0 sec  62.2 MBytes   104 Mbits/sec
[  3] 10.0-15.0 sec  60.9 MBytes   102 Mbits/sec

echo "7 64" > htt_max_amsdu_ampdu  // set 7 A-MSDU subframes
[  3] 15.0-20.0 sec  68.1 MBytes   114 Mbits/sec
[  3] 20.0-25.0 sec  80.5 MBytes   135 Mbits/sec
[  3] 25.0-30.0 sec  83.0 MBytes   139 Mbits/sec
[  3] 30.0-35.0 sec  79.1 MBytes   133 Mbits/sec
[  3] 35.0-40.0 sec  77.1 MBytes   129 Mbits/sec
[  3] 40.0-45.0 sec  77.4 MBytes   130 Mbits/sec

Reported-by: Denton Gentry <denton.gentry@gmail.com>
Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
*v2 - changed commit message

 drivers/net/wireless/ath/ath10k/htt_rx.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 8e14c58..4767d22 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -307,7 +307,8 @@ static void ath10k_htt_rx_free_msdu_chain(struct sk_buff *skb)
 static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 				   u8 **fw_desc, int *fw_desc_len,
 				   struct sk_buff **head_msdu,
-				   struct sk_buff **tail_msdu)
+				   struct sk_buff **tail_msdu,
+				   u32 *attention)
 {
 	int msdu_len, msdu_chaining = 0;
 	struct sk_buff *msdu;
@@ -357,6 +358,11 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 			break;
 		}
 
+		*attention |= __le32_to_cpu(rx_desc->attention.flags) &
+					    (RX_ATTENTION_FLAGS_TKIP_MIC_ERR |
+					     RX_ATTENTION_FLAGS_DECRYPT_ERR |
+					     RX_ATTENTION_FLAGS_FCS_ERR |
+					     RX_ATTENTION_FLAGS_MGMT_TYPE);
 		/*
 		 * Copy the FW rx descriptor for this MSDU from the rx
 		 * indication message into the MSDU's netbuf. HL uses the
@@ -1256,13 +1262,15 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 		for (j = 0; j < mpdu_ranges[i].mpdu_count; j++) {
 			struct sk_buff *msdu_head, *msdu_tail;
 
+			attention = 0;
 			msdu_head = NULL;
 			msdu_tail = NULL;
 			ret = ath10k_htt_rx_amsdu_pop(htt,
 						      &fw_desc,
 						      &fw_desc_len,
 						      &msdu_head,
-						      &msdu_tail);
+						      &msdu_tail,
+						      &attention);
 
 			if (ret < 0) {
 				ath10k_warn("failed to pop amsdu from htt rx ring %d\n",
@@ -1274,7 +1282,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			rxd = container_of((void *)msdu_head->data,
 					   struct htt_rx_desc,
 					   msdu_payload);
-			attention = __le32_to_cpu(rxd->attention.flags);
 
 			if (!ath10k_htt_rx_amsdu_allowed(htt, msdu_head,
 							 status,
@@ -1327,6 +1334,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	u8 *fw_desc;
 	int fw_desc_len, hdrlen, paramlen;
 	int trim;
+	u32 attention = 0;
 
 	fw_desc_len = __le16_to_cpu(frag->fw_rx_desc_bytes);
 	fw_desc = (u8 *)frag->fw_msdu_rx_desc;
@@ -1336,7 +1344,8 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 
 	spin_lock_bh(&htt->rx_ring.lock);
 	ret = ath10k_htt_rx_amsdu_pop(htt, &fw_desc, &fw_desc_len,
-				      &msdu_head, &msdu_tail);
+				      &msdu_head, &msdu_tail,
+				      &attention);
 	spin_unlock_bh(&htt->rx_ring.lock);
 
 	ath10k_dbg(ATH10K_DBG_HTT_DUMP, "htt rx frag ahead\n");
@@ -1353,10 +1362,8 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 
 	hdr = (struct ieee80211_hdr *)msdu_head->data;
 	rxd = (void *)msdu_head->data - sizeof(*rxd);
-	tkip_mic_err = !!(__le32_to_cpu(rxd->attention.flags) &
-				RX_ATTENTION_FLAGS_TKIP_MIC_ERR);
-	decrypt_err = !!(__le32_to_cpu(rxd->attention.flags) &
-				RX_ATTENTION_FLAGS_DECRYPT_ERR);
+	tkip_mic_err = !!(attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR);
+	decrypt_err = !!(attention & RX_ATTENTION_FLAGS_DECRYPT_ERR);
 	fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
 			RX_MSDU_START_INFO1_DECAP_FORMAT);
 
-- 
1.7.9.5

