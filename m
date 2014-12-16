Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43024 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaLPIyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2014 03:54:25 -0500
Received: by mail-wg0-f52.google.com with SMTP id x12so16663123wgg.11
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2014 00:54:23 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/2] ath10k: send (re)assoc peer command when NSS changed
Date: Tue, 16 Dec 2014 09:53:00 +0100
Message-Id: <1418719980-19753-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20141216_095429_238015_6B6D675E)
In-Reply-To: <1418719980-19753-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1418719980-19753-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Assoc peer command contain information about NSS.
When we will get IEEE80211_RC_NSS_CHANGED we should
also send (re) assoc peer command to be sure firmware
will know about it and RC will work correctly.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c9e7995..05fd620 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3592,8 +3592,9 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 				    sta->addr, smps, err);
 	}
 
-	if (changed & IEEE80211_RC_SUPP_RATES_CHANGED) {
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac update sta %pM supp rates\n",
+	if (changed & IEEE80211_RC_SUPP_RATES_CHANGED ||
+	    changed & IEEE80211_RC_NSS_CHANGED) {
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac update sta %pM supp rates/nss\n",
 			   sta->addr);
 
 		err = ath10k_station_assoc(ar, arvif->vif, sta, true);
-- 
1.9.1

