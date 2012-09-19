Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab2ISHco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 03:32:44 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: constify name parameter to add_virtual_intf
Date: Wed, 19 Sep 2012 09:33:18 +0200
Message-Id: <1348039998-7739-1-git-send-email-johannes@sipsolutions.net> (sfid-20120919_093247_434548_B47DB518)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The name can't be modified by the driver,
make it const.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 ++--
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c    |    2 +-
 drivers/net/wireless/mwifiex/main.h        |    2 +-
 include/net/cfg80211.h                     |    2 +-
 net/mac80211/cfg.c                         |    3 ++-
 6 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 86aeef4..7089f81 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1488,7 +1488,7 @@ static int ath6kl_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 }
 
 static struct wireless_dev *ath6kl_cfg80211_add_iface(struct wiphy *wiphy,
-						      char *name,
+						      const char *name,
 						      enum nl80211_iftype type,
 						      u32 *flags,
 						      struct vif_params *params)
@@ -3477,7 +3477,7 @@ void ath6kl_cfg80211_vif_cleanup(struct ath6kl_vif *vif)
 	ar->num_vif--;
 }
 
-struct wireless_dev *ath6kl_interface_add(struct ath6kl *ar, char *name,
+struct wireless_dev *ath6kl_interface_add(struct ath6kl *ar, const char *name,
 					  enum nl80211_iftype type,
 					  u8 fw_vif_idx, u8 nw_type)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 56b1ebe..780f777 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -25,7 +25,7 @@ enum ath6kl_cfg_suspend_mode {
 	ATH6KL_CFG_SUSPEND_SCHED_SCAN,
 };
 
-struct wireless_dev *ath6kl_interface_add(struct ath6kl *ar, char *name,
+struct wireless_dev *ath6kl_interface_add(struct ath6kl *ar, const char *name,
 					  enum nl80211_iftype type,
 					  u8 fw_vif_idx, u8 nw_type);
 void ath6kl_cfg80211_ch_switch_notify(struct ath6kl_vif *vif, int freq,
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e57f543..49e2066 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1597,7 +1597,7 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
  *  create a new virtual interface with the given name
  */
 struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
-					      char *name,
+					      const char *name,
 					      enum nl80211_iftype type,
 					      u32 *flags,
 					      struct vif_params *params)
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 994bc4f..d2fb3c3e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1030,7 +1030,7 @@ int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
 					struct mwifiex_bssdescriptor *bss_desc);
 
 struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
-					      char *name,
+					      const char *name,
 					      enum nl80211_iftype type,
 					      u32 *flags,
 					      struct vif_params *params);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 80051ff..ab78b53 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1628,7 +1628,7 @@ struct cfg80211_ops {
 	void	(*set_wakeup)(struct wiphy *wiphy, bool enabled);
 
 	struct wireless_dev * (*add_virtual_intf)(struct wiphy *wiphy,
-						  char *name,
+						  const char *name,
 						  enum nl80211_iftype type,
 						  u32 *flags,
 						  struct vif_params *params);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9bd56a7..05f3a31 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -20,7 +20,8 @@
 #include "rate.h"
 #include "mesh.h"
 
-static struct wireless_dev *ieee80211_add_iface(struct wiphy *wiphy, char *name,
+static struct wireless_dev *ieee80211_add_iface(struct wiphy *wiphy,
+						const char *name,
 						enum nl80211_iftype type,
 						u32 *flags,
 						struct vif_params *params)
-- 
1.7.10.4

