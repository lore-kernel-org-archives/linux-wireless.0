Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:34818 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752011AbdEKJJh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 05:09:37 -0400
Received: by mail-wr0-f172.google.com with SMTP id z52so15087465wrc.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 02:09:37 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, akolli@qti.qualcomm.com,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH] ath10k: Fix reported HT MCS rates with NSS > 1
Date: Thu, 11 May 2017 11:09:30 +0200
Message-Id: <20170511090930.18205-1-sven.eckelmann@openmesh.com> (sfid-20170511_111115_739915_7B184692)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The QCA4019 firmware 10.4-3.2.1-00050 reports only HT MCS rates between
0-9. But 802.11n MCS rates can be larger than that. For example a 2x2
device can send with up to MCS 15.

The firmware encodes the higher MCS rates using the NSS field. The actual
calculation is not documented by QCA but it seems like the NSS field can be
mapped for HT rates to following MCS offsets:

 * NSS 1: 0
 * NSS 2: 8
 * NSS 3: 16
 * NSS 4: 24

This offset therefore has to be added for HT rates before they are stored
in the rate_info struct.

Fixes: cec17c382140 ("ath10k: add per peer htt tx stats support for 10.4")
Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 84b6067ff6e7..6c0a821fe79d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2229,9 +2229,15 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 	txrate.mcs = ATH10K_HW_MCS_RATE(peer_stats->ratecode);
 	sgi = ATH10K_HW_GI(peer_stats->flags);
 
-	if (((txrate.flags == WMI_RATE_PREAMBLE_HT) ||
-	     (txrate.flags == WMI_RATE_PREAMBLE_VHT)) && txrate.mcs > 9) {
-		ath10k_warn(ar, "Invalid mcs %hhd peer stats", txrate.mcs);
+	if (txrate.flags == WMI_RATE_PREAMBLE_VHT && txrate.mcs > 9) {
+		ath10k_warn(ar, "Invalid VHT mcs %hhd peer stats",  txrate.mcs);
+		return;
+	}
+
+	if (txrate.flags == WMI_RATE_PREAMBLE_HT &&
+	    (txrate.mcs > 7 || txrate.nss < 1)) {
+		ath10k_warn(ar, "Invalid HT mcs %hhd nss %hhd peer stats",
+			    txrate.mcs, txrate.nss);
 		return;
 	}
 
@@ -2254,7 +2260,7 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 		arsta->txrate.legacy = rate;
 	} else if (txrate.flags == WMI_RATE_PREAMBLE_HT) {
 		arsta->txrate.flags = RATE_INFO_FLAGS_MCS;
-		arsta->txrate.mcs = txrate.mcs;
+		arsta->txrate.mcs = txrate.mcs + 8 * (txrate.nss - 1);
 	} else {
 		arsta->txrate.flags = RATE_INFO_FLAGS_VHT_MCS;
 		arsta->txrate.mcs = txrate.mcs;
-- 
2.11.0
