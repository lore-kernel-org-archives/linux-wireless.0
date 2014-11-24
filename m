Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53162 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbaKXOfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:51 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so5952578wiv.13
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:50 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/75] iwlwifi: mvm: use unsigned for ssid_bitmap
Date: Mon, 24 Nov 2014 16:34:09 +0200
Message-Id: <1416839691-28533-33-git-send-email-egrumbach@gmail.com> (sfid-20141124_154013_498859_75E935AB)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ssid_bitmap should be unsigned, though it doesn't matter
much as the high bits aren't used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 54303d9..b6719b6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1324,7 +1324,7 @@ int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
 	struct iwl_scan_probe_req *preq;
 	struct iwl_mvm_scan_params params = {};
 	u32 flags;
-	int ssid_bitmap = 0;
+	u32 ssid_bitmap = 0;
 	int ret, i;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1763,7 +1763,7 @@ int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			mvm->fw->ucode_capa.n_scan_channels;
 	struct iwl_mvm_scan_params params = {};
 	u32 uid, flags;
-	int ssid_bitmap = 0;
+	u32 ssid_bitmap = 0;
 	int ret, i, uid_idx;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1853,7 +1853,7 @@ int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			mvm->fw->ucode_capa.n_scan_channels;
 	struct iwl_mvm_scan_params params = {};
 	u32 uid, flags;
-	int ssid_bitmap = 0;
+	u32 ssid_bitmap = 0;
 	int ret, uid_idx;
 
 	lockdep_assert_held(&mvm->mutex);
-- 
1.9.1

