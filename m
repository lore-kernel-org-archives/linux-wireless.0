Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48179 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbcDAVMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 17:12:20 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 4/5] ath10k:  Clean up peer when sta goes away.
Date: Fri,  1 Apr 2016 14:12:11 -0700
Message-Id: <1459545132-11295-4-git-send-email-greearb@candelatech.com> (sfid-20160401_231228_345536_449C01AE)
In-Reply-To: <1459545132-11295-1-git-send-email-greearb@candelatech.com>
References: <1459545132-11295-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

If WMI and/or firmware has issues removing the peer object,
then we still need to clean up the peer object in the driver.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5e5cc9c..020dd25 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6501,9 +6501,17 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 				continue;
 
 			if (peer->sta == sta) {
-				ath10k_warn(ar, "found sta peer %pM id: %d entry on vdev %i after it was supposedly removed\n",
-					    sta->addr, i, arvif->vdev_id);
+				ath10k_warn(ar, "found sta peer %pM (ptr %p id %d) entry on vdev %i after it was supposedly removed\n",
+					    sta->addr, peer, i, arvif->vdev_id);
 				peer->sta = NULL;
+
+				/* Clean up the peer object as well since we
+				 * must have failed to do this above.
+				 */
+				list_del(&peer->list);
+				ar->peer_map[i] = NULL;
+				kfree(peer);
+				ar->num_peers--;
 			}
 		}
 		spin_unlock_bh(&ar->data_lock);
-- 
2.4.3

