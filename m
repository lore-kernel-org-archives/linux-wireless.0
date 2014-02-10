Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45856 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaBJK0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 05:26:20 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so2876254eae.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 02:26:18 -0800 (PST)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH] ath10k: Set proper nss value for the peer
Date: Mon, 10 Feb 2014 11:25:25 +0100
Message-Id: <1392027925-8321-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140210_112623_686334_98822DCF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was found during testing the nss calculation does not
cover all corner cases. Station could request eq. only MCS8
and MCS9 (nss=2 specific). Next num_rates=2 so the driver
sets nss=(max((2+7)/8, 1))=1. Which is wrong. The in-driver
calculation was introduced prior (commit ddcc347b70
mac80211: fix rx_nss calculation for drivers with hw rc).
Since it's fixed, use mac80211 provided value from now.
End user will experience lower throuhputs than expected
if the nss is wrongly calculated.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 144b4d6..e6bf2e8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1149,7 +1149,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 			arg->peer_ht_rates.rates[n++] = i;
 
 	arg->peer_ht_rates.num_rates = n;
-	arg->peer_num_spatial_streams = max((n+7) / 8, 1);
+	arg->peer_num_spatial_streams = sta->rx_nss;
 
 	ath10k_dbg(ATH10K_DBG_MAC, "mac ht peer %pM mcs cnt %d nss %d\n",
 		   arg->addr,
-- 
1.7.9.5

