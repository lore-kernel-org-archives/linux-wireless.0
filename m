Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:41653 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbaCROq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:56 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so5451483eek.38
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:55 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/35] iwlwifi: mvm: ignore unchanged low-latency flag
Date: Tue, 18 Mar 2014 16:45:38 +0200
Message-Id: <1395153939-23897-34-git-send-email-egrumbach@gmail.com> (sfid-20140318_154704_714509_404FFFA9)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the low-latency update is called but there's no change then
ignore the update instead of triggering all the required work.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index c28da90..d619851 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -612,6 +612,9 @@ int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (mvmvif->low_latency == value)
+		return 0;
+
 	mvmvif->low_latency = value;
 
 	res = iwl_mvm_update_quotas(mvm, NULL);
-- 
1.8.3.2

