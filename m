Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57650 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaBQTcd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 14:32:33 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v4] ath10k:  add more details to some debug messages
Date: Mon, 17 Feb 2014 11:31:35 -0800
Message-Id: <1392665495-17011-1-git-send-email-greearb@candelatech.com> (sfid-20140217_203236_977593_2D0FA19A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Makes it easier to determine why some failures
happened.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v4: Add commit description.

 drivers/net/wireless/ath/ath10k/mac.c  | 3 ++-
 drivers/net/wireless/ath/ath10k/txrx.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e17f5d73..7ca52ea 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3539,7 +3539,8 @@ static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 		}), ATH10K_FLUSH_TIMEOUT_HZ);
 
 	if (ret <= 0 || skip)
-		ath10k_warn("tx not flushed\n");
+		ath10k_warn("tx not flushed (skip %i ar-state %i): %i\n",
+			    skip, ar->state, ret);
 
 skip:
 	mutex_unlock(&ar->conf_mutex);
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index ec6f825..8271df2 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -378,7 +378,8 @@ void ath10k_peer_unmap_event(struct ath10k_htt *htt,
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, ev->peer_id);
 	if (!peer) {
-		ath10k_warn("unknown peer id %d\n", ev->peer_id);
+		ath10k_warn("peer-unmap-event: unknown peer id %d\n",
+			    ev->peer_id);
 		goto exit;
 	}
 
-- 
1.7.11.7

