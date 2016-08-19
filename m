Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34806 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754496AbcHSBdE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Aug 2016 21:33:04 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/3] ath10k:  Improve logging message.
Date: Thu, 18 Aug 2016 18:26:35 -0700
Message-Id: <1471569995-10028-3-git-send-email-greearb@candelatech.com> (sfid-20160819_033728_662776_72CD1F93)
In-Reply-To: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Helps to know the sta pointer.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d96c06e..82bc0da 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6491,8 +6491,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		 * Existing station deletion.
 		 */
 		ath10k_dbg(ar, ATH10K_DBG_MAC,
-			   "mac vdev %d peer delete %pM (sta gone)\n",
-			   arvif->vdev_id, sta->addr);
+			   "mac vdev %d peer delete %pM (sta gone) sta: %p\n",
+			   arvif->vdev_id, sta->addr, sta);
 
 		ret = ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
 		if (ret)
-- 
2.4.11
