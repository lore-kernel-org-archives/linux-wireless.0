Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:30615 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756230AbXIRVnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 17:43:49 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 3/3] adm8211: Adapt to filter configuration API
Date: Tue, 18 Sep 2007 17:42:33 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Message-Id: <200709181742.33948.flamingice@sourmilk.net>
In-Reply-To: <20070918213833.8850.90828.stgit@magic.sourmilk.net>
References: <20070918213833.8850.90828.stgit@magic.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This makes adm8211 use the new filter configuration API in mac80211.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/adm8211.c |  144 ++++++++++++++++++++++------------------
 drivers/net/wireless/adm8211.h |    1 
 2 files changed, 78 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index eec01fc..26be254 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -281,49 +281,6 @@ static int adm8211_get_stats(struct ieee80211_hw *dev,
 	return 0;
 }
 
-static void adm8211_set_rx_mode(struct ieee80211_hw *dev,
-				unsigned short flags, int mc_count)
-{
-	struct adm8211_priv *priv = dev->priv;
-	unsigned int bit_nr;
-	u32 mc_filter[2];
-	struct dev_mc_list *mclist;
-	void *tmp;
-
-	if (flags & IFF_PROMISC) {
-		priv->nar |= ADM8211_NAR_PR;
-		priv->nar &= ~ADM8211_NAR_MM;
-		mc_filter[1] = mc_filter[0] = ~0;
-	} else if ((flags & IFF_ALLMULTI) || (mc_count > -1)) {
-		priv->nar &= ~ADM8211_NAR_PR;
-		priv->nar |= ADM8211_NAR_MM;
-		mc_filter[1] = mc_filter[0] = ~0;
-	} else {
-		priv->nar &= ~(ADM8211_NAR_MM | ADM8211_NAR_PR);
-		mc_filter[1] = mc_filter[0] = 0;
-		mclist = NULL;
-		while ((mclist = ieee80211_get_mc_list_item(dev, mclist, &tmp))) {
-			bit_nr = ether_crc(ETH_ALEN, mclist->dmi_addr) >> 26;
-
-			bit_nr &= 0x3F;
-			mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
-		}
-	}
-
-	ADM8211_IDLE_RX();
-
-	ADM8211_CSR_WRITE(MAR0, mc_filter[0]);
-	ADM8211_CSR_WRITE(MAR1, mc_filter[1]);
-	ADM8211_CSR_READ(NAR);
-
-	if (flags & IFF_PROMISC)
-		dev->flags |= IEEE80211_HW_RX_INCLUDES_FCS;
-	else
-		dev->flags &= ~IEEE80211_HW_RX_INCLUDES_FCS;
-
-	ADM8211_RESTORE();
-}
-
 static int adm8211_get_tx_stats(struct ieee80211_hw *dev,
 				struct ieee80211_tx_queue_stats *stats)
 {
@@ -1254,13 +1211,6 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
 
 	/* Clear the missed-packet counter. */
 	ADM8211_CSR_READ(LPC);
-
-	if (!priv->mac_addr)
-		return;
-
-	/* set mac address */
-	ADM8211_CSR_WRITE(PAR0, *(u32 *)priv->mac_addr);
-	ADM8211_CSR_WRITE(PAR1, *(u16 *)&priv->mac_addr[4]);
 }
 
 static int adm8211_hw_reset(struct ieee80211_hw *dev)
@@ -1334,7 +1284,7 @@ static void adm8211_set_interval(struct ieee80211_hw *dev,
 	ADM8211_CSR_WRITE(BPLI, reg);
 }
 
-static void adm8211_set_bssid(struct ieee80211_hw *dev, u8 *bssid)
+static void adm8211_set_bssid(struct ieee80211_hw *dev, const u8 *bssid)
 {
 	struct adm8211_priv *priv = dev->priv;
 	u32 reg;
@@ -1395,24 +1345,87 @@ static int adm8211_config_interface(struct ieee80211_hw *dev, int if_id,
 	return 0;
 }
 
+static void adm8211_configure_filter(struct ieee80211_hw *dev,
+				     unsigned int changed_flags,
+				     unsigned int *total_flags,
+				     int mc_count, struct dev_mc_list *mclist)
+{
+	static const u8 bcast[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
+	struct adm8211_priv *priv = dev->priv;
+	unsigned int bit_nr, new_flags;
+	u32 mc_filter[2];
+	int i;
+
+	new_flags = 0;
+
+	if (*total_flags & FIF_PROMISC_IN_BSS) {
+		new_flags |= FIF_PROMISC_IN_BSS;
+		priv->nar |= ADM8211_NAR_PR;
+		priv->nar &= ~ADM8211_NAR_MM;
+		mc_filter[1] = mc_filter[0] = ~0;
+	} else if ((*total_flags & FIF_ALLMULTI) || (mc_count > 32)) {
+		new_flags |= FIF_ALLMULTI;
+		priv->nar &= ~ADM8211_NAR_PR;
+		priv->nar |= ADM8211_NAR_MM;
+		mc_filter[1] = mc_filter[0] = ~0;
+	} else {
+		priv->nar &= ~(ADM8211_NAR_MM | ADM8211_NAR_PR);
+		mc_filter[1] = mc_filter[0] = 0;
+		for (i = 0; i < mc_count; i++) {
+			if (!mclist)
+				break;
+			bit_nr = ether_crc(ETH_ALEN, mclist->dmi_addr) >> 26;
+
+			bit_nr &= 0x3F;
+			mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
+			mclist = mclist->next;
+		}
+	}
+
+	ADM8211_IDLE_RX();
+
+	ADM8211_CSR_WRITE(MAR0, mc_filter[0]);
+	ADM8211_CSR_WRITE(MAR1, mc_filter[1]);
+	ADM8211_CSR_READ(NAR);
+
+	if (priv->nar & ADM8211_NAR_PR)
+		dev->flags |= IEEE80211_HW_RX_INCLUDES_FCS;
+	else
+		dev->flags &= ~IEEE80211_HW_RX_INCLUDES_FCS;
+
+	if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
+		adm8211_set_bssid(dev, bcast);
+	else
+		adm8211_set_bssid(dev, priv->bssid);
+
+	ADM8211_RESTORE();
+
+	*total_flags = new_flags;
+}
+
 static int adm8211_add_interface(struct ieee80211_hw *dev,
 				 struct ieee80211_if_init_conf *conf)
 {
 	struct adm8211_priv *priv = dev->priv;
-	/* NOTE: using IEEE80211_IF_TYPE_MGMT to indicate no mode selected */
-	if (priv->mode != IEEE80211_IF_TYPE_MGMT)
-		return -1;
+	if (priv->mode != IEEE80211_IF_TYPE_MNTR)
+		return -EOPNOTSUPP;
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_MNTR:
 		priv->mode = conf->type;
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
-	priv->mac_addr = conf->mac_addr;
+	ADM8211_IDLE();
+
+	ADM8211_CSR_WRITE(PAR0, *(u32 *)conf->mac_addr);
+	ADM8211_CSR_WRITE(PAR1, *(u16 *)(conf->mac_addr + 4));
+
+	adm8211_update_mode(dev);
+
+	ADM8211_RESTORE();
 
 	return 0;
 }
@@ -1421,7 +1434,7 @@ static void adm8211_remove_interface(struct ieee80211_hw *dev,
 				     struct ieee80211_if_init_conf *conf)
 {
 	struct adm8211_priv *priv = dev->priv;
-	priv->mode = IEEE80211_IF_TYPE_MGMT;
+	priv->mode = IEEE80211_IF_TYPE_MNTR;
 }
 
 static int adm8211_init_rings(struct ieee80211_hw *dev)
@@ -1505,7 +1518,7 @@ static void adm8211_free_rings(struct ieee80211_hw *dev)
 	}
 }
 
-static int adm8211_open(struct ieee80211_hw *dev)
+static int adm8211_start(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
 	int retval;
@@ -1550,7 +1563,7 @@ fail:
 	return retval;
 }
 
-static int adm8211_stop(struct ieee80211_hw *dev)
+static void adm8211_stop(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
 
@@ -1562,7 +1575,6 @@ static int adm8211_stop(struct ieee80211_hw *dev)
 	free_irq(priv->pdev->irq, dev);
 
 	adm8211_free_rings(dev);
-	return 0;
 }
 
 static void adm8211_calc_durations(int *dur, int *plcp, size_t payload_len, int len,
@@ -1765,13 +1777,13 @@ static int adm8211_alloc_rings(struct ieee80211_hw *dev)
 
 static const struct ieee80211_ops adm8211_ops = {
 	.tx			= adm8211_tx,
-	.open			= adm8211_open,
+	.start			= adm8211_start,
 	.stop			= adm8211_stop,
 	.add_interface		= adm8211_add_interface,
 	.remove_interface	= adm8211_remove_interface,
 	.config			= adm8211_config,
 	.config_interface	= adm8211_config_interface,
-	.set_multicast_list	= adm8211_set_rx_mode,
+	.configure_filter	= adm8211_configure_filter,
 	.get_stats		= adm8211_get_stats,
 	.get_tx_stats		= adm8211_get_tx_stats,
 	.get_tsf		= adm8211_get_tsft
@@ -1904,7 +1916,7 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 	priv->tx_power = 0x40;
 	priv->lpf_cutoff = 0xFF;
 	priv->lnags_threshold = 0xFF;
-	priv->mode = IEEE80211_IF_TYPE_MGMT;
+	priv->mode = IEEE80211_IF_TYPE_MNTR;
 
 	/* Power-on issue. EEPROM won't read correctly without */
 	if (priv->revid >= ADM8211_REV_BA) {
@@ -1999,7 +2011,7 @@ static int adm8211_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
 	struct adm8211_priv *priv = dev->priv;
 
-	if (priv->mode != IEEE80211_IF_TYPE_MGMT) {
+	if (priv->mode != IEEE80211_IF_TYPE_MNTR) {
 		ieee80211_stop_queues(dev);
 		adm8211_stop(dev);
 	}
@@ -2017,8 +2029,8 @@ static int adm8211_resume(struct pci_dev *pdev)
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
-	if (priv->mode != IEEE80211_IF_TYPE_MGMT) {
-		adm8211_open(dev);
+	if (priv->mode != IEEE80211_IF_TYPE_MNTR) {
+		adm8211_start(dev);
 		ieee80211_start_queues(dev);
 	}
 
diff --git a/drivers/net/wireless/adm8211.h b/drivers/net/wireless/adm8211.h
index 795d895..5991b17 100644
--- a/drivers/net/wireless/adm8211.h
+++ b/drivers/net/wireless/adm8211.h
@@ -612,7 +612,6 @@ struct adm8211_priv {
 	u8 bssid[ETH_ALEN];
 	u8 ssid[32];
 	size_t ssid_len;
-	u8 *mac_addr;
 
 	u8 soft_rx_crc;
 	u8 retry_limit;

