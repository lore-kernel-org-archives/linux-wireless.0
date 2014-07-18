Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64161 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaGRIfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 04:35:01 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so425145wiv.15
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2014 01:34:59 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: extend debug code for RX path
Date: Fri, 18 Jul 2014 10:34:31 +0200
Message-Id: <1405672472-16302-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140718_103508_366995_D06E95E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print sequence number, AMSDU_MORE flag and AC when additional
debug enabled in RX path. This is usefull for debugging purpose.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   32 ++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6db0e49..04140e3 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -819,19 +819,46 @@ static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
 	return true;
 }
 
+static char *tid_to_ac[] = {
+	"BE(0)",
+	"BK(1)",
+	"BK(2)",
+	"BE(3)",
+	"VI(4)",
+	"VI(5)",
+	"VO(6)",
+	"VO(7)",
+	"tid(8)",
+	"tid(9)",
+	"tid(10)",
+	"tid(11)",
+	"tid(12)",
+	"tid(13)",
+	"tid(14)",
+	"tid(15)",
+};
+
 static void ath10k_process_rx(struct ath10k *ar,
 			      struct ieee80211_rx_status *rx_status,
 			      struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *status;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	status = IEEE80211_SKB_RXCB(skb);
 	*status = *rx_status;
 
 	ath10k_dbg(ATH10K_DBG_DATA,
-		   "rx skb %p len %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %imic-err %i\n",
+		   "rx skb %p len %u peer %pM %s sn %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
 		   skb,
 		   skb->len,
+		   ieee80211_get_SA(hdr),
+		   ieee80211_is_data_qos(hdr->frame_control) ?
+			(tid_to_ac[*(ieee80211_get_qos_ctl(hdr)) &
+				   IEEE80211_QOS_CTL_TID_MASK]) :
+			(is_multicast_ether_addr(ieee80211_get_DA(hdr)) ?
+				"mcast" : "ucast"),
+		   (__le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4,
 		   status->flag == 0 ? "legacy" : "",
 		   status->flag & RX_FLAG_HT ? "ht" : "",
 		   status->flag & RX_FLAG_VHT ? "vht" : "",
@@ -843,7 +870,8 @@ static void ath10k_process_rx(struct ath10k *ar,
 		   status->freq,
 		   status->band, status->flag,
 		   !!(status->flag & RX_FLAG_FAILED_FCS_CRC),
-		   !!(status->flag & RX_FLAG_MMIC_ERROR));
+		   !!(status->flag & RX_FLAG_MMIC_ERROR),
+		   !!(status->flag & RX_FLAG_AMSDU_MORE));
 	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "rx skb: ",
 			skb->data, skb->len);
 
-- 
1.7.9.5

