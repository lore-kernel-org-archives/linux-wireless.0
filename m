Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52536 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755329AbcLVWcd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Dec 2016 17:32:33 -0500
From: <ryanhsu@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
CC: <ryanhsu@qca.qualcomm.com>
Subject: [PATCH] ath10k: recal the txpower when removing interface
Date: Thu, 22 Dec 2016 14:31:46 -0800
Message-ID: <1482445906-20421-1-git-send-email-ryanhsu@qca.qualcomm.com> (sfid-20161222_233236_394147_F0E3FA4B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Hsu <ryanhsu@qca.qualcomm.com>

The txpower is being recalculated when adding interface to make sure
txpower won't overshoot the spec, and when removing the interface,
the txpower should again to be recalculated to restore the correct value
from the active interface list.

Following is one of the scenario
	vdev0 is created as STA and connected: txpower:23
	vdev1 is created as P2P_DEVICE for control interface: txpower:0
	vdev2 is created as p2p go/gc interface: txpower is 21

So the vdev2@txpower:21 will be set to firmware when vdev2 is created.
When we tear down the vdev2, the txpower needs to be recalculated to
re-set it to vdev0@txpower:23 as vdev0/vdev1 are the active interface.

	ath10k_pci mac vdev 0 peer create 8c:fd:f0:01:62:98
	ath10k_pci mac vdev_id 0 txpower 23
	... (adding interface)
	ath10k_pci mac vdev create 2 (add interface) type 1 subtype 3
	ath10k_pci mac vdev_id 2 txpower 21
	ath10k_pci mac txpower 21
	... (removing interface)
	ath10k_pci mac vdev 2 delete (remove interface)
	ath10k_pci vdev 1 txpower 0
	ath10k_pci vdev 0 txpower 23
	ath10k_pci mac txpower 23

Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index aa545a1..6475dc8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5194,6 +5194,10 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 			ath10k_warn(ar, "failed to recalc monitor: %d\n", ret);
 	}
 
+	ret = ath10k_mac_txpower_recalc(ar);
+	if (ret)
+		ath10k_warn(ar, "failed to recalc tx power: %d\n", ret);
+
 	spin_lock_bh(&ar->htt.tx_lock);
 	ath10k_mac_vif_tx_unlock_all(arvif);
 	spin_unlock_bh(&ar->htt.tx_lock);
-- 
1.9.1
