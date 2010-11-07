Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55450 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab0KGRWt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 12:22:49 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Nov 2010 17:22:41 +0000
Message-ID: <1289150561.2816.75.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 3/5] Staging: Update parameters for cfg80211 key management
 operation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit e31b82136d1adc7a599b6e99d3321e5831841f5a ("cfg80211/mac80211:
allow per-station GTKs") changed the signatures of these operations
but did not update the staging drivers.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Compile-tested only.  This should be 2.6.37 material.

Ben.

 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   12 ++++++------
 drivers/staging/wlan-ng/cfg80211.c               |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 3f29488..ea08252 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -95,12 +95,12 @@ static s32 wl_cfg80211_config_default_key(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    u8 key_idx);
 static s32 wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
-				 u8 key_idx, const u8 *mac_addr,
+				 u8 key_idx, bool pairwise, const u8 *mac_addr,
 				 struct key_params *params);
 static s32 wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
-				 u8 key_idx, const u8 *mac_addr);
+				 u8 key_idx, bool pairwise, const u8 *mac_addr);
 static s32 wl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
-				 u8 key_idx, const u8 *mac_addr,
+				 u8 key_idx, bool pairwise, const u8 *mac_addr,
 				 void *cookie, void (*callback) (void *cookie,
 								 struct
 								 key_params *
@@ -1615,7 +1615,7 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 
 static s32
 wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
-		    u8 key_idx, const u8 *mac_addr,
+		    u8 key_idx, bool pairwise, const u8 *mac_addr,
 		    struct key_params *params)
 {
 	struct wl_wsec_key key;
@@ -1700,7 +1700,7 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 
 static s32
 wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
-		    u8 key_idx, const u8 *mac_addr)
+		    u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
 	struct wl_wsec_key key;
 	s32 err = 0;
@@ -1756,7 +1756,7 @@ wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 
 static s32
 wl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
-		    u8 key_idx, const u8 *mac_addr, void *cookie,
+		    u8 key_idx, bool pairwise, const u8 *mac_addr, void *cookie,
 		    void (*callback) (void *cookie, struct key_params * params))
 {
 	struct key_params params;
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 4af83d5..6a71f52 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -139,7 +139,7 @@ exit:
 }
 
 int prism2_add_key(struct wiphy *wiphy, struct net_device *dev,
-		   u8 key_index, const u8 *mac_addr,
+		   u8 key_index, bool pairwise, const u8 *mac_addr,
 		   struct key_params *params)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
@@ -198,7 +198,7 @@ exit:
 }
 
 int prism2_get_key(struct wiphy *wiphy, struct net_device *dev,
-		   u8 key_index, const u8 *mac_addr, void *cookie,
+		   u8 key_index, bool pairwise, const u8 *mac_addr, void *cookie,
 		   void (*callback)(void *cookie, struct key_params*))
 {
 	wlandevice_t *wlandev = dev->ml_priv;
@@ -227,7 +227,7 @@ int prism2_get_key(struct wiphy *wiphy, struct net_device *dev,
 }
 
 int prism2_del_key(struct wiphy *wiphy, struct net_device *dev,
-		   u8 key_index, const u8 *mac_addr)
+		   u8 key_index, bool pairwise, const u8 *mac_addr)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
 	u32 did;
-- 
1.7.2.3



