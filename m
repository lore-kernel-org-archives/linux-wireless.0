Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:50549 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaBJMN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 07:13:26 -0500
Received: by mail-ee0-f42.google.com with SMTP id b15so2904263eek.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 04:13:25 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: AP: handle HT station which does not have HT RX MCS
Date: Mon, 10 Feb 2014 13:12:55 +0100
Message-Id: <1392034375-13532-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20140210_131329_853400_C27A0E62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a workaround for HT-enabled STAs which break the spec
and have no HT capabilities RX mask (no HT RX MCS map).

As per spec, in section 20.3.5 Modulation and coding scheme (MCS),
MCS 0 through 7 are mandatory in 20MHz with 800 ns GI at all STAs.

Firmware asserts if such situation occurs.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 144b4d6..162920a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1148,8 +1148,23 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 		if (ht_cap->mcs.rx_mask[i/8] & (1 << i%8))
 			arg->peer_ht_rates.rates[n++] = i;
 
-	arg->peer_ht_rates.num_rates = n;
-	arg->peer_num_spatial_streams = max((n+7) / 8, 1);
+	/*
+	 * This is a workaround for HT-enabled STAs which break the spec
+	 * and have no HT capabilities RX mask (no HT RX MCS map).
+	 *
+	 * As per spec, in section 20.3.5 Modulation and coding scheme (MCS),
+	 * MCS 0 through 7 are mandatory in 20MHz with 800 ns GI at all STAs.
+	 *
+	 * Firmware asserts if such situation occurs.
+	 */
+	if (n == 0) {
+		arg->peer_ht_rates.num_rates = 8;
+		for (i = 0; i < arg->peer_ht_rates.num_rates; i++)
+			arg->peer_ht_rates.rates[i] = i;
+	} else {
+		arg->peer_ht_rates.num_rates = n;
+		arg->peer_num_spatial_streams = max((n+7) / 8, 1);
+	}
 
 	ath10k_dbg(ATH10K_DBG_MAC, "mac ht peer %pM mcs cnt %d nss %d\n",
 		   arg->addr,
-- 
1.7.9.5

