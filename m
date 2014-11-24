Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40622 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaKXCf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2014 21:35:57 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] ath10k: Fix bug reported by lockdep
Date: Mon, 24 Nov 2014 08:07:37 +0530
Message-Id: <1416796657-24657-4-git-send-email-sujith@msujith.org> (sfid-20141124_033623_602086_121E54A4)
In-Reply-To: <1416796657-24657-1-git-send-email-sujith@msujith.org>
References: <1416796657-24657-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ath10k_tx_wep_key_work() acquires conf_mutex, so
cancelling it when conf_mutex is already taken
in ath10k_remove_interface() is incorrect, so
move it outside the lock.

Snippet from the lockdep report:

kernel: ======================================================
kernel: [ INFO: possible circular locking dependency detected ]
kernel: 3.18.0-rc5-wl-debug #34 Tainted: G           O
kernel: -------------------------------------------------------
kernel: hostapd/451 is trying to acquire lock:
kernel:  ((&arvif->wep_key_work)){+.+...}, at: [<ffffffff810872d5>] flush_work+0x5/0x290
kernel: but task is already holding lock:
kernel:  (&ar->conf_mutex){+.+.+.}, at: [<ffffffffa0b99f00>] ath10k_remove_interface+0x40/0x290 [ath10k_core]
kernel: which lock already depends on the new lock.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2200c64..651e318 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3041,10 +3041,10 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	int ret;
 
-	mutex_lock(&ar->conf_mutex);
-
 	cancel_work_sync(&arvif->wep_key_work);
 
+	mutex_lock(&ar->conf_mutex);
+
 	spin_lock_bh(&ar->data_lock);
 	ath10k_mac_vif_beacon_cleanup(arvif);
 	spin_unlock_bh(&ar->data_lock);
-- 
2.1.3

