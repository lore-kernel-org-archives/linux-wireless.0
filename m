Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:60046 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888AbZDHSVG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:06 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/18] iwl3945: delay mode setting
Date: Wed,  8 Apr 2009 11:26:38 -0700
Message-Id: <1239215212-1657-5-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202117_484460_0C256514)
In-Reply-To: <1239215212-1657-4-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-3-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Delay mode setting till uCode is ready.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6c11c8a..d1aaf7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2758,6 +2758,9 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 			iwl_mac_beacon_update(priv->hw, beacon);
 	}
 
+	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
+		iwl3945_set_mode(priv, priv->iw_mode);
+
 	return;
 
  restart:
@@ -3497,8 +3500,8 @@ static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
 		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 	}
 
-	if (iwl_is_ready(priv))
-		iwl3945_set_mode(priv, conf->type);
+	if (iwl3945_set_mode(priv, conf->type) == -EAGAIN)
+		set_bit(STATUS_MODE_PENDING, &priv->status);
 
 	mutex_unlock(&priv->mutex);
 
-- 
1.5.6.3

