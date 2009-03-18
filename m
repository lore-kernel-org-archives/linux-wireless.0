Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57755 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbZCREq7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/13] iwl3945: use changed in iwl3945_mac_config
Date: Tue, 17 Mar 2009 21:51:42 -0700
Message-Id: <1237351913-19202-3-git-send-email-reinette.chatre@intel.com> (sfid-20090318_060339_122184_B09DDBA2)
In-Reply-To: <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

In function iwl3945_mac_config use changed flag to call only
the affected functions.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 93f70df..215d3f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3773,15 +3773,19 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 	}
 #endif
 
-	if (conf->radio_enabled && iwl_radio_kill_sw_enable_radio(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF-KILL - waiting for uCode\n");
-		goto out;
-	}
+	if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED) {
+		if (conf->radio_enabled &&
+		    iwl_radio_kill_sw_enable_radio(priv)) {
+			IWL_DEBUG_MAC80211(priv, "leave - RF-KILL - "
+						 "waiting for uCode\n");
+			goto out;
+		}
 
-	if (!conf->radio_enabled) {
-		iwl_radio_kill_sw_disable_radio(priv);
-		IWL_DEBUG_MAC80211(priv, "leave - radio disabled\n");
-		goto out;
+		if (!conf->radio_enabled) {
+			iwl_radio_kill_sw_disable_radio(priv);
+			IWL_DEBUG_MAC80211(priv, "leave - radio disabled\n");
+			goto out;
+		}
 	}
 
 	if (iwl_is_rfkill(priv)) {
-- 
1.5.6.3

