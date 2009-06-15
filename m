Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:55792 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757208AbZFOPjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 11:39:10 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 10/12][w-t] iwmc3200wifi: cache keys when interface is down
Date: Mon, 15 Jun 2009 17:39:26 +0200
Message-Id: <d23bf33585e775f6432e246ecb232e29cf0b49ed.1245076752.git.samuel@sortiz.org>
In-Reply-To: <d0765f00e18e0501dc41d8507f05eb03ec940cdc.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
 <8843005a4ec0cad33483426a4ecc7656bce24243.1245076752.git.samuel@sortiz.org>
 <afbb543a0654cc171faa882457cc603d3f038d27.1245076752.git.samuel@sortiz.org>
 <9b2b9b463d1313b871f56ad77b48b4960653b766.1245076752.git.samuel@sortiz.org>
 <ed1078e3b1524ac3bf3888b0881e40bddc8fb690.1245076752.git.samuel@sortiz.org>
 <99a6f971c65b2fb751206cff9e428eb60037629b.1245076752.git.samuel@sortiz.org>
 <f3d3b8fac2046f9c26773232c585b4c688b8df03.1245076752.git.samuel@sortiz.org>
 <87c8d2a38226859644cfd3217366a4e42d9e7d81.1245076752.git.samuel@sortiz.org>
 <d0337f0d1ddef69bbb0144eb894bafd0580550d6.1245076752.git.samuel@sortiz.org>
 <d0765f00e18e0501dc41d8507f05eb03ec940cdc.1245076752.git.samuel@sortiz.org>
In-Reply-To: <cover.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
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
index 3ac5a16..bbc3c6b 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -647,19 +647,10 @@ int __iwm_up(struct iwm_priv *iwm)
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
@@ -667,10 +658,6 @@ int __iwm_up(struct iwm_priv *iwm)
 
 	return 0;
 
- err_profile:
-	kfree(iwm->umac_profile);
-	iwm->umac_profile = NULL;
-
  err_fw:
 	iwm_eeprom_exit(iwm);
 
@@ -709,10 +696,9 @@ int __iwm_down(struct iwm_priv *iwm)
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
index d1797b9..48e626f 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -48,6 +48,7 @@
 #include <linux/netdevice.h>
 
 #include "iwm.h"
+#include "commands.h"
 #include "cfg80211.h"
 #include "debug.h"
 
@@ -137,8 +138,20 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
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
 
@@ -155,6 +168,8 @@ void iwm_if_free(struct iwm_priv *iwm)
 	free_netdev(iwm_to_ndev(iwm));
 	iwm_wdev_free(iwm);
 	iwm_priv_deinit(iwm);
+	kfree(iwm->umac_profile);
+	iwm->umac_profile = NULL;
 }
 
 int iwm_if_add(struct iwm_priv *iwm)
-- 
1.6.3.1

