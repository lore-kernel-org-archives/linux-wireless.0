Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63661 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3KNJhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 04:37:24 -0500
Received: by mail-wg0-f52.google.com with SMTP id z12so1617589wgg.31
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 01:37:22 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: clear tx status before submitting to mac80211
Date: Thu, 14 Nov 2013 10:34:18 +0100
Message-Id: <1384421658-7295-1-git-send-email-michal.kazior@tieto.com> (sfid-20131114_103729_061307_F397AC55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Garbage was reported in ieee80211_tx_info. This
led to a WARN_ON in cfg80211_calculate_bitrate().

This also fixes some random tx bitrate values
reported through `iw` command.

Reported-By: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index c511f91..3bc86f1 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -75,6 +75,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	ath10k_report_offchan_tx(htt->ar, msdu);
 
 	info = IEEE80211_SKB_CB(msdu);
+	memset(info, 0, sizeof(*info));
 
 	if (tx_done->discard) {
 		ieee80211_free_txskb(htt->ar->hw, msdu);
-- 
1.8.4.rc3

