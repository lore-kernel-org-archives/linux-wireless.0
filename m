Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48646 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaEQVZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 17:25:14 -0400
Received: by mail-ee0-f51.google.com with SMTP id e51so2460207eek.24
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 14:25:13 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [next][PATCH 4/4] b43: rework band switching
Date: Sat, 17 May 2014 23:24:56 +0200
Message-Id: <1400361896-7345-4-git-send-email-zajec5@gmail.com> (sfid-20140517_232522_045744_79BACBDE)
In-Reply-To: <1400361896-7345-1-git-send-email-zajec5@gmail.com>
References: <1400361896-7345-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We always operate on one core and simple band switch doesn't require
full core reset. Simply reset the PHY.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c       | 104 ++++++++++++++--------------------
 drivers/net/wireless/b43/phy_common.c |   1 +
 2 files changed, 45 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 46212d4..a50e00c 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3698,89 +3698,73 @@ static const char *band_to_string(enum ieee80211_band band)
 }
 
 /* Expects wl->mutex locked */
-static int b43_switch_band(struct b43_wl *wl, struct ieee80211_channel *chan)
+static int b43_switch_band(struct b43_wldev *dev,
+			   struct ieee80211_channel *chan)
 {
-	struct b43_wldev *up_dev = NULL;
-	struct b43_wldev *down_dev;
-	int err;
-	bool uninitialized_var(gmode);
-	int prev_status;
+	struct b43_phy *phy = &dev->phy;
+	bool gmode;
+	u32 tmp;
 
-	/* Find a device and PHY which supports the band. */
 	switch (chan->band) {
 	case IEEE80211_BAND_5GHZ:
-		if (wl->current_dev->phy.supports_5ghz) {
-			up_dev = wl->current_dev;
-			gmode = false;
-		}
+		gmode = false;
 		break;
 	case IEEE80211_BAND_2GHZ:
-		if (wl->current_dev->phy.supports_2ghz) {
-			up_dev = wl->current_dev;
-			gmode = true;
-		}
+		gmode = true;
 		break;
 	default:
 		B43_WARN_ON(1);
 		return -EINVAL;
 	}
 
-	if (!up_dev) {
-		b43err(wl, "Could not find a device for %s-GHz band operation\n",
+	if (!((gmode && phy->supports_2ghz) ||
+	      (!gmode && phy->supports_5ghz))) {
+		b43err(dev->wl, "This device doesn't support %s-GHz band\n",
 		       band_to_string(chan->band));
 		return -ENODEV;
 	}
-	if (!!wl->current_dev->phy.gmode == !!gmode) {
+
+	if (!!phy->gmode == !!gmode) {
 		/* This device is already running. */
 		return 0;
 	}
-	b43dbg(wl, "Switching to %s-GHz band\n",
+
+	b43dbg(dev->wl, "Switching to %s GHz band\n",
 	       band_to_string(chan->band));
-	down_dev = wl->current_dev;
 
-	prev_status = b43_status(down_dev);
-	/* Shutdown the currently running core. */
-	if (prev_status >= B43_STAT_STARTED)
-		down_dev = b43_wireless_core_stop(down_dev);
-	if (prev_status >= B43_STAT_INITIALIZED)
-		b43_wireless_core_exit(down_dev);
+	b43_software_rfkill(dev, true);
 
-	if (down_dev != up_dev) {
-		/* We switch to a different core, so we put PHY into
-		 * RESET on the old core. */
-		b43_phy_put_into_reset(down_dev);
+	phy->gmode = gmode;
+	b43_phy_put_into_reset(dev);
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
+		if (gmode)
+			tmp |= B43_BCMA_IOCTL_GMODE;
+		else
+			tmp &= ~B43_BCMA_IOCTL_GMODE;
+		bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, tmp);
+		break;
+#endif
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
+		if (gmode)
+			tmp |= B43_TMSLOW_GMODE;
+		else
+			tmp &= ~B43_TMSLOW_GMODE;
+		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
+		break;
+#endif
 	}
+	b43_phy_take_out_of_reset(dev);
 
-	/* Now start the new core. */
-	up_dev->phy.gmode = gmode;
-	if (prev_status >= B43_STAT_INITIALIZED) {
-		err = b43_wireless_core_init(up_dev);
-		if (err) {
-			b43err(wl, "Fatal: Could not initialize device for "
-			       "selected %s-GHz band\n",
-			       band_to_string(chan->band));
-			goto init_failure;
-		}
-	}
-	if (prev_status >= B43_STAT_STARTED) {
-		err = b43_wireless_core_start(up_dev);
-		if (err) {
-			b43err(wl, "Fatal: Could not start device for "
-			       "selected %s-GHz band\n",
-			       band_to_string(chan->band));
-			b43_wireless_core_exit(up_dev);
-			goto init_failure;
-		}
-	}
-	B43_WARN_ON(b43_status(up_dev) != prev_status);
+	b43_upload_initvals_band(dev);
 
-	wl->current_dev = up_dev;
+	b43_phy_init(dev);
 
 	return 0;
-init_failure:
-	/* Whoops, failed to init the new core. No core is operating now. */
-	wl->current_dev = NULL;
-	return err;
 }
 
 /* Write the short and long frame retry limit values. */
@@ -3813,8 +3797,10 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	dev = wl->current_dev;
 
+	b43_mac_suspend(dev);
+
 	/* Switch the band (if necessary). This might change the active core. */
-	err = b43_switch_band(wl, conf->chandef.chan);
+	err = b43_switch_band(dev, conf->chandef.chan);
 	if (err)
 		goto out_unlock_mutex;
 
@@ -3833,8 +3819,6 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	else
 		phy->is_40mhz = false;
 
-	b43_mac_suspend(dev);
-
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		b43_set_retry_limits(dev, conf->short_frame_max_tx_count,
 					  conf->long_frame_max_tx_count);
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 26e390f..fb0dddd 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -96,6 +96,7 @@ int b43_phy_init(struct b43_wldev *dev)
 
 	phy->channel = ops->get_default_chan(dev);
 
+	phy->ops->switch_analog(dev, true);
 	b43_software_rfkill(dev, false);
 	err = ops->init(dev);
 	if (err) {
-- 
1.8.4.5

