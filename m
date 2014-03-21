Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43142 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760353AbaCUJeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 05:34:21 -0400
Received: by mail-ee0-f48.google.com with SMTP id b57so1573340eek.35
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 02:34:20 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/2] ath10k: fix rssi and rate reporting
Date: Fri, 21 Mar 2014 10:33:57 +0100
Message-Id: <1395394437-4048-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140321_104447_901807_661C6209)
In-Reply-To: <1395394437-4048-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1395394437-4048-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RSSI and RATE fields are valid only when START_VALID
bit is set. So, in current implementation we have to
remember/caclulate them when START_VALID and report the same
when only END_VALID is set. In other case during high
RX traffic we will report invalid RSSI (-95) and RATE (6Mbps)
when only END_VALID bit set.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 4f1cc67..5a4310f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1154,8 +1154,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
-	memset(rx_status, 0, sizeof(*rx_status));
-
 	fw_desc_len = __le16_to_cpu(rx->prefix.fw_rx_desc_bytes);
 	fw_desc = (u8 *)&rx->fw_desc;
 
@@ -1164,8 +1162,11 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	mpdu_ranges = htt_rx_ind_get_mpdu_ranges(rx);
 
 	/* Fill this once, while this is per-ppdu */
-	rx_status->signal  = ATH10K_DEFAULT_NOISE_FLOOR;
-	rx_status->signal += rx->ppdu.combined_rssi;
+	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_START_VALID) {
+		memset(rx_status, 0, sizeof(*rx_status));
+		rx_status->signal  = ATH10K_DEFAULT_NOISE_FLOOR +
+				     rx->ppdu.combined_rssi;
+	}
 
 	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
 		/* TSF available only in 32-bit */
-- 
1.7.9.5

