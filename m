Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34533 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaBLJh7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 04:37:59 -0500
Received: by mail-pb0-f52.google.com with SMTP id jt11so8991663pbb.25
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 01:37:59 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, kvalo@qca.qualcomm.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath10k: set the mactime of ieee80211_rx_status
Date: Wed, 12 Feb 2014 17:37:46 +0800
Message-Id: <1392197866-1261-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140212_103804_702837_7FADC902)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Retrieve the mactime of ieee80211_rx_status based on received
data frame. The value is obtained from the htt_rx_indication_ppdu
structure and only available in 32-bit.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |    1 +
 drivers/net/wireless/ath/ath10k/txrx.c   |    6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index b93ae35..bf6b415 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1181,6 +1181,7 @@ struct htt_rx_info {
 		u32 info1;
 		u32 info2;
 	} rate;
+	u32 tsf;
 	bool fcs_err;
 	bool amsdu_more;
 	bool mic_err;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 820c8ba..4ec2b5d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -989,6 +989,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			info.rate.info0 = rx->ppdu.info0;
 			info.rate.info1 = __le32_to_cpu(rx->ppdu.info1);
 			info.rate.info2 = __le32_to_cpu(rx->ppdu.info2);
+			info.tsf = __le32_to_cpu(rx->ppdu.tsf);
 
 			hdr = ath10k_htt_rx_skb_get_hdr(msdu_head);
 
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index b11e478..4713bdb 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -258,6 +258,12 @@ void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 	status->band = ch->band;
 	status->freq = ch->center_freq;
 
+	if (info->rate.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
+		/* TSF available only in 32-bit */
+		status->mactime = info->tsf & 0xffffffff;
+		status->flag |= RX_FLAG_MACTIME_END;
+	}
+
 	ath10k_dbg(ATH10K_DBG_DATA,
 		   "rx skb %p len %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i\n",
 		   info->skb,
-- 
1.7.9.5

