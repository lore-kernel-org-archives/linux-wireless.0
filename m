Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57755 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbZCREq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/13] iwlcore: dont commit power command if interface is not up
Date: Tue, 17 Mar 2009 21:51:45 -0700
Message-Id: <1237351913-19202-6-git-send-email-reinette.chatre@intel.com> (sfid-20090318_054709_794277_DC3FDA7C)
In-Reply-To: <1237351913-19202-5-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-3-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-4-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

If user set new power level, accept the new power level and only
send command to host if the interface is up and radio on.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 18b7e41..47c8945 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -273,7 +273,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 	if (priv->iw_mode != NL80211_IFTYPE_STATION)
 		final_mode = IWL_POWER_MODE_CAM;
 
-	if (!iwl_is_rfkill(priv) && !setting->power_disabled &&
+	if (iwl_is_ready_rf(priv) && !setting->power_disabled &&
 	    ((setting->power_mode != final_mode) || force)) {
 		struct iwl_powertable_cmd cmd;
 
-- 
1.5.6.3

