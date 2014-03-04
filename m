Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:36614 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbaCDMwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 07:52:50 -0500
Received: by mail-ee0-f42.google.com with SMTP id d17so4804192eek.29
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 04:52:49 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 04/14] ath10k: rename process_rx_rates to ath10k_htt_rx_h_rates
Date: Tue,  4 Mar 2014 13:52:17 +0100
Message-Id: <1393937548-7482-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140304_135258_356052_ECF3C4EC)
In-Reply-To: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index ad3918c..3008a1d 100644
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

