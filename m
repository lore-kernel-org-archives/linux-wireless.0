Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:39366 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab3KVNaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 08:30:19 -0500
Received: by mail-ea0-f178.google.com with SMTP id d10so522234eaj.37
        for <linux-wireless@vger.kernel.org>; Fri, 22 Nov 2013 05:30:18 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: use nss provided by mac80211
Date: Fri, 22 Nov 2013 14:26:57 +0100
Message-Id: <1385126819-15311-2-git-send-email-michal.kazior@tieto.com> (sfid-20131122_143032_373450_32599DED)
In-Reply-To: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calculating STA NSS just from the rateset is not
the greatest idea. The NSS could be possibly
influenced by other things that only mac80211
knows about.

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

