Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:56466 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3KML2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 06:28:18 -0500
Subject: [PATCH] ath10k: remove htt rx amsdu clear retry bit hack
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Nov 2013 13:28:10 +0200
Message-ID: <20131113112810.5221.69685.stgit@localhost6.localdomain6> (sfid-20131113_122822_116256_2A14CBC3)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With commit 0cfcefef1 ("mac80211: support reporting A-MSDU subframes
individually") there's no need to have the hack to clear the retry bit in
ath10k_htt_rx_amsdu(), mac80211 can handle this properly now.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 90d4f74..76c152b 100644
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

