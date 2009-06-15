Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:4207 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755780AbZFOT6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 15:58:14 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 09/11 v2][w-t] iwmc3200wifi: cache keys when interface is down
Date: Mon, 15 Jun 2009 21:59:54 +0200
Message-Id: <152420b3b2ccbe623cb80cd3cc37d4ced05e470b.1245091931.git.samuel@sortiz.org>
In-Reply-To: <ef2fab83a02bac39c9547326d419f51789659161.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
 <7413d2605b449b8e43bcfe61719ee30fccb592b7.1245091931.git.samuel@sortiz.org>
 <e72e3c0d6b16655fdf4da5dcabc6349be7b5c0a2.1245091931.git.samuel@sortiz.org>
 <4fa0241c41670096a2933b81c7bd32e6a5551faa.1245091931.git.samuel@sortiz.org>
 <445a117dd08007f653105f41f36f9bbf2ed1e4c6.1245091931.git.samuel@sortiz.org>
 <3e375906194bc0105dd43d39260e2a826bf5b557.1245091931.git.samuel@sortiz.org>
 <ef2fab83a02bac39c9547326d419f51789659161.1245091931.git.samuel@sortiz.org>
In-Reply-To: <cover.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

When the interface is down and one sets a WEP key from userspace, we should
be able to simply cache it.
Since that implies setting part of the profile's security settings, we now
alloc/free the umac_profile at probe/remove time, and no longer at interface
bring up/down time. Simply resetting it during the latter is enough.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   12 ++++++++++--
 drivers/net/wireless/iwmc3200wifi/main.c     |   20 +++-----------------
 drivers/net/wireless/iwmc3200wifi/netdev.c   |   15 +++++++++++++++
 3 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index ad62b20..71efbc1 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -271,6 +271,10 @@ static int iwm_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (key_index == iwm->default_key)
 		iwm->default_key = -1;
 
+	/* If the interface is down, we just cache this */
+	if (!test_bit(IWM_STATUS_READY, &iwm->status))
+		return 0;
+
 	return iwm_set_key(iwm, 1, key);
 }
 
@@ -288,12 +292,16 @@ static int iwm_cfg80211_set_default_key(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
+	iwm->default_key = key_index;
+
+	/* If the interface is down, we just cache this */
+	if (!test_bit(IWM_STATUS_READY, &iwm->status))
+		return 0;
+
 	ret = iwm_set_tx_key(iwm, key_index);
 	if (ret < 0)
 		return ret;
 
-	iwm->default_key = key_index;
-
 	return iwm_reset_profile(iwm);
 }
 
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 7f56c06..930056b 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -643,19 +643,10 @@ int __iwm_up(struct iwm_priv *iwm)
 		}
 	}
 
-	iwm->umac_profile = kmalloc(sizeof(struct iwm_umac_profile),
-				    GFP_KERNEL);
-	if (!iwm->umac_profile) {
-		IWM_ERR(iwm, "Couldn't alloc memory for profile\n");
-		goto err_fw;
-	}
-
-	iwm_init_default_profile(iwm, iwm->umac_profile);
-
 	ret = iwm_channels_init(iwm);
 	if (ret < 0) {
 		IWM_ERR(iwm, "Couldn't init channels\n");
-		goto err_profile;
+		goto err_fw;
 	}
 
 	/* Set the READY bit to indicate interface is brought up successfully */
@@ -663,10 +654,6 @@ int __iwm_up(struct iwm_priv *iwm)
 
 	return 0;
 
- err_profile:
-	kfree(iwm->umac_profile);
-	iwm->umac_profile = NULL;
-
  err_fw:
 	iwm_eeprom_exit(iwm);
 
@@ -705,10 +692,9 @@ int __iwm_down(struct iwm_priv *iwm)
 	clear_bit(IWM_STATUS_READY, &iwm->status);
 
 	iwm_eeprom_exit(iwm);
-	kfree(iwm->umac_profile);
-	iwm->umac_profile = NULL;
 	iwm_bss_list_clean(iwm);
-
+	iwm_init_default_profile(iwm, iwm->umac_profile);
+	iwm->umac_profile_active = false;
 	iwm->default_key = -1;
 	iwm->core_enabled = 0;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index aaa20c6..d4deb4b 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -48,6 +48,7 @@
 #include <linux/netdevice.h>
 
 #include "iwm.h"
+#include "commands.h"
 #include "cfg80211.h"
 #include "debug.h"
 
@@ -135,8 +136,20 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
 
+	iwm->umac_profile = kmalloc(sizeof(struct iwm_umac_profile),
+				    GFP_KERNEL);
+	if (!iwm->umac_profile) {
+		dev_err(dev, "Couldn't alloc memory for profile\n");
+		goto out_profile;
+	}
+
+	iwm_init_default_profile(iwm, iwm->umac_profile);
+
 	return iwm;
 
+ out_profile:
+	free_netdev(ndev);
+
  out_priv:
 	iwm_priv_deinit(iwm);
 
@@ -153,6 +166,8 @@ void iwm_if_free(struct iwm_priv *iwm)
 	free_netdev(iwm_to_ndev(iwm));
 	iwm_wdev_free(iwm);
 	iwm_priv_deinit(iwm);
+	kfree(iwm->umac_profile);
+	iwm->umac_profile = NULL;
 }
 
 int iwm_if_add(struct iwm_priv *iwm)
-- 
1.6.3.1

