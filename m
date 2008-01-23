Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61297 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbYAWSPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 13:15:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tomas Carnecky <tom@dbservice.com>
Subject: [PATCH] iwl4965: fix return code indicating one interface is supported
Date: Wed, 23 Jan 2008 10:15:17 -0800
Message-Id: <1201112121-22340-3-git-send-email-reinette.chatre@intel.com> (sfid-20080123_181527_672414_BF7816BF)
In-Reply-To: <1201112121-22340-2-git-send-email-reinette.chatre@intel.com>
References: <1201112121-22340-1-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a fix to patch "iwlwifi: fix iwl_mac_add_interface handler".
In that patch the return code was corrected for iwl3945, but not for
iwl4965.


Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: Tomas Carnecky <tom@dbservice.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index bcaaec2..13fe5a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7448,7 +7448,7 @@ static int iwl4965_mac_add_interface(struct ieee80211_hw *hw,
 
 	if (priv->vif) {
 		IWL_DEBUG_MAC80211("leave - vif != NULL\n");
-		return 0;
+		return -EOPNOTSUPP;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-- 
1.5.3.4

