Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZEOOR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 10:17:29 -0400
Subject: some wireless suspend thoughts
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 15 May 2009 16:16:56 +0200
Message-Id: <1242397016.5799.102.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * kick pci driver suspend/resume out of ath9k and keep the device in
   low power while unused
 * make mac80211 send nullfunc for suspend/resume
 * make cfg80211 always call suspend/resume

This is quite hackish. It works for me, but my AP disassocs me anyway
because it probes every 5 seconds and if you don't respond ... however,
due to the nullfunc at resume time we notice very very quickly since it
sends a deauth as a response to that.

The ->shutdown hook in cfg80211 is a little odd.

To implement WoW on top of this, we need to refactor the cfg80211 hooks
and probably actually pass the information to ->stop after all, I think?
I can't think of a good way to do this.

johannes
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 
 drivers/net/wireless/ath/ath9k/main.c  |    6 ++
 drivers/net/wireless/ath/ath9k/pci.c   |   74 +++++++++++++--------------------
 net/mac80211/ieee80211_i.h             |    2 
 net/mac80211/pm.c                      |   11 ++++
 net/mac80211/util.c                    |    8 +++
 net/wireless/core.c                    |    2 
 net/wireless/core.h                    |    1 
 net/wireless/sysfs.c                   |   27 ++++++++++--
 9 files changed, 87 insertions(+), 46 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-05-15 15:17:08.879827920 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-05-15 15:17:09.889658880 +0200
@@ -630,6 +630,8 @@ struct ieee80211_local {
 	 */
 	bool quiescing;
 
+	bool ps_before_suspend;
+
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
--- wireless-testing.orig/net/mac80211/pm.c	2009-05-15 15:17:08.851827827 +0200
+++ wireless-testing/net/mac80211/pm.c	2009-05-15 15:17:09.891708511 +0200
@@ -16,6 +16,17 @@ int __ieee80211_suspend(struct ieee80211
 
 	ieee80211_scan_cancel(local);
 
+	local->ps_before_suspend = !!(local->hw.conf.flags & IEEE80211_CONF_PS);
+	local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+
+	del_timer_sync(&local->dynamic_ps_timer);
+	cancel_work_sync(&local->dynamic_ps_enable_work);
+
+	list_for_each_entry(sdata, &local->interfaces, list)
+		if (sdata->vif.type == NL80211_IFTYPE_STATION)
+			ieee80211_send_nullfunc(local, sdata, 1);
+
 	ieee80211_stop_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
--- wireless-testing.orig/net/mac80211/util.c	2009-05-15 15:17:08.926586888 +0200
+++ wireless-testing/net/mac80211/util.c	2009-05-15 15:17:09.893576341 +0200
@@ -1042,6 +1042,9 @@ int ieee80211_reconfig(struct ieee80211_
 	 */
 	local->suspended = false;
 
+	if (from_suspend && local->ps_before_suspend)
+		local->hw.conf.flags |= IEEE80211_CONF_PS;
+
 	/* restart hardware */
 	if (local->open_count) {
 		res = drv_start(local);
@@ -1144,6 +1147,11 @@ int ieee80211_reconfig(struct ieee80211_
 		return 0;
 
 #ifdef CONFIG_PM
+	if (!local->ps_before_suspend)
+		list_for_each_entry(sdata, &local->interfaces, list)
+			if (sdata->vif.type == NL80211_IFTYPE_STATION)
+				ieee80211_send_nullfunc(local, sdata, 0);
+
 	local->suspended = false;
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
--- wireless-testing.orig/net/wireless/sysfs.c	2009-05-15 15:17:09.063578302 +0200
+++ wireless-testing/net/wireless/sysfs.c	2009-05-15 15:26:00.778581987 +0200
@@ -55,7 +55,7 @@ static int wiphy_uevent(struct device *d
 }
 #endif
 
-static int wiphy_suspend(struct device *dev, pm_message_t state)
+static int wiphy_suspend(struct device *dev)
 {
 	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
 	int ret = 0;
@@ -90,6 +90,28 @@ static int wiphy_resume(struct device *d
 	return ret;
 }
 
+/* XXX: for WoW, .poweroff and .suspend need to be different */
+static struct dev_pm_ops cfg80211_pm_ops = {
+	.suspend = wiphy_suspend,
+	.resume = wiphy_resume,
+	.freeze = wiphy_suspend,
+	.thaw = wiphy_resume,
+	.poweroff = wiphy_suspend,
+	.restore = wiphy_resume,
+};
+
+static void wiphy_shutdown(struct device *dev)
+{
+	wiphy_suspend(dev);
+}
+
+/*
+ * XXX: This shouldn't be necessary?!
+ */
+struct device_driver wiphy_driver = {
+	.shutdown = wiphy_shutdown,
+};
+
 struct class ieee80211_class = {
 	.name = "ieee80211",
 	.owner = THIS_MODULE,
@@ -98,8 +120,7 @@ struct class ieee80211_class = {
 #ifdef CONFIG_HOTPLUG
 	.dev_uevent = wiphy_uevent,
 #endif
-	.suspend = wiphy_suspend,
-	.resume = wiphy_resume,
+	.pm = &cfg80211_pm_ops,
 };
 
 int wiphy_sysfs_init(void)
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/pci.c	2009-05-15 15:17:09.558578206 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/pci.c	2009-05-15 15:48:20.957708212 +0200
@@ -74,7 +74,36 @@ static bool ath_pci_eeprom_read(struct a
 	return true;
 }
 
+static int ath_pci_start(struct ath_softc *sc)
+{
+	struct pci_dev *pdev = to_pci_dev(sc->dev);
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err)
+		return err;
+
+	/* Enable LED */
+	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,
+			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+
+	return 0;
+}
+
+static void ath_pci_stop(struct ath_softc *sc)
+{
+	struct pci_dev *pdev = to_pci_dev(sc->dev);
+
+	/* put device into low-power state until needed */
+	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+}
+
 static struct ath_bus_ops ath_pci_bus_ops = {
+	.start = ath_pci_start,
+	.stop = ath_pci_stop,
 	.read_cachesize = ath_pci_read_cachesize,
 	.cleanup = ath_pci_cleanup,
 	.eeprom_read = ath_pci_eeprom_read,
@@ -194,6 +223,8 @@ static int ath_pci_probe(struct pci_dev 
 	       ah->hw_version.phyRev,
 	       (unsigned long)mem, pdev->irq);
 
+	ath_pci_stop(sc);
+
 	return 0;
 bad4:
 	ath_detach(sc);
@@ -217,45 +248,6 @@ static void ath_pci_remove(struct pci_de
 	ath_cleanup(sc);
 }
 
-#ifdef CONFIG_PM
-
-static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-
-	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
-
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
-
-	return 0;
-}
-
-static int ath_pci_resume(struct pci_dev *pdev)
-{
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	int err;
-
-	err = pci_enable_device(pdev);
-	if (err)
-		return err;
-	pci_restore_state(pdev);
-
-	/* Enable LED */
-	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,
-			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
-
-	return 0;
-}
-
-#endif /* CONFIG_PM */
-
 MODULE_DEVICE_TABLE(pci, ath_pci_id_table);
 
 static struct pci_driver ath_pci_driver = {
@@ -263,10 +255,6 @@ static struct pci_driver ath_pci_driver 
 	.id_table   = ath_pci_id_table,
 	.probe      = ath_pci_probe,
 	.remove     = ath_pci_remove,
-#ifdef CONFIG_PM
-	.suspend    = ath_pci_suspend,
-	.resume     = ath_pci_resume,
-#endif /* CONFIG_PM */
 };
 
 int ath_pci_init(void)
--- wireless-testing.orig/net/wireless/core.c	2009-05-15 15:17:09.241834437 +0200
+++ wireless-testing/net/wireless/core.c	2009-05-15 15:25:39.963705937 +0200
@@ -271,6 +271,8 @@ struct wiphy *wiphy_new(struct cfg80211_
 
 	device_initialize(&drv->wiphy.dev);
 	drv->wiphy.dev.class = &ieee80211_class;
+	/* only for ->shutdown hook */
+	drv->wiphy.dev.driver = &wiphy_driver;
 	drv->wiphy.dev.platform_data = drv;
 
 	/*
--- wireless-testing.orig/net/wireless/core.h	2009-05-15 15:17:09.320586075 +0200
+++ wireless-testing/net/wireless/core.h	2009-05-15 15:17:10.114957594 +0200
@@ -154,5 +154,6 @@ int cfg80211_leave_ibss(struct cfg80211_
 /* internal helpers */
 int cfg80211_validate_key_settings(struct key_params *params, int key_idx,
 				   const u8 *mac_addr);
+extern struct device_driver wiphy_driver;
 
 #endif /* __NET_WIRELESS_CORE_H */
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/ath9k.h	2009-05-15 15:44:01.006837797 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/ath9k.h	2009-05-15 15:46:22.304582872 +0200
@@ -516,6 +516,8 @@ struct ath_rfkill {
 #define SC_OP_TSF_RESET         BIT(15)
 
 struct ath_bus_ops {
+	int		(*start)(struct ath_softc *sc);
+	void		(*stop)(struct ath_softc *sc);
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
 	void		(*cleanup)(struct ath_softc *sc);
 	bool		(*eeprom_read)(struct ath_hw *ah, u32 off, u16 *data);
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-05-15 15:44:19.261837573 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-05-15 15:47:15.051830998 +0200
@@ -1901,6 +1901,10 @@ static int ath9k_start(struct ieee80211_
 	DPRINTF(sc, ATH_DBG_CONFIG, "Starting driver with "
 		"initial channel: %d MHz\n", curchan->center_freq);
 
+	r = sc->bus_ops->start(sc);
+	if (r)
+		return r;
+
 	mutex_lock(&sc->mutex);
 
 	if (ath9k_wiphy_started(sc)) {
@@ -2105,6 +2109,8 @@ static void ath9k_stop(struct ieee80211_
 
 	mutex_unlock(&sc->mutex);
 
+	sc->bus_ops->stop(sc);
+
 	DPRINTF(sc, ATH_DBG_CONFIG, "Driver halt\n");
 }
 


