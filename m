Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:60076 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaBKIdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 03:33:21 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so3487111eaj.7
        for <linux-wireless@vger.kernel.org>; Tue, 11 Feb 2014 00:33:20 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: pass frames with invalid peer status to upper layer
Date: Tue, 11 Feb 2014 09:32:59 +0100
Message-Id: <1392107579-4289-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140211_093325_527106_608B70C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass frames with invalid peer status to upper layer.
Next mac80211 will validate frames and drop if required.
This is required to detect spurious frames and pass
this info to user mode (detect CLASS2 CLASS3 frames from
nonauthenticated/nonassociated stations).

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index fe8bd1b..c7a5822 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -951,6 +951,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 			if (status != HTT_RX_IND_MPDU_STATUS_OK &&
 			    status != HTT_RX_IND_MPDU_STATUS_TKIP_MIC_ERR &&
+			    status != HTT_RX_IND_MPDU_STATUS_ERR_INV_PEER &&
 			    !htt->ar->monitor_enabled) {
 				ath10k_dbg(ATH10K_DBG_HTT,
 					   "htt rx ignoring frame w/ status %d\n",
-- 
1.7.9.5

