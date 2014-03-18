Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49202 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaCROqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:15 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so5479572eek.32
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:14 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/35] iwlwifi: mvm: fix merge damage
Date: Tue, 18 Mar 2014 16:45:21 +0200
Message-Id: <1395153939-23897-17-git-send-email-egrumbach@gmail.com> (sfid-20140318_155649_965093_3B4A47D1)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Scheduled scan was disabled because it was broken. Now it is
fixed and got disabled by mistake by a merge.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index a6df00d..de0e0df 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -365,7 +365,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	else
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
-	if (0 && mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_SCHED_SCAN) {
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_SCHED_SCAN) {
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 		hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX;
 		hw->wiphy->max_match_sets = IWL_SCAN_MAX_PROFILES;
-- 
1.8.3.2

