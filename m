Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64565 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754882AbdBQLSC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Feb 2017 06:18:02 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix a warning during channel switch with multiple vaps
Date: Fri, 17 Feb 2017 16:48:38 +0530
Message-ID: <1487330318-11841-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20170217_121806_756977_80025A05)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Doing a channel switch via hostapd_cli seems to update
the new channel context for each VAP's appropriately as below
in 'ath10k_mac_update_vif_chan', hence we can safely suppress the
warning that shows up during this operation and dump the warning only
if no vaps are available for channel switch

hostapd_cli -i wlan0 chan_switch 5 5200
OK

ath10k_pci : mac chanctx switch n_vifs 3 mode 1
ath10k_pci : mac chanctx switch vdev_id 2 freq 5180->5200 width 0->0
ath10k_pci : mac chanctx switch vdev_id 1 freq 5180->5200 width 0->0
ath10k_pci : mac chanctx switch vdev_id 0 freq 5180->5200 width 0->0

Call Trace:

WARNING: backports-20161201-3.14.77-9ab3068/drivers/net/wireless/ath/ath10k/mac.c:7126
[<c022f2d4>] (warn_slowpath_null) from [<bf7f150c>]
(ath10k_reconfig_complete+0xe4/0x25c [ath10k_core])
[<bf7f150c>] (ath10k_reconfig_complete [ath10k_core])
[<bf7f35f0>] (ath10k_mac_vif_ap_csa_work+0x214/0x370 [ath10k_core])
[<bf7f38b8>] (ath10k_mac_op_change_chanctx+0x108/0x128 [ath10k_core])
[<bf782ac0>] (ieee80211_recalc_chanctx_min_def+0x30c/0x430 [mac80211])
[<bf7830a4>] (ieee80211_recalc_smps_chanctx+0x2ec/0x840 [mac80211])
[<bf7843e8>] (ieee80211_vif_use_reserved_context+0x7c/0xf8 [mac80211])
[<bf7843e8>] (ieee80211_vif_use_reserved_context [mac80211])
[<bf76e5d4>] (ieee80211_csa_finalize_work+0x5c/0x88 [mac80211])

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d1b7edb..b416958 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7085,7 +7085,7 @@ static int ath10k_ampdu_action(struct ieee80211_hw *hw,
 	lockdep_assert_held(&ar->data_lock);
 
 	WARN_ON(ctx && vifs);
-	WARN_ON(vifs && n_vifs != 1);
+	WARN_ON(vifs && !n_vifs);
 
 	/* FIXME: Sort of an optimization and a workaround. Peers and vifs are
 	 * on a linked list now. Doing a lookup peer -> vif -> chanctx for each
-- 
1.9.1
