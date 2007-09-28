Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbXI1MAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 08:00:09 -0400
Subject: [patch 11a/12] mac80211: add "invalid" interface type
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
In-Reply-To: <1190976518.5021.20.camel@johannes.berg>
References: <20070926131938.575572000@sipsolutions.net>
	 <20070926132136.676468000@sipsolutions.net>
	 <20070927205803.GF7991@tuxdriver.com>
	 <1190976518.5021.20.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 14:01:25 +0200
Message-Id: <1190980885.3907.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since I cannot convince the lazy driver authors (hello Michael)
to stop (ab)using the MGMT interface type internally in their
drivers, this patch introduces a new _INVALID type especially
for their use and changes all affected drivers to use it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/adm8211.c                  |    8 ++++----
 drivers/net/wireless/p54common.c                |    4 ++--
 drivers/net/wireless/p54pci.c                   |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00.h            |    2 +-
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.c |    8 ++++----
 include/net/mac80211.h                          |    3 +++
 net/mac80211/ieee80211.c                        |    4 ++++
 net/mac80211/ieee80211_iface.c                  |    4 ++++
 net/mac80211/rx.c                               |    1 +
 9 files changed, 25 insertions(+), 13 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-09-28 13:05:09.411864682 +0200
+++ wireless-dev/include/net/mac80211.h	2007-09-28 13:20:30.321864682 +0200
@@ -457,6 +457,8 @@ struct ieee80211_conf {
 /**
  * enum ieee80211_if_types - types of 802.11 network interfaces
  *
+ * @IEEE80211_IF_TYPE_INVALID: invalid interface type, not used
+ *	by mac80211 itself
  * @IEEE80211_IF_TYPE_AP: interface in AP mode.
  * @IEEE80211_IF_TYPE_MGMT: special interface for communication with hostap
  *	daemon. Drivers should never see this type.
@@ -468,6 +470,7 @@ struct ieee80211_conf {
  *	will never see this type.
  */
 enum ieee80211_if_types {
+	IEEE80211_IF_TYPE_INVALID,
 	IEEE80211_IF_TYPE_AP,
 	IEEE80211_IF_TYPE_MGMT,
 	IEEE80211_IF_TYPE_STA,
--- wireless-dev.orig/drivers/net/wireless/adm8211.c	2007-09-28 13:06:51.781864682 +0200
+++ wireless-dev/drivers/net/wireless/adm8211.c	2007-09-28 13:07:15.581864682 +0200
@@ -1555,7 +1555,7 @@ static void adm8211_stop(struct ieee8021
 {
 	struct adm8211_priv *priv = dev->priv;
 
-	priv->mode = IEEE80211_IF_TYPE_MGMT;
+	priv->mode = IEEE80211_IF_TYPE_INVALID;
 	priv->nar = 0;
 	ADM8211_CSR_WRITE(NAR, 0);
 	ADM8211_CSR_WRITE(IER, 0);
@@ -1897,7 +1897,7 @@ static int __devinit adm8211_probe(struc
 	priv->tx_power = 0x40;
 	priv->lpf_cutoff = 0xFF;
 	priv->lnags_threshold = 0xFF;
-	priv->mode = IEEE80211_IF_TYPE_MGMT;
+	priv->mode = IEEE80211_IF_TYPE_INVALID;
 
 	/* Power-on issue. EEPROM won't read correctly without */
 	if (pdev->revision >= ADM8211_REV_BA) {
@@ -1992,7 +1992,7 @@ static int adm8211_suspend(struct pci_de
 	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
 	struct adm8211_priv *priv = dev->priv;
 
-	if (priv->mode != IEEE80211_IF_TYPE_MGMT) {
+	if (priv->mode != IEEE80211_IF_TYPE_INVALID) {
 		ieee80211_stop_queues(dev);
 		adm8211_stop(dev);
 	}
@@ -2010,7 +2010,7 @@ static int adm8211_resume(struct pci_dev
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
-	if (priv->mode != IEEE80211_IF_TYPE_MGMT) {
+	if (priv->mode != IEEE80211_IF_TYPE_INVALID) {
 		adm8211_start(dev);
 		ieee80211_start_queues(dev);
 	}
--- wireless-dev.orig/drivers/net/wireless/p54common.c	2007-09-28 13:06:51.541864682 +0200
+++ wireless-dev/drivers/net/wireless/p54common.c	2007-09-28 13:07:15.571864682 +0200
@@ -797,7 +797,7 @@ static void p54_stop(struct ieee80211_hw
 		kfree_skb(skb);
 	}
 	priv->stop(dev);
-	priv->mode = IEEE80211_IF_TYPE_MGMT;
+	priv->mode = IEEE80211_IF_TYPE_INVALID;
 }
 
 static int p54_add_interface(struct ieee80211_hw *dev,
@@ -949,7 +949,7 @@ struct ieee80211_hw *p54_init_common(siz
 		return NULL;
 
 	priv = dev->priv;
-	priv->mode = IEEE80211_IF_TYPE_MGMT;
+	priv->mode = IEEE80211_IF_TYPE_INVALID;
 	skb_queue_head_init(&priv->tx_queue);
 	memcpy(priv->channels, p54_channels, sizeof(p54_channels));
 	memcpy(priv->rates, p54_rates, sizeof(p54_rates));
--- wireless-dev.orig/drivers/net/wireless/p54pci.c	2007-09-28 13:06:51.441864682 +0200
+++ wireless-dev/drivers/net/wireless/p54pci.c	2007-09-28 13:07:15.551864682 +0200
@@ -638,7 +638,7 @@ static int p54p_suspend(struct pci_dev *
 	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
 	struct p54p_priv *priv = dev->priv;
 
-	if (priv->common.mode != IEEE80211_IF_TYPE_MGMT) {
+	if (priv->common.mode != IEEE80211_IF_TYPE_INVALID) {
 		ieee80211_stop_queues(dev);
 		p54p_stop(dev);
 	}
@@ -656,7 +656,7 @@ static int p54p_resume(struct pci_dev *p
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
-	if (priv->common.mode != IEEE80211_IF_TYPE_MGMT) {
+	if (priv->common.mode != IEEE80211_IF_TYPE_INVALID) {
 		p54p_open(dev);
 		ieee80211_start_queues(dev);
 	}
--- wireless-dev.orig/drivers/net/wireless/rt2x00/rt2x00.h	2007-09-28 13:06:51.891864682 +0200
+++ wireless-dev/drivers/net/wireless/rt2x00/rt2x00.h	2007-09-28 13:07:15.581864682 +0200
@@ -297,7 +297,7 @@ struct interface {
 	 * When set to INVALID_INTERFACE, no interface is configured.
 	 */
 	int type;
-#define INVALID_INTERFACE	IEEE80211_IF_TYPE_MGMT
+#define INVALID_INTERFACE	IEEE80211_IF_TYPE_INVALID
 
 	/*
 	 * MAC of the device.
--- wireless-dev.orig/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c	2007-09-28 13:06:51.661864682 +0200
+++ wireless-dev/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c	2007-09-28 13:07:59.331864682 +0200
@@ -710,8 +710,8 @@ static int zd_op_add_interface(struct ie
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 
-	/* NOTE: using IEEE80211_IF_TYPE_MGMT to indicate no mode selected */
-	if (mac->type != IEEE80211_IF_TYPE_MGMT)
+	/* using IEEE80211_IF_TYPE_INVALID to indicate no mode selected */
+	if (mac->type != IEEE80211_IF_TYPE_INVALID)
 		return -1;
 
 	switch (conf->type) {
@@ -732,7 +732,7 @@ static void zd_op_remove_interface(struc
 				    struct ieee80211_if_init_conf *conf)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
-	mac->type = IEEE80211_IF_TYPE_MGMT;
+	mac->type = IEEE80211_IF_TYPE_INVALID;
 }
 
 static int zd_op_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
@@ -864,7 +864,7 @@ struct ieee80211_hw *zd_mac_alloc_hw(str
 	spin_lock_init(&mac->lock);
 	mac->hw = hw;
 
-	mac->type = IEEE80211_IF_TYPE_MGMT;
+	mac->type = IEEE80211_IF_TYPE_INVALID;
 	mac->hwaddr = hw->wiphy->perm_addr;
 
 	memcpy(mac->channels, zd_channels, sizeof(zd_channels));
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-28 13:09:28.011864682 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-28 13:20:30.401864682 +0200
@@ -351,6 +351,10 @@ static int ieee80211_open(struct net_dev
 	case IEEE80211_IF_TYPE_IBSS:
 		/* no special treatment */
 		break;
+	case IEEE80211_IF_TYPE_INVALID:
+		/* cannot happen */
+		WARN_ON(1);
+		break;
 	}
 
 	if (local->open_count == 0) {
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-09-28 13:10:05.841864682 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-09-28 13:20:30.471864682 +0200
@@ -243,6 +243,10 @@ void ieee80211_if_reinit(struct net_devi
 	ieee80211_if_sdata_deinit(sdata);
 
 	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_INVALID:
+		/* cannot happen */
+		WARN_ON(1);
+		break;
 	case IEEE80211_IF_TYPE_MGMT:
 		/* nothing to do */
 		break;
--- wireless-dev.orig/net/mac80211/rx.c	2007-09-28 13:10:33.301864682 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-28 13:20:30.661864682 +0200
@@ -1444,6 +1444,7 @@ static int prepare_for_handlers(struct i
 	case IEEE80211_IF_TYPE_MNTR:
 		/* take everything */
 		break;
+	case IEEE80211_IF_TYPE_INVALID:
 	case IEEE80211_IF_TYPE_MGMT:
 		/* should never get here */
 		WARN_ON(1);


