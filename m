Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57749 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaEaSuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 14:50:01 -0400
Received: by mail-wi0-f174.google.com with SMTP id r20so2688455wiv.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 11:50:00 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/9] b43: b43_op_config: drop check for core change
Date: Sat, 31 May 2014 20:49:34 +0200
Message-Id: <1401562181-14608-3-git-send-email-zajec5@gmail.com> (sfid-20140531_205013_838077_E4C734EE)
In-Reply-To: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
References: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There aren't devices with multiple 802.11 cores supported by b43.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 32538ac..a9e50ee 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3798,17 +3798,13 @@ static void b43_set_retry_limits(struct b43_wldev *dev,
 static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev;
-	struct b43_phy *phy;
+	struct b43_wldev *dev = wl->current_dev;
+	struct b43_phy *phy = &dev->phy;
 	struct ieee80211_conf *conf = &hw->conf;
 	int antenna;
 	int err = 0;
-	bool reload_bss = false;
 
 	mutex_lock(&wl->mutex);
-
-	dev = wl->current_dev;
-
 	b43_mac_suspend(dev);
 
 	/* Switch the band (if necessary). This might change the active core. */
@@ -3816,15 +3812,6 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (err)
 		goto out_unlock_mutex;
 
-	/* Need to reload all settings if the core changed */
-	if (dev != wl->current_dev) {
-		dev = wl->current_dev;
-		changed = ~0;
-		reload_bss = true;
-	}
-
-	phy = &dev->phy;
-
 	if (conf_is_ht(conf))
 		phy->is_40mhz =
 			(conf_is_ht40_minus(conf) || conf_is_ht40_plus(conf));
@@ -3881,9 +3868,6 @@ out_mac_enable:
 out_unlock_mutex:
 	mutex_unlock(&wl->mutex);
 
-	if (wl->vif && reload_bss)
-		b43_op_bss_info_changed(hw, wl->vif, &wl->vif->bss_conf, ~0);
-
 	return err;
 }
 
-- 
1.8.4.5

