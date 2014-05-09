Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:41857 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbaEIMbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:31:01 -0400
Received: by mail-ee0-f52.google.com with SMTP id e53so2629562eek.39
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 05:31:00 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/5] ath10k: dont configure bssid for ap mode
Date: Fri,  9 May 2014 14:15:49 +0200
Message-Id: <1399637749-13489-6-git-send-email-michal.kazior@tieto.com> (sfid-20140509_143105_076302_1FC19E6D)
In-Reply-To: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW creates self-peer for AP internally.

This prevents ath10k from trying to create
explicit self-peer during hw recovery and thus
prevents a timeout and a warning during teardown:

  ath10k: removing stale peer $AP_BSSID from vdev_id 0

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 78b427d..9b14ec8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2953,7 +2953,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		arvif->u.ap.hidden_ssid = info->hidden_ssid;
 	}
 
-	if (changed & BSS_CHANGED_BSSID) {
+	if (changed & BSS_CHANGED_BSSID &&
+	    vif->type != NL80211_IFTYPE_AP) {
 		if (!is_zero_ether_addr(info->bssid)) {
 			ath10k_dbg(ATH10K_DBG_MAC,
 				   "mac vdev %d create peer %pM\n",
-- 
1.8.5.3

