Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39244 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbcAGMsB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:48:01 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/21] iwlwifi: mvm: remove useless WARN_ON and rely on cfg80211's combination
Date: Thu,  7 Jan 2016 14:47:33 +0200
Message-Id: <1452170861-10060-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134815_120248_5DCDD22C)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We advertise one STATION vif only, so this just can't
happen. Remove this useless WARN_ON.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/power.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index 87a9f24..9de159f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -613,8 +613,6 @@ static void iwl_mvm_power_get_vifs_iterator(void *_data, u8 *mac,
 		break;
 
 	case NL80211_IFTYPE_STATION:
-		/* only a single MAC of the same type */
-		WARN_ON(power_iterator->bss_vif);
 		power_iterator->bss_vif = vif;
 		if (mvmvif->phy_ctxt)
 			if (mvmvif->phy_ctxt->id < MAX_PHYS)
-- 
2.5.0

