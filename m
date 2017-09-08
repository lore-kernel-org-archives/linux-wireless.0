Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49564 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752524AbdIHJNW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:13:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  8 Sep 2017 12:12:53 +0300
Message-Id: <20170908091256.25279-8-luca@coelho.fi> (sfid-20170908_111326_697094_5D0D0F69)
In-Reply-To: <20170908091256.25279-1-luca@coelho.fi>
References: <20170908091256.25279-1-luca@coelho.fi>
Subject: [PATCH 07/10] iwlwifi: mvm: handle FIF_ALLMULTI when setting multicast addresses
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We were ignoring the FIF_ALLMULTI flag when setting the multicast
addresses with MCAST_FILTER_CMD.  Check if this flag is set and enable
pass_all accordingly.  We also need to set the count to 0 if pass_all
is enable so we don't pass addresses to the firmware when not needed
(as doing so causes an assert).

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=196741

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 635db63f972e..3bcaa82f59b2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1643,6 +1643,12 @@ static void iwl_mvm_configure_filter(struct ieee80211_hw *hw,
 	if (!cmd)
 		goto out;
 
+	if (changed_flags & FIF_ALLMULTI)
+		cmd->pass_all = !!(*total_flags & FIF_ALLMULTI);
+
+	if (cmd->pass_all)
+		cmd->count = 0;
+
 	iwl_mvm_recalc_multicast(mvm);
 out:
 	mutex_unlock(&mvm->mutex);
-- 
2.14.1
