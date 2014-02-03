Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59672 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaBCU7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:48 -0500
Received: by mail-ee0-f42.google.com with SMTP id b15so2055371eek.15
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:47 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 55/62] iwlwifi: mvm: remove duplicate assignment to ap_ibss_active
Date: Mon,  3 Feb 2014 22:58:01 +0200
Message-Id: <1391461088-8082-55-git-send-email-egrumbach@gmail.com> (sfid-20140203_220009_803919_91D37F86)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 3ef7d78..43dd644 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1314,8 +1314,6 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_remove;
 
-	mvmvif->ap_ibss_active = true;
-
 	/* Send the bcast station. At this stage the TBTT and DTIM time events
 	 * are added and applied to the scheduler */
 	ret = iwl_mvm_send_bcast_sta(mvm, vif, &mvmvif->bcast_sta);
-- 
1.7.9.5

