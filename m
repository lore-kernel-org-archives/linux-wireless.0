Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:42084 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaEOItP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 04:49:15 -0400
Received: by mail-ee0-f49.google.com with SMTP id e53so396486eek.22
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 01:49:14 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 5/5] ath10k: dont configure bssid for ap mode
Date: Thu, 15 May 2014 10:42:04 +0200
Message-Id: <1400143324-14911-6-git-send-email-michal.kazior@tieto.com> (sfid-20140515_104937_582018_21276655)
In-Reply-To: <1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
 <1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW creates self-peer for AP internally.

This prevents ath10k from trying to create
explicit self-peer during hw recovery and thus
prevents a timeout and a warning during teardown:

  ath10k: removing stale peer $AP_BSSID from vdev_id 0

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * add comment why CHANGED_BSSID is skipped for AP [Kalle]

 drivers/net/wireless/ath/ath10k/mac.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e474eca..5b01b82 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2961,7 +2961,12 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		arvif->u.ap.hidden_ssid = info->hidden_ssid;
 	}
 
-	if (changed & BSS_CHANGED_BSSID) {
+	/*
+	 * Firmware manages AP self-peer internally so make sure to not create
+	 * it in driver. Otherwise AP self-peer deletion may timeout later.
+	 */
+	if (changed & BSS_CHANGED_BSSID &&
+	    vif->type != NL80211_IFTYPE_AP) {
 		if (!is_zero_ether_addr(info->bssid)) {
 			ath10k_dbg(ATH10K_DBG_MAC,
 				   "mac vdev %d create peer %pM\n",
-- 
1.8.5.3

