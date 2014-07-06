Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:33521 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaGFJhB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:01 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so3125885wes.24
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:00 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/40] iwlwifi: mvm: don't send zero quota to the firmware
Date: Sun,  6 Jul 2014 12:36:01 +0300
Message-Id: <1404639376-3792-25-git-send-email-egrumbach@gmail.com> (sfid-20140706_115956_664441_8A06819E)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are some cases where we can currently send zero quota
for a valid binding, e.g. if we update while an interface is
bound to a channel context but not yet acting as an AP.

Avoid this by reordering the checks.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/quota.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 75d2c95b..8bb2fce 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -105,11 +105,6 @@ static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
 	if (WARN_ON_ONCE(id >= MAX_BINDINGS))
 		return;
 
-	if (data->colors[id] < 0)
-		data->colors[id] = mvmvif->phy_ctxt->color;
-	else
-		WARN_ON_ONCE(data->colors[id] != mvmvif->phy_ctxt->color);
-
 	if (data->type == IWL_MVM_QUOTA_UPDATE_TYPE_DISABLED &&
 	    vif == data->vif)
 		return;
@@ -135,6 +130,11 @@ static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
 		return;
 	}
 
+	if (data->colors[id] < 0)
+		data->colors[id] = mvmvif->phy_ctxt->color;
+	else
+		WARN_ON_ONCE(data->colors[id] != mvmvif->phy_ctxt->color);
+
 	data->n_interfaces[id]++;
 
 	if (iwl_mvm_vif_low_latency(mvmvif) && !data->low_latency[id]) {
-- 
1.8.3.2

