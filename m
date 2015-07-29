Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35746 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbbG2JTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 05:19:46 -0400
Received: by lblf12 with SMTP id f12so2782350lbl.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2015 02:19:44 -0700 (PDT)
Received: from di ([80.233.186.214])
        by smtp.gmail.com with ESMTPSA id ew6sm5199441lbc.40.2015.07.29.02.19.42
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jul 2015 02:19:43 -0700 (PDT)
Date: Wed, 29 Jul 2015 12:19:42 +0300
From: Dmitry Ivanov <dmitrijs.ivanovs@ubnt.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: report per-chain RSSI
Message-Id: <20150729121942.9c8c2ec02dfc0469163aa7aa@ubnt.com> (sfid-20150729_111954_094165_9E0E227F)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k: report per-chain RSSI.

Signed-off-by: Dmitry Ivanov <dima@ubnt.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index d7d1183..2d50939 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -832,6 +832,20 @@ static void ath10k_htt_rx_h_signal(struct ath10k *ar,
 				   struct ieee80211_rx_status *status,
 				   struct htt_rx_desc *rxd)
 {
+	{
+		/* Linux array has size IEEE80211_MAX_CHAINS, FW array has size 4 */
+		BUILD_BUG_ON(IEEE80211_MAX_CHAINS != 4);
+		u32 i = IEEE80211_MAX_CHAINS;
+		u8 signal_per_chain;
+		do {
+			i--;
+			signal_per_chain = rxd->ppdu_start.rssi_chains[i].pri20_mhz;
+			if (signal_per_chain != 0x80) {
+				status->chains |= BIT(i);
+				status->chain_signal[i] = ATH10K_DEFAULT_NOISE_FLOOR + signal_per_chain;
+			}
+		} while (i);
+	}
 	/* FIXME: Get real NF */
 	status->signal = ATH10K_DEFAULT_NOISE_FLOOR +
 			 rxd->ppdu_start.rssi_comb;
-- 
2.1.4

