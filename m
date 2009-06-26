Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43088 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbZFZRxr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2009 13:53:47 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwlagn: re-enable PS support for iwlagn
Date: Fri, 26 Jun 2009 11:00:53 -0700
Message-Id: <1246039255-2195-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1246039255-2195-1-git-send-email-reinette.chatre@intel.com>
References: <1246039255-2195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

The register locking rework addressed the problem where nic
access was obtained incorrectly when PS is enabled.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6ab0716..88135f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1325,7 +1325,8 @@ int iwl_setup_mac(struct iwl_priv *priv)
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_SPECTRUM_MGMT;
+		    IEEE80211_HW_SPECTRUM_MGMT |
+		    IEEE80211_HW_SUPPORTS_PS;
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
-- 
1.5.6.3

