Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22007 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbbIBGvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 02:51:33 -0400
From: <c_mpubbi@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
Subject: [PATCH] ath10k: invalid mcs reported in rx descriptor
Date: Wed, 2 Sep 2015 12:21:05 +0530
Message-ID: <1441176665-3365-1-git-send-email-c_mpubbi@qti.qualcomm.com> (sfid-20150902_085136_783761_D11B8F1B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>

Sometimes hardware reports invalid mcs index in rx descriptor
when operating in VHT80 mode and all packets with invalid mcs
will be eventually dropped in mac80211. This issue is observerd during
testing on QCA99X0 chipsets.

This patch adds a warn message for dumping the rx desc info which helps
in analysing the issue when invalid mcs is received.

Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 1b7a043..9985772 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -697,6 +697,29 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		bw = info2 & 3;
 		sgi = info3 & 1;
 
+		if (mcs > 0x09) {
+			ath10k_warn(ar, "invalid MCS received %u\n", mcs);
+			ath10k_warn(ar, "rxd %08x mpdu start %08x %08x msdu start %08x %08x ppdu start %08x %08x %08x %08x %08x\n",
+				    __le32_to_cpu(rxd->attention.flags),
+				    __le32_to_cpu(rxd->mpdu_start.info0),
+				    __le32_to_cpu(rxd->mpdu_start.info1),
+				    __le32_to_cpu(rxd->msdu_start.common.info0),
+				    __le32_to_cpu(rxd->msdu_start.common.info1),
+				    rxd->ppdu_start.info0,
+				    __le32_to_cpu(rxd->ppdu_start.info1),
+				    __le32_to_cpu(rxd->ppdu_start.info2),
+				    __le32_to_cpu(rxd->ppdu_start.info3),
+				    __le32_to_cpu(rxd->ppdu_start.info4));
+
+			ath10k_warn(ar, "msdu end %08x mpdu end %08x\n",
+				    __le32_to_cpu(rxd->msdu_end.common.info0),
+				    __le32_to_cpu(rxd->mpdu_end.info0));
+
+			ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL,
+					"rx desc msdu payload: ",
+					rxd->msdu_payload, 50);
+		}
+
 		status->rate_idx = mcs;
 		status->vht_nss = nss;
 
-- 
1.9.1

