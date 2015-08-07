Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36105 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbbHGHHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2015 03:07:53 -0400
Received: by lbbpu9 with SMTP id pu9so28321324lbb.3
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2015 00:07:51 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: wake up queue upon vif creation
Date: Fri,  7 Aug 2015 09:08:21 +0200
Message-Id: <1438931301-27081-1-git-send-email-michal.kazior@tieto.com> (sfid-20150807_090757_445294_2B56D83B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vif's vdev_id is used as queue number. However due
to the tx pausing design in ath10k it was possible
for a new interface to be created with its tx
queue stopped (via ieee80211_stop_queues). This
could in turn leave the interface inoperable until
ath10k_mac_tx_unlock() was called.

This problem only affected multi-vif scenarios when
new interfaces were created some time later after
other interfaces have been running for some time
and had Tx queue full at some point prior.

Possible manifestation of the bug was
authentication timeout for a client vif.

Fixes: 96d828d45e16 ("ath10k: rework tx queue locking")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index acd222f3b899..03e498cb64b4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4299,6 +4299,11 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		}
 	}
 
+	spin_lock_bh(&ar->htt.tx_lock);
+	if (!ar->tx_paused)
+		ieee80211_wake_queue(ar->hw, arvif->vdev_id);
+	spin_unlock_bh(&ar->htt.tx_lock);
+
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
 
-- 
2.1.4

