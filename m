Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50114 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbbFKMt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 08:49:27 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH] ath10k: remove unused variable hdr in ath10k_htt_rx_h_undecap()
Date: Thu, 11 Jun 2015 18:18:47 +0530
Message-ID: <1434026927-11698-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20150611_144931_291818_68611BBB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just found this during code review.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 89eb16b..7399e45 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1201,7 +1201,6 @@ static void ath10k_htt_rx_h_undecap(struct ath10k *ar,
 {
 	struct htt_rx_desc *rxd;
 	enum rx_msdu_decap_format decap;
-	struct ieee80211_hdr *hdr;
 
 	/* First msdu's decapped header:
 	 * [802.11 header] <-- padded to 4 bytes long
@@ -1215,7 +1214,6 @@ static void ath10k_htt_rx_h_undecap(struct ath10k *ar,
 	 */
 
 	rxd = (void *)msdu->data - sizeof(*rxd);
-	hdr = (void *)rxd->rx_hdr_status;
 	decap = MS(__le32_to_cpu(rxd->msdu_start.info1),
 		   RX_MSDU_START_INFO1_DECAP_FORMAT);
 
-- 
1.8.1.2

