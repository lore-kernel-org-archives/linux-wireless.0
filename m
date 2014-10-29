Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42759 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710AbaJ2Lvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:37 -0400
Received: by mail-wg0-f46.google.com with SMTP id x13so3099747wgg.5
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:36 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/25] iwlwifi: mvm: fix scan condition iterator
Date: Wed, 29 Oct 2014 13:50:44 +0200
Message-Id: <1414583446-11032-23-git-send-email-egrumbach@gmail.com> (sfid-20141029_131321_342420_E0366814)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Scan condition iterator assumes that an interface is associated if
phy_ctxt is assigned, but this isn't the sutuation in P2P device.
OTOH P2P device is never associated so we can simply ignore it.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 64c02a2..042fcdc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -270,7 +270,8 @@ static void iwl_mvm_scan_condition_iterator(void *data, u8 *mac,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	bool *global_bound = data;
 
-	if (mvmvif->phy_ctxt && mvmvif->phy_ctxt->id < MAX_PHYS)
+	if (vif->type != NL80211_IFTYPE_P2P_DEVICE && mvmvif->phy_ctxt &&
+	    mvmvif->phy_ctxt->id < MAX_PHYS)
 		*global_bound = true;
 }
 
-- 
1.9.1

