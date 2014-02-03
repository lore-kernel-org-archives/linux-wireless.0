Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62896 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaBCUja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:39:30 -0500
Received: by mail-ee0-f46.google.com with SMTP id c13so3813865eek.5
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:39:29 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/8] iwlwifi: mvm: disable scheduled scan
Date: Mon,  3 Feb 2014 22:39:16 +0200
Message-Id: <1391459962-7381-2-git-send-email-egrumbach@gmail.com> (sfid-20140203_213935_713158_2F0CD21B)
In-Reply-To: <52EFFCE8.6070505@gmail.com>
References: <52EFFCE8.6070505@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The iwlwifi scheduled scan implementation doesn't adhere to the
userspace API correctly - the API assumes that any new incoming
'incompatible' request (like scan or remain-on-channel for this
driver) will just cancel the scheduled scan. Instead our driver
relies on userspace cancelling it, thus breaking existing wpa_s
versions.

Cc: stable@vger.kernel.org [3.13]
Fixes: 35a000b7c1bb ("iwlwifi: mvm: support sched scan if supported by the fw")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index c49b507..6bf9766 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -246,7 +246,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	else
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_SCHED_SCAN) {
+	if (0 && mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_SCHED_SCAN) {
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 		hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX;
 		hw->wiphy->max_match_sets = IWL_SCAN_MAX_PROFILES;
-- 
1.7.9.5

