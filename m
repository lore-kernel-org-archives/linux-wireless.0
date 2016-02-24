Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:5708 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbcBXJv0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 04:51:26 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v3] mac80211: allow not sending MIC up from driver for HW crypto
Date: Wed, 24 Feb 2016 11:49:45 +0200
Message-Id: <1456307385-23014-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160224_105136_188630_9DBD96A9)
In-Reply-To: <1455614328-12528-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1455614328-12528-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When HW crypto is used, there's no need for the CCMP/GCMP MIC to
be available to mac80211, and the hardware might have removed it
already after checking. The MIC is also useless to have when the
frame is already decrypted, so allow indicating that it's not
present.

Since we are running out of bits in mac80211_rx_flags, make
the flags field a u64.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
v3: fix drivers
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |  2 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c  |  2 +-
 include/net/mac80211.h                   |  5 ++++-
 net/mac80211/util.c                      |  5 +++--
 net/mac80211/wpa.c                       | 26 ++++++++++++++------------
 5 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 91afa3a..a045837 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -979,7 +979,7 @@ static void ath10k_process_rx(struct ath10k *ar,
 	*status = *rx_status;
 
 	ath10k_dbg(ar, ATH10K_DBG_DATA,
-		   "rx skb %p len %u peer %pM %s %s sn %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
+		   "rx skb %p len %u peer %pM %s %s sn %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%llx fcs-err %i mic-err %i amsdu-more %i\n",
 		   skb,
 		   skb->len,
 		   ieee80211_get_SA(hdr),
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 9bec823..99c21aa 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -57,7 +57,7 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 		       RX_FLAG_MMIC_STRIPPED |
 		       RX_FLAG_DECRYPTED;
 
-	wcn36xx_dbg(WCN36XX_DBG_RX, "status.flags=%x\n", status.flag);
+	wcn36xx_dbg(WCN36XX_DBG_RX, "status.flags=%llx\n", status.flag);
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1b9f729..7cb791f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1034,6 +1034,8 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	on this subframe
  * @RX_FLAG_AMPDU_DELIM_CRC_KNOWN: The delimiter CRC field is known (the CRC
  *	is stored in the @ampdu_delimiter_crc field)
+ * @RX_FLAG_MIC_STRIPPED: The mic was stripped of this packet. Decryption was
+ *	done by the hardware
  * @RX_FLAG_LDPC: LDPC was used
  * @RX_FLAG_ONLY_MONITOR: Report frame only to monitor interfaces without
  *	processing it in any regular way.
@@ -1091,6 +1093,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_5MHZ			= BIT(29),
 	RX_FLAG_AMSDU_MORE		= BIT(30),
 	RX_FLAG_RADIOTAP_VENDOR_DATA	= BIT(31),
+	RX_FLAG_MIC_STRIPPED            = BIT_ULL(32),
 };
 
 #define RX_FLAG_STBC_SHIFT		26
@@ -1151,7 +1154,7 @@ struct ieee80211_rx_status {
 	u64 boottime_ns;
 	u32 device_timestamp;
 	u32 ampdu_reference;
-	u32 flag;
+	u64 flag;
 	u16 freq;
 	u8 vht_flag;
 	u8 rate_idx;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89f7179..743265a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2714,8 +2714,9 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 
 	rate = cfg80211_calculate_bitrate(&ri);
 	if (WARN_ONCE(!rate,
-		      "Invalid bitrate: flags=0x%x, idx=%d, vht_nss=%d\n",
-		      status->flag, status->rate_idx, status->vht_nss))
+		      "Invalid bitrate: flags=0x%llx, idx=%d, vht_nss=%d\n",
+		      (unsigned long long)status->flag, status->rate_idx,
+		      status->vht_nss))
 		return 0;
 
 	/* rewind from end of MPDU */
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 1884825..7e4f265 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -504,18 +504,20 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 	    !ieee80211_is_robust_mgmt_frame(skb))
 		return RX_CONTINUE;
 
-	data_len = skb->len - hdrlen - IEEE80211_CCMP_HDR_LEN - mic_len;
-	if (!rx->sta || data_len < 0)
-		return RX_DROP_UNUSABLE;
-
 	if (status->flag & RX_FLAG_DECRYPTED) {
 		if (!pskb_may_pull(rx->skb, hdrlen + IEEE80211_CCMP_HDR_LEN))
 			return RX_DROP_UNUSABLE;
+		if (status->flag & RX_FLAG_MIC_STRIPPED)
+			mic_len = 0;
 	} else {
 		if (skb_linearize(rx->skb))
 			return RX_DROP_UNUSABLE;
 	}
 
+	data_len = skb->len - hdrlen - IEEE80211_CCMP_HDR_LEN - mic_len;
+	if (!rx->sta || data_len < 0)
+		return RX_DROP_UNUSABLE;
+
 	if (!(status->flag & RX_FLAG_PN_VALIDATED)) {
 		ccmp_hdr2pn(pn, skb->data + hdrlen);
 
@@ -720,8 +722,7 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	u8 pn[IEEE80211_GCMP_PN_LEN];
-	int data_len;
-	int queue;
+	int data_len, queue, mic_len = IEEE80211_GCMP_MIC_LEN;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
@@ -729,19 +730,20 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 	    !ieee80211_is_robust_mgmt_frame(skb))
 		return RX_CONTINUE;
 
-	data_len = skb->len - hdrlen - IEEE80211_GCMP_HDR_LEN -
-		   IEEE80211_GCMP_MIC_LEN;
-	if (!rx->sta || data_len < 0)
-		return RX_DROP_UNUSABLE;
-
 	if (status->flag & RX_FLAG_DECRYPTED) {
 		if (!pskb_may_pull(rx->skb, hdrlen + IEEE80211_GCMP_HDR_LEN))
 			return RX_DROP_UNUSABLE;
+		if (status->flag & RX_FLAG_MIC_STRIPPED)
+			mic_len = 0;
 	} else {
 		if (skb_linearize(rx->skb))
 			return RX_DROP_UNUSABLE;
 	}
 
+	data_len = skb->len - hdrlen - IEEE80211_GCMP_HDR_LEN - mic_len;
+	if (!rx->sta || data_len < 0)
+		return RX_DROP_UNUSABLE;
+
 	if (!(status->flag & RX_FLAG_PN_VALIDATED)) {
 		gcmp_hdr2pn(pn, skb->data + hdrlen);
 
@@ -772,7 +774,7 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 	}
 
 	/* Remove GCMP header and MIC */
-	if (pskb_trim(skb, skb->len - IEEE80211_GCMP_MIC_LEN))
+	if (pskb_trim(skb, skb->len - mic_len))
 		return RX_DROP_UNUSABLE;
 	memmove(skb->data + IEEE80211_GCMP_HDR_LEN, skb->data, hdrlen);
 	skb_pull(skb, IEEE80211_GCMP_HDR_LEN);
-- 
2.5.0

