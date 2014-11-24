Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49981 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbaKXOgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:15 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so6003326wiw.4
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:14 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 47/75] iwlwifi: mvm: block TID when using TDLS
Date: Mon, 24 Nov 2014 16:34:23 +0200
Message-Id: <1416839691-28533-47-git-send-email-egrumbach@gmail.com> (sfid-20141124_153856_866205_48C1EA1B)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Block TID 4 (VI) on a vif when using TDLS. This TID will be used by FW
for TDLS channel-switch requests and PTI requests.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 64e89e8..5aedf9d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2186,6 +2186,15 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
  out_unlock:
 	mutex_unlock(&mvm->mutex);
 
+	if (sta->tdls && ret == 0) {
+		if (old_state == IEEE80211_STA_NOTEXIST &&
+		    new_state == IEEE80211_STA_NONE)
+			ieee80211_reserve_tid(sta, IWL_MVM_TDLS_FW_TID);
+		else if (old_state == IEEE80211_STA_NONE &&
+			 new_state == IEEE80211_STA_NOTEXIST)
+			ieee80211_unreserve_tid(sta, IWL_MVM_TDLS_FW_TID);
+	}
+
 	return ret;
 }
 
-- 
1.9.1

