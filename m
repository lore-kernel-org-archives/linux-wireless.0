Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9071 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab0AHSEp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 13:04:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/4] iwlwifi: add IEEE80211_AMPDU_TX_OPERATIONAL
Date: Fri,  8 Jan 2010 10:04:41 -0800
Message-Id: <1262973884-2551-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1262973884-2551-1-git-send-email-reinette.chatre@intel.com>
References: <1262973884-2551-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

mac80211 do not check the return code now, what if mac80211 does start
using the return code? IEEE80211_AMPDU_TX_OPERATIONAL is a valid action,
just iwlwifi driver do not need to take any action for it; so instead of
return "-EINVAL", it is a good program practice to return "-EOPNOTSUPP"
to make sure mac80211 will not get wrong impression.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 771b03c..c780633 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2955,6 +2955,9 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 			return 0;
 		else
 			return ret;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		/* do nothing */
+		return -EOPNOTSUPP;
 	default:
 		IWL_DEBUG_HT(priv, "unknown\n");
 		return -EINVAL;
-- 
1.5.6.3

