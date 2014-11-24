Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52550 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbaKXN1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 08:27:41 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so5650920wiv.5
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 05:27:40 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: add missing goto
Date: Mon, 24 Nov 2014 14:15:07 +0100
Message-Id: <1416834909-7130-1-git-send-email-michal.kazior@tieto.com> (sfid-20141124_142748_309111_3FABBC23)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prevents warning spamming if peer creation
fails during sta_state in some cases.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1245ac8..7b5a888 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3559,9 +3559,11 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   arvif->vdev_id, sta->addr, ar->num_peers);
 
 		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr);
-		if (ret)
+		if (ret) {
 			ath10k_warn(ar, "failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
+			goto exit;
+		}
 
 		if (vif->type == NL80211_IFTYPE_STATION) {
 			WARN_ON(arvif->is_started);
-- 
1.8.5.3

