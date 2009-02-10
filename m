Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbZBJPhu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 10:37:50 -0500
Subject: [PATCH] ipw2x00: age scan results on resume
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 10:36:17 -0500
Message-Id: <1234280177.3119.23.camel@localhost> (sfid-20090210_163754_199949_E714B079)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Scanned BSS entries are timestamped with jiffies, which doesn't
increment across suspend and hibernate.  On resume, every BSS in the
scan list looks like it was scanned within the last 10 seconds,
irregardless of how long the machine was actually asleep.  Age scan
results on resume with the time spent during sleep so userspace has a
clue how old they really are.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
This fixes NetworkManager and wpa_supplicant trying to connect to the AP
associated with at suspend/hibernate time, which clearly may not exist
at the location where the machine is waking up.

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 823c2bf..abf897d 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -1692,7 +1692,13 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 	u32 lock;
 	u32 ord_len = sizeof(lock);
 
-	/* Quite if manually disabled. */
+	/* Age scan list entries found before suspend */
+	if (priv->suspend_time) {
+		ieee80211_networks_age(priv->ieee, priv->suspend_time);
+		priv->suspend_time = 0;
+	}
+
+	/* Quiet if manually disabled. */
 	if (priv->status & STATUS_RF_KILL_SW) {
 		IPW_DEBUG_INFO("%s: Radio is disabled by Manual Disable "
 			       "switch\n", priv->net_dev->name);
@@ -6414,6 +6420,9 @@ static int ipw2100_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	pci_disable_device(pci_dev);
 	pci_set_power_state(pci_dev, PCI_D3hot);
 
+	if (!priv->suspend_at)
+		priv->suspend_at = get_seconds();
+
 	mutex_unlock(&priv->action_mutex);
 
 	return 0;
@@ -6457,6 +6466,8 @@ static int ipw2100_resume(struct pci_dev *pci_dev)
 	 * the queue of needed */
 	netif_device_attach(dev);
 
+	priv->suspend_time = get_seconds() - priv->suspend_at;
+
 	/* Bring the device back up */
 	if (!(priv->status & STATUS_RF_KILL_SW))
 		ipw2100_up(priv, 0);
diff --git a/drivers/net/wireless/ipw2x00/ipw2100.h b/drivers/net/wireless/ipw2x00/ipw2100.h
index bbf1ddc..430534b 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.h
+++ b/drivers/net/wireless/ipw2x00/ipw2100.h
@@ -591,6 +591,10 @@ struct ipw2100_priv {
 
 	int user_requested_scan;
 
+	/* Track time in suspend */
+	unsigned long suspend_at;
+	unsigned long suspend_time;
+
 	u32 interrupts;
 	int tx_interrupts;
 	int rx_interrupts;
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 0420d3d..74e2ea3 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11224,6 +11224,12 @@ static int ipw_up(struct ipw_priv *priv)
 {
 	int rc, i, j;
 
+	/* Age scan list entries found before suspend */
+	if (priv->suspend_time) {
+		ieee80211_networks_age(priv->ieee, priv->suspend_time);
+		priv->suspend_time = 0;
+	}
+
 	if (priv->status & STATUS_EXIT_PENDING)
 		return -EIO;
 
@@ -11824,6 +11830,9 @@ static int ipw_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 
+	if (!priv->suspend_at)
+		priv->suspend_at = get_seconds();
+
 	return 0;
 }
 
@@ -11859,6 +11868,8 @@ static int ipw_pci_resume(struct pci_dev *pdev)
 	 * the queue of needed */
 	netif_device_attach(dev);
 
+	priv->suspend_time = get_seconds() - priv->suspend_at;
+
 	/* Bring the device back up */
 	queue_work(priv->workqueue, &priv->up);
 
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.h b/drivers/net/wireless/ipw2x00/ipw2200.h
index 277b274..7d88c75 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/ipw2x00/ipw2200.h
@@ -1346,6 +1346,10 @@ struct ipw_priv {
 
 	s8 tx_power;
 
+	/* Track time in suspend */
+	unsigned long suspend_at;
+	unsigned long suspend_time;
+
 #ifdef CONFIG_PM
 	u32 pm_state[16];
 #endif
diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index a2f5616..da27d40 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -105,6 +105,23 @@ static inline void ieee80211_networks_free(struct ieee80211_device *ieee)
 	ieee->networks = NULL;
 }
 
+void ieee80211_networks_age(struct ieee80211_device *ieee,
+                            unsigned long age_secs)
+{
+	struct list_head *element, *safe;
+	struct ieee80211_network *network = NULL;
+	unsigned long flags;
+	unsigned long age_jiffies = msecs_to_jiffies(age_secs * MSEC_PER_SEC);
+
+	spin_lock_irqsave(&ieee->lock, flags);
+	list_for_each_safe(element, safe, &ieee->network_list) {
+		network = list_entry(element, struct ieee80211_network, list);
+		network->last_scanned += age_jiffies;
+	}
+	spin_unlock_irqrestore(&ieee->lock, flags);
+}
+EXPORT_SYMBOL(ieee80211_networks_age);
+
 static void ieee80211_networks_initialize(struct ieee80211_device *ieee)
 {
 	int i;
diff --git a/include/net/ieee80211.h b/include/net/ieee80211.h
index adb7cf3..7515fad 100644
--- a/include/net/ieee80211.h
+++ b/include/net/ieee80211.h
@@ -1119,6 +1119,9 @@ static inline int ieee80211_is_cck_rate(u8 rate)
 extern void free_ieee80211(struct net_device *dev);
 extern struct net_device *alloc_ieee80211(int sizeof_priv);
 
+extern void ieee80211_networks_age(struct ieee80211_device *ieee,
+				   unsigned long age_secs);
+
 extern int ieee80211_set_encryption(struct ieee80211_device *ieee);
 
 /* ieee80211_tx.c */

