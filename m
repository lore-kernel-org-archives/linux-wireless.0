Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47939 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab1HJTus (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 15:50:48 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, zajec5@gmail.com,
	Larry.Finger@lwfinger.net, b43-dev@lists.infradead.org
Subject: [PATCH] b43: reload phy and bss settings after core restarts
Date: Wed, 10 Aug 2011 13:50:30 -0600
Message-Id: <1313005830-83362-1-git-send-email-nbd@openwrt.org> (sfid-20110810_215050_224291_00DB1265)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

b43_op_config and b43_op_bss_info_changed apply many settings by directly
writing to hardware registers. These settings are lost as soon as the core
is restarted and the initvals are reloaded. This was discovered because
restarting hostapd led to the beacon interval getting set to ~33s (see
https://dev.openwrt.org/ticket/8033 for more information).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/b43/main.c |   42 ++++++++++++++++++++++++++++++++++----
 1 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index d2661aa..4a5cac6 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -320,6 +320,10 @@ static void b43_wireless_core_exit(struct b43_wldev *dev);
 static int b43_wireless_core_init(struct b43_wldev *dev);
 static struct b43_wldev * b43_wireless_core_stop(struct b43_wldev *dev);
 static int b43_wireless_core_start(struct b43_wldev *dev);
+static void b43_op_bss_info_changed(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_bss_conf *conf,
+				    u32 changed);
 
 static int b43_ratelimit(struct b43_wl *wl)
 {
@@ -3778,14 +3782,24 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 	int antenna;
 	int err = 0;
+	bool reload_bss = false;
 
 	mutex_lock(&wl->mutex);
 
+	dev = wl->current_dev;
+
 	/* Switch the band (if necessary). This might change the active core. */
 	err = b43_switch_band(wl, conf->channel);
 	if (err)
 		goto out_unlock_mutex;
-	dev = wl->current_dev;
+
+	/* Need to reload all settings if the core changed */
+	if (dev != wl->current_dev) {
+		dev = wl->current_dev;
+		changed = ~0;
+		reload_bss = true;
+	}
+
 	phy = &dev->phy;
 
 	if (conf_is_ht(conf))
@@ -3846,6 +3860,9 @@ out_mac_enable:
 out_unlock_mutex:
 	mutex_unlock(&wl->mutex);
 
+	if (wl->vif && reload_bss)
+		b43_op_bss_info_changed(hw, wl->vif, &wl->vif->bss_conf, ~0);
+
 	return err;
 }
 
@@ -3934,7 +3951,8 @@ static void b43_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BEACON_INT &&
 	    (b43_is_mode(wl, NL80211_IFTYPE_AP) ||
 	     b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT) ||
-	     b43_is_mode(wl, NL80211_IFTYPE_ADHOC)))
+	     b43_is_mode(wl, NL80211_IFTYPE_ADHOC)) &&
+	    conf->beacon_int)
 		b43_set_beacon_int(dev, conf->beacon_int);
 
 	if (changed & BSS_CHANGED_BASIC_RATES)
@@ -4702,6 +4720,9 @@ static int b43_op_add_interface(struct ieee80211_hw *hw,
  out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
 
+	if (err == 0)
+		b43_op_bss_info_changed(hw, vif, &vif->bss_conf, ~0);
+
 	return err;
 }
 
@@ -4772,6 +4793,9 @@ static int b43_op_start(struct ieee80211_hw *hw)
  out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
 
+	/* reload configuration */
+	b43_op_config(hw, ~0);
+
 	return err;
 }
 
@@ -4928,10 +4952,18 @@ out:
 	if (err)
 		wl->current_dev = NULL; /* Failed to init the dev. */
 	mutex_unlock(&wl->mutex);
-	if (err)
+
+	if (err) {
 		b43err(wl, "Controller restart FAILED\n");
-	else
-		b43info(wl, "Controller restarted\n");
+		return;
+	}
+
+	/* reload configuration */
+	b43_op_config(wl->hw, ~0);
+	if (wl->vif)
+		b43_op_bss_info_changed(wl->hw, wl->vif, &wl->vif->bss_conf, ~0);
+
+	b43info(wl, "Controller restarted\n");
 }
 
 static int b43_setup_bands(struct b43_wldev *dev,
-- 
1.7.3.2

