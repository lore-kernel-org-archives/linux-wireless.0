Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46985 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBSHjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 02:39:14 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so14052eei.21
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 23:39:12 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix sta_rc_update for non-ap iftype
Date: Wed, 19 Feb 2014 08:33:07 +0100
Message-Id: <1392795187-2870-1-git-send-email-michal.kazior@tieto.com> (sfid-20140219_083917_556016_9A2667DB)
In-Reply-To: <CA+BoTQmNdn3ELFRyiMwRE=nq5XukvSy2m7BNoqXnoz95JuDYOw@mail.gmail.com>
References: <CA+BoTQmNdn3ELFRyiMwRE=nq5XukvSy2m7BNoqXnoz95JuDYOw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The arsta structure wasn't initialized for
non-ap interfaces. This should fix related
warnings/crashes.

Reported-By: Ben Greear <greearb@candelatech.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
Ben, does this fix the lockdep splat for you?


 drivers/net/wireless/ath/ath10k/mac.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 94a70a9..9cb3eae 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3207,6 +3207,13 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 	int max_num_peers;
 	int ret = 0;
 
+	if (old_state == IEEE80211_STA_NOTEXIST &&
+	    new_state == IEEE80211_STA_NONE) {
+		memset(arsta, 0, sizeof(*arsta));
+		arsta->arvif = arvif;
+		INIT_WORK(&arsta->update_wk, ath10k_sta_rc_update_wk);
+	}
+
 	/* cancel must be done outside the mutex to avoid deadlock */
 	if ((old_state == IEEE80211_STA_NONE &&
 	     new_state == IEEE80211_STA_NOTEXIST))
@@ -3236,10 +3243,6 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   "mac vdev %d peer create %pM (new sta) num_peers %d\n",
 			   arvif->vdev_id, sta->addr, ar->num_peers);
 
-		memset(arsta, 0, sizeof(*arsta));
-		arsta->arvif = arvif;
-		INIT_WORK(&arsta->update_wk, ath10k_sta_rc_update_wk);
-
 		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr);
 		if (ret)
 			ath10k_warn("Failed to add peer %pM for vdev %d when adding a new sta: %i\n",
-- 
1.8.5.3

