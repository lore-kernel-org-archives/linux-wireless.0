Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47248 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbaJUOGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 10:06:45 -0400
Received: by mail-lb0-f174.google.com with SMTP id p9so1071279lbv.5
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 07:06:44 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: remove tsf argument from rx_desc tracing
Date: Tue, 21 Oct 2014 15:54:59 +0200
Message-Id: <1413899700-10717-2-git-send-email-michal.kazior@tieto.com> (sfid-20141021_160649_516764_8B2AD04B)
In-Reply-To: <1413899700-10717-1-git-send-email-michal.kazior@tieto.com>
References: <1413899700-10717-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fundamtenally this was wrong. Tsf is only valid
in first MPDU of a PPDU. This means tsf value was
wrong most of the time during heavy traffic.

Also I don't see much point in exposing a
redundant (and broken) tsf value. Userspace can
already read it from the dumped rx descriptor
buffer.

Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 4 +---
 drivers/net/wireless/ath/ath10k/trace.h  | 9 +++------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index fbb3175..d3741b4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -319,7 +319,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 	int msdu_len, msdu_chaining = 0;
 	struct sk_buff *msdu, *next;
 	struct htt_rx_desc *rx_desc;
-	u32 tsf;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
@@ -451,8 +450,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		last_msdu = __le32_to_cpu(rx_desc->msdu_end.info0) &
 				RX_MSDU_END_INFO0_LAST_MSDU;
 
-		tsf = __le32_to_cpu(rx_desc->ppdu_end.tsf_timestamp);
-		trace_ath10k_htt_rx_desc(ar, tsf, &rx_desc->attention,
+		trace_ath10k_htt_rx_desc(ar, &rx_desc->attention,
 					 sizeof(*rx_desc) - sizeof(u32));
 		if (last_msdu) {
 			msdu->next = NULL;
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 9d34e7f..2409cb5 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -282,14 +282,13 @@ TRACE_EVENT(ath10k_htt_pktlog,
 );
 
 TRACE_EVENT(ath10k_htt_rx_desc,
-	    TP_PROTO(struct ath10k *ar, u32 tsf, void *rxdesc, u16 len),
+	    TP_PROTO(struct ath10k *ar, void *rxdesc, u16 len),
 
-	TP_ARGS(ar, tsf, rxdesc, len),
+	TP_ARGS(ar, rxdesc, len),
 
 	TP_STRUCT__entry(
 		__string(device, dev_name(ar->dev))
 		__string(driver, dev_driver_string(ar->dev))
-		__field(u32, tsf)
 		__field(u16, len)
 		__dynamic_array(u8, rxdesc, len)
 	),
@@ -297,16 +296,14 @@ TRACE_EVENT(ath10k_htt_rx_desc,
 	TP_fast_assign(
 		__assign_str(device, dev_name(ar->dev));
 		__assign_str(driver, dev_driver_string(ar->dev));
-		__entry->tsf = tsf;
 		__entry->len = len;
 		memcpy(__get_dynamic_array(rxdesc), rxdesc, len);
 	),
 
 	TP_printk(
-		"%s %s %u len %hu",
+		"%s %s len %hu",
 		__get_str(driver),
 		__get_str(device),
-		__entry->tsf,
 		__entry->len
 	 )
 );
-- 
1.8.5.3

