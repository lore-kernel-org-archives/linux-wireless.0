Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:35053 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab3KZOKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 09:10:42 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so3627506eaj.29
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 06:10:41 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/3] ath10k: use nss provided by mac80211
Date: Tue, 26 Nov 2013 14:57:38 +0100
Message-Id: <1385474260-22385-2-git-send-email-michal.kazior@tieto.com> (sfid-20131126_151046_426645_E5D1D654)
In-Reply-To: <1385474260-22385-1-git-send-email-michal.kazior@tieto.com>
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
 <1385474260-22385-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calculating STA NSS just from the mcs rateset is
not the greatest idea.

This should prevent connectivity issues if
mac80211 is ever to set rx_nss to something other
rather than base on max mcs map. As an example
operation mode change notification in assoc
request may change rx_nss initial values in the
future.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b70a3b2..15eda44 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -925,7 +925,7 @@ static void ath10k_peer_assoc_h_basic(struct ath10k *ar,
 	else
 		arg->peer_listen_intval = ar->hw->conf.listen_interval;
 
-	arg->peer_num_spatial_streams = 1;
+	arg->peer_num_spatial_streams = max_t(u32, 1, sta->rx_nss);
 
 	/*
 	 * The assoc capabilities are available only in managed mode.
@@ -1075,7 +1075,6 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 			arg->peer_ht_rates.rates[n++] = i;
 
 	arg->peer_ht_rates.num_rates = n;
-	arg->peer_num_spatial_streams = max((n+7) / 8, 1);
 
 	ath10k_dbg(ATH10K_DBG_MAC, "mac ht peer %pM mcs cnt %d nss %d\n",
 		   arg->addr,
-- 
1.8.4.rc3

