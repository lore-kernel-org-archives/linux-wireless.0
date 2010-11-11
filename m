Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:56652 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab0KKO6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:58:09 -0500
Date: Thu, 11 Nov 2010 15:58:06 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Message-ID: <11504658.1091289487485202.JavaMail.wlan@CHBU500181>
In-Reply-To: <19040211.731289486681533.JavaMail.wlan@CHBU500181>
Subject: [PATCH 5/9] ath5k: AHB port. Assume that pci device might not be
 initialized.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for ahb we have to assume that only generic
device is initialized and pci device might be not.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/attach.c |    5 ++---
 drivers/net/wireless/ath/ath5k/led.c    |    5 ++++-
 drivers/net/wireless/ath/ath5k/reset.c  |    4 ++--
 drivers/net/wireless/ath/ath5k/sysfs.c  |    4 ++--
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index fbe8aca..c5b2eb7 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -273,7 +273,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	/*
 	 * Write PCI-E power save settings
 	 */
-	if ((ah->ah_version == AR5K_AR5212) && (pdev->is_pcie)) {
+	if ((ah->ah_version == AR5K_AR5212) && pdev && (pdev->is_pcie)) {
 		ath5k_hw_reg_write(ah, 0x9248fc00, AR5K_PCIE_SERDES);
 		ath5k_hw_reg_write(ah, 0x24924924, AR5K_PCIE_SERDES);
 
@@ -305,8 +305,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	/* Get misc capabilities */
 	ret = ath5k_hw_set_capabilities(ah);
 	if (ret) {
-		ATH5K_ERR(sc, "unable to get device capabilities: 0x%04x\n",
-			sc->pdev->device);
+		ATH5K_ERR(sc, "unable to get device capabilities\n");
 		goto err;
 	}
 
diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 67aa52e..1f5a991 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -133,7 +133,7 @@ ath5k_register_led(struct ath5k_softc *sc, struct ath5k_led *led,
 	led->led_dev.default_trigger = trigger;
 	led->led_dev.brightness_set = ath5k_led_brightness_set;
 
-	err = led_classdev_register(&sc->pdev->dev, &led->led_dev);
+	err = led_classdev_register(sc->dev, &led->led_dev);
 	if (err) {
 		ATH5K_WARN(sc, "could not register LED %s\n", name);
 		led->sc = NULL;
@@ -165,6 +165,9 @@ int ath5k_init_leds(struct ath5k_softc *sc)
 	char name[ATH5K_LED_MAX_NAME_LEN + 1];
 	const struct pci_device_id *match;
 
+	if (!sc->pdev)
+		return 0;
+
 	match = pci_match_id(&ath5k_led_devices[0], pdev);
 	if (match) {
 		__set_bit(ATH_STAT_LEDSOFT, sc->status);
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 5b179d0..198a146 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -349,7 +349,7 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 	 * we ingore that flag for PCI-E cards. On PCI cards
 	 * this flag gets cleared after 64 PCI clocks.
 	 */
-	bus_flags = (pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
+	bus_flags = (pdev && pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
 
 	if (ah->ah_version == AR5K_AR5210) {
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
@@ -405,7 +405,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	 * we ingore that flag for PCI-E cards. On PCI cards
 	 * this flag gets cleared after 64 PCI clocks.
 	 */
-	bus_flags = (pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
+	bus_flags = (pdev && pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
 
 	if (ah->ah_version == AR5K_AR5210) {
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
diff --git a/drivers/net/wireless/ath/ath5k/sysfs.c b/drivers/net/wireless/ath/ath5k/sysfs.c
index 90757de..929c68c 100644
--- a/drivers/net/wireless/ath/ath5k/sysfs.c
+++ b/drivers/net/wireless/ath/ath5k/sysfs.c
@@ -95,7 +95,7 @@ static struct attribute_group ath5k_attribute_group_ani = {
 int
 ath5k_sysfs_register(struct ath5k_softc *sc)
 {
-	struct device *dev = &sc->pdev->dev;
+	struct device *dev = sc->dev;
 	int err;
 
 	err = sysfs_create_group(&dev->kobj, &ath5k_attribute_group_ani);
@@ -110,7 +110,7 @@ ath5k_sysfs_register(struct ath5k_softc *sc)
 void
 ath5k_sysfs_unregister(struct ath5k_softc *sc)
 {
-	struct device *dev = &sc->pdev->dev;
+	struct device *dev = sc->dev;
 
 	sysfs_remove_group(&dev->kobj, &ath5k_attribute_group_ani);
 }
-- 
1.7.1

