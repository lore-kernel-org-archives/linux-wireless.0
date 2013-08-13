Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:48442 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab3HMJpm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 05:45:42 -0400
Received: by mail-ea0-f173.google.com with SMTP id g10so4000620eak.18
        for <linux-wireless@vger.kernel.org>; Tue, 13 Aug 2013 02:45:41 -0700 (PDT)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH] ath10k: fix WEP in AP and IBSS mode
Date: Tue, 13 Aug 2013 11:45:22 +0200
Message-Id: <1376387122-18075-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20130813_114546_336913_82DB0D2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WEP encoding was not working properly for AP and IBSS mode.
TX frames were encrypted with default WEP tx key index set
always to zero, what sometimes was wrong when different
key index should be used. This patch allows to update
WEP key index also for AP and IBSS mode.
Problem detected during automated WEP tests.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index cf2ba4d..bcefeb6 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1421,10 +1421,6 @@ static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
 	struct ieee80211_key_conf *key = info->control.hw_key;
 	int ret;
 
-	/* TODO AP mode should be implemented */
-	if (vif->type != NL80211_IFTYPE_STATION)
-		return;
-
 	if (!ieee80211_has_protected(hdr->frame_control))
 		return;
 
-- 
1.8.1.2

