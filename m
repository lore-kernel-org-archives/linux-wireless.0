Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50075 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbbGLRIe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 13:08:34 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/10] iwlwifi: mvm: check time-event vif to avoid bad deletion
Date: Sun, 12 Jul 2015 20:08:16 +0300
Message-Id: <1436720900-18588-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150712_190843_173612_A934B0AD)
In-Reply-To: <1436720814.17999.2.camel@intel.com>
References: <1436720814.17999.2.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The time event is initialized relatively late in interface (mvmvif)
initialization, so it's possible to fail before that happens. As a
consequence, the driver will crash if it ever tries to delete this
time event in case initialization was unsuccessful.

Avoid this by using the time event's vif pointer to indicate validity.
The vif pointer is != NULL whenever the id is != TE_MAX, except for
this special error case where the vif pointer will have the correct
property (as the whole memory is cleared on allocation) whereas the
id is 0, causing a crash in trying to delete the time event from the
list.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index d24b6a8..e472729 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -86,7 +86,7 @@ void iwl_mvm_te_clear_data(struct iwl_mvm *mvm,
 {
 	lockdep_assert_held(&mvm->time_event_lock);
 
-	if (te_data->id == TE_MAX)
+	if (!te_data->vif)
 		return;
 
 	list_del(&te_data->list);
-- 
2.1.4

