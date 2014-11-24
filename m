Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62622 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaKXOQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:16:57 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so12716667wgh.16
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:16:56 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: remove extra_tx_headroom
Date: Mon, 24 Nov 2014 15:04:46 +0100
Message-Id: <1416837886-18377-1-git-send-email-michal.kazior@tieto.com> (sfid-20141124_151700_722506_8BC2098E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Comment was out-of-date. The headroom is no longer
necessary because HTT Tx fragment list is stored
in dma pool item associated with each sk_buff.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1245ac8..5bb9f83 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4905,10 +4905,6 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_AP_LINK_PS |
 			IEEE80211_HW_SPECTRUM_MGMT;
 
-	/* MSDU can have HTT TX fragment pushed in front. The additional 4
-	 * bytes is used for padding/alignment if necessary. */
-	ar->hw->extra_tx_headroom += sizeof(struct htt_data_tx_desc_frag)*2 + 4;
-
 	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
 
 	if (ar->ht_cap_info & WMI_HT_CAP_DYNAMIC_SMPS)
-- 
1.8.5.3

