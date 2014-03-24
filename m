Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44007 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbaCXUYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 16:24:03 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so4919166eei.14
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 13:24:02 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 2/8] ath10k: rename process_rx_rates to ath10k_htt_rx_h_rates
Date: Mon, 24 Mar 2014 21:23:16 +0100
Message-Id: <1395692603-4693-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140324_212411_896492_5E69EA30)
In-Reply-To: <1395692603-4693-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1395692603-4693-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional changes.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index c07fc8f..fd14c3a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -655,9 +655,9 @@ static const u8 rx_legacy_rate_idx[] = {
 	5,	/* 0x0F  - 9Mbps   */
 };
 
-static void process_rx_rates(struct ath10k *ar, struct htt_rx_info *info,
-			     enum ieee80211_band band,
-			     struct ieee80211_rx_status *status)
+static void ath10k_htt_rx_h_rates(struct ath10k *ar, struct htt_rx_info *info,
+				  enum ieee80211_band band,
+				  struct ieee80211_rx_status *status)
 {
 	u8 cck, rate, rate_idx, bw, sgi, mcs, nss;
 	u8 info0 = info->rate.info0;
@@ -789,7 +789,7 @@ static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 		return;
 	}
 
-	process_rx_rates(ar, info, ch->band, status);
+	ath10k_htt_rx_h_rates(ar, info, ch->band, status);
 	status->band = ch->band;
 	status->freq = ch->center_freq;
 
-- 
1.7.9.5

