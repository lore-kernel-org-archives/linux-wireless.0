Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:51356 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3KMNXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 08:23:35 -0500
Subject: [PATCH v2] ath10k: remove htt rx amsdu clear retry bit hack
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Nov 2013 15:23:30 +0200
Message-ID: <20131113132330.25272.11354.stgit@localhost6.localdomain6> (sfid-20131113_142338_982419_7217750A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With commit 0cfcefef1 ("mac80211: support reporting A-MSDU subframes
individually") there's no need to have the hack to clear the retry bit in
ath10k_htt_rx_amsdu(), mac80211 can handle this properly now.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |   20 +++-----------------
 drivers/net/wireless/ath/ath10k/txrx.c   |    3 +++
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 1a337e9..7fc7919 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1182,6 +1182,7 @@ struct htt_rx_info {
 		u32 info2;
 	} rate;
 	bool fcs_err;
+	bool amsdu_more;
 };
 
 struct ath10k_htt {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 90d4f74..0335218 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -659,23 +659,6 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 	memcpy(hdr_buf, hdr, hdr_len);
 	hdr = (struct ieee80211_hdr *)hdr_buf;
 
-	/* FIXME: Hopefully this is a temporary measure.
-	 *
-	 * Reporting individual A-MSDU subframes means each reported frame
-	 * shares the same sequence number.
-	 *
-	 * mac80211 drops frames it recognizes as duplicates, i.e.
-	 * retransmission flag is set and sequence number matches sequence
-	 * number from a previous frame (as per IEEE 802.11-2012: 9.3.2.10
-	 * "Duplicate detection and recovery")
-	 *
-	 * To avoid frames being dropped clear retransmission flag for all
-	 * received A-MSDUs.
-	 *
-	 * Worst case: actual duplicate frames will be reported but this should
-	 * still be handled gracefully by other OSI/ISO layers. */
-	hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_RETRY);
-
 	first = skb;
 	while (skb) {
 		void *decap_hdr;
@@ -746,6 +729,9 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 		skb = skb->next;
 		info->skb->next = NULL;
 
+		if (skb)
+			info->amsdu_more = true;
+
 		ath10k_process_rx(htt->ar, info);
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index c511f91..df279a3 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -236,6 +236,9 @@ void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 	if (info->fcs_err)
 		status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
+	if (info->amsdu_more)
+		status->flag |= RX_FLAG_AMSDU_MORE;
+
 	status->signal = info->signal;
 
 	spin_lock_bh(&ar->data_lock);

