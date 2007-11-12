Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10226 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbXKLDo3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 22:44:29 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/2] iwl4965: fix rxon flags set to wrong value for A mode in .erp_ie_changed
Date: Mon, 12 Nov 2007 11:37:43 +0800
Message-Id: <11948386661105-git-send-email-yi.zhu@intel.com> (sfid-20071112_034437_033635_017E244B)
In-Reply-To: <11948386652152-git-send-email-yi.zhu@intel.com>
References: <11948386633181-git-send-email-yi.zhu@intel.com>
 <11948386652152-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes a bug that enables RXON_FLG_TGG_PROTECT_MSK erroneously
for A mode in the erp_ie_changed mac80211 callback.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 4490ce6..8e2a4a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7661,7 +7661,7 @@ static void iwl_mac_erp_ie_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & IEEE80211_ERP_CHANGE_PROTECTION) {
-		if (cts_protection)
+		if (cts_protection && (priv->phymode != MODE_IEEE80211A))
 			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
-- 
1.5.2
