Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57019 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab1EQX3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 19:29:41 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so286932eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 16:29:40 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 9/9] b43: bus: abstract bus and core operations
Date: Wed, 18 May 2011 02:06:43 +0200
Message-Id: <1305677203-16660-9-git-send-email-zajec5@gmail.com> (sfid-20110518_012944_927791_CED72A3C)
In-Reply-To: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
References: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h    |   23 +++++++++++++++++++++++
 drivers/net/wireless/b43/bus.c    |   31 +++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/bus.h    |    8 ++++++++
 drivers/net/wireless/b43/main.c   |   22 +++++++++++-----------
 drivers/net/wireless/b43/rfkill.c |    9 ++++-----
 5 files changed, 77 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index a6d4848..298a445 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -881,6 +881,29 @@ static inline enum ieee80211_band b43_current_band(struct b43_wl *wl)
 	return wl->hw->conf.channel->band;
 }
 
+static inline int b43_bus_may_powerdown(struct b43_wldev *wldev)
+{
+	return wldev->dev->bus_may_powerdown(wldev->dev);
+}
+static inline int b43_bus_powerup(struct b43_wldev *wldev, bool dynamic_pctl)
+{
+	return wldev->dev->bus_powerup(wldev->dev, dynamic_pctl);
+}
+static inline int b43_device_is_enabled(struct b43_wldev *wldev)
+{
+	return wldev->dev->device_is_enabled(wldev->dev);
+}
+static inline void b43_device_enable(struct b43_wldev *wldev,
+				     u32 core_specific_flags)
+{
+	wldev->dev->device_enable(wldev->dev, core_specific_flags);
+}
+static inline void b43_device_disable(struct b43_wldev *wldev,
+				      u32 core_specific_flags)
+{
+	wldev->dev->device_disable(wldev->dev, core_specific_flags);
+}
+
 static inline u16 b43_read16(struct b43_wldev *dev, u16 offset)
 {
 	return dev->dev->read16(dev->dev, offset);
diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index f897b70..6c63aec 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -25,6 +25,31 @@
 
 
 /* SSB */
+
+static inline int b43_bus_ssb_bus_may_powerdown(struct b43_bus_dev *dev)
+{
+	return ssb_bus_may_powerdown(dev->sdev->bus);
+}
+static inline int b43_bus_ssb_bus_powerup(struct b43_bus_dev *dev,
+					  bool dynamic_pctl)
+{
+	return ssb_bus_powerup(dev->sdev->bus, dynamic_pctl);
+}
+static inline int b43_bus_ssb_device_is_enabled(struct b43_bus_dev *dev)
+{
+	return ssb_device_is_enabled(dev->sdev);
+}
+static inline void b43_bus_ssb_device_enable(struct b43_bus_dev *dev,
+					     u32 core_specific_flags)
+{
+	ssb_device_enable(dev->sdev, core_specific_flags);
+}
+static inline void b43_bus_ssb_device_disable(struct b43_bus_dev *dev,
+					      u32 core_specific_flags)
+{
+	ssb_device_disable(dev->sdev, core_specific_flags);
+}
+
 static inline u16 b43_bus_ssb_read16(struct b43_bus_dev *dev, u16 offset)
 {
 	return ssb_read16(dev->sdev, offset);
@@ -63,6 +88,12 @@ struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 	dev->bus_type = B43_BUS_SSB;
 	dev->sdev = sdev;
 
+	dev->bus_may_powerdown = b43_bus_ssb_bus_may_powerdown;
+	dev->bus_powerup = b43_bus_ssb_bus_powerup;
+	dev->device_is_enabled = b43_bus_ssb_device_is_enabled;
+	dev->device_enable = b43_bus_ssb_device_enable;
+	dev->device_disable = b43_bus_ssb_device_disable;
+
 	dev->read16 = b43_bus_ssb_read16;
 	dev->read32 = b43_bus_ssb_read32;
 	dev->write16 = b43_bus_ssb_write16;
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index e88b449..fd88e2b 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -11,6 +11,14 @@ struct b43_bus_dev {
 		struct ssb_device *sdev;
 	};
 
+	int (*bus_may_powerdown)(struct b43_bus_dev *dev);
+	int (*bus_powerup)(struct b43_bus_dev *dev, bool dynamic_pctl);
+	int (*device_is_enabled)(struct b43_bus_dev *dev);
+	void (*device_enable)(struct b43_bus_dev *dev,
+			      u32 core_specific_flags);
+	void (*device_disable)(struct b43_bus_dev *dev,
+			       u32 core_specific_flags);
+
 	u16 (*read16)(struct b43_bus_dev *dev, u16 offset);
 	u32 (*read32)(struct b43_bus_dev *dev, u16 offset);
 	void (*write16)(struct b43_bus_dev *dev, u16 offset, u16 value);
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index e80aaef..bb82ddf 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1152,7 +1152,7 @@ static void b43_ssb_wireless_core_reset(struct b43_wldev *dev, u32 flags)
 	flags |= B43_TMSLOW_PHYRESET;
 	if (dev->phy.type == B43_PHYTYPE_N)
 		flags |= B43_TMSLOW_PHY_BANDWIDTH_20MHZ; /* Make 20 MHz def */
-	ssb_device_enable(dev->sdev, flags);
+	b43_device_enable(dev, flags);
 	msleep(2);		/* Wait for the PLL to turn on. */
 
 	/* Now take the PHY out of Reset again */
@@ -4310,8 +4310,8 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 		dev->wl->current_beacon = NULL;
 	}
 
-	ssb_device_disable(dev->sdev, 0);
-	ssb_bus_may_powerdown(dev->sdev->bus);
+	b43_device_disable(dev, 0);
+	b43_bus_may_powerdown(dev);
 }
 
 /* Initialize a wireless core */
@@ -4326,10 +4326,10 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 
 	B43_WARN_ON(b43_status(dev) != B43_STAT_UNINIT);
 
-	err = ssb_bus_powerup(bus, 0);
+	err = b43_bus_powerup(dev, 0);
 	if (err)
 		goto out;
-	if (!ssb_device_is_enabled(dev->sdev)) {
+	if (!b43_device_is_enabled(dev)) {
 		tmp = phy->gmode ? B43_TMSLOW_GMODE : 0;
 		b43_wireless_core_reset(dev, tmp);
 	}
@@ -4414,7 +4414,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	b43_set_synth_pu_delay(dev, 1);
 	b43_bluetooth_coext_enable(dev);
 
-	ssb_bus_powerup(bus, !(sprom->boardflags_lo & B43_BFL_XTAL_NOSLOW));
+	b43_bus_powerup(dev, !(sprom->boardflags_lo & B43_BFL_XTAL_NOSLOW));
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
 
@@ -4431,7 +4431,7 @@ out:
 err_chip_exit:
 	b43_chip_exit(dev);
 err_busdown:
-	ssb_bus_may_powerdown(bus);
+	b43_bus_may_powerdown(dev);
 	B43_WARN_ON(b43_status(dev) != B43_STAT_UNINIT);
 	return err;
 }
@@ -4750,7 +4750,7 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	 * that in core_init(), too.
 	 */
 
-	err = ssb_bus_powerup(bus, 0);
+	err = b43_bus_powerup(dev, 0);
 	if (err) {
 		b43err(wl, "Bus powerup failed\n");
 		goto out;
@@ -4832,8 +4832,8 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	INIT_WORK(&dev->restart_work, b43_chip_reset);
 
 	dev->phy.ops->switch_analog(dev, 0);
-	ssb_device_disable(dev->sdev, 0);
-	ssb_bus_may_powerdown(bus);
+	b43_device_disable(dev, 0);
+	b43_bus_may_powerdown(dev);
 
 out:
 	return err;
@@ -4841,7 +4841,7 @@ out:
 err_phy_free:
 	b43_phy_free(dev);
 err_powerdown:
-	ssb_bus_may_powerdown(bus);
+	b43_bus_may_powerdown(dev);
 	return err;
 }
 
diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
index a617efe..59c3afe 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -37,17 +37,16 @@ void b43_rfkill_poll(struct ieee80211_hw *hw)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
-	struct ssb_bus *bus = dev->sdev->bus;
 	bool enabled;
 	bool brought_up = false;
 
 	mutex_lock(&wl->mutex);
 	if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED)) {
-		if (ssb_bus_powerup(bus, 0)) {
+		if (b43_bus_powerup(dev, 0)) {
 			mutex_unlock(&wl->mutex);
 			return;
 		}
-		ssb_device_enable(dev->sdev, 0);
+		b43_device_enable(dev, 0);
 		brought_up = true;
 	}
 
@@ -63,8 +62,8 @@ void b43_rfkill_poll(struct ieee80211_hw *hw)
 	}
 
 	if (brought_up) {
-		ssb_device_disable(dev->sdev, 0);
-		ssb_bus_may_powerdown(bus);
+		b43_device_disable(dev, 0);
+		b43_bus_may_powerdown(dev);
 	}
 
 	mutex_unlock(&wl->mutex);
-- 
1.7.3.4

