Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:39074 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbaEORFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:04 -0400
Received: by mail-we0-f171.google.com with SMTP id w62so1392052wes.30
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:02 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/24] iwlwifi: mvm: stop sched scan before association
Date: Thu, 15 May 2014 20:04:24 +0300
Message-Id: <1400173481-9047-7-git-send-email-egrumbach@gmail.com> (sfid-20140515_190513_546278_970A8F50)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Stop sched scan on bss_info_changed if !idle to avoid sched scan
during association.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 66fa21b..72f73a3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1512,6 +1512,9 @@ static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	if (changes & BSS_CHANGED_IDLE && !bss_conf->idle)
+		iwl_mvm_sched_scan_stop(mvm, true);
+
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		iwl_mvm_bss_info_changed_station(mvm, vif, bss_conf, changes);
-- 
1.8.3.2

