Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:59685 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbXLVUzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 15:55:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Only select allowed TX and RX antennas
Date: Sat, 22 Dec 2007 21:54:20 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712222154.20424.mb@bu3sch.de> (sfid-20071222_205514_086048_54224C56)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes antenna selection in b43. It adds a sanity check
for the antenna numbers we get from mac80211.

This patch depends on
[PATCH] ssb: Fix extraction of values from SPROM

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-12-12 19:55:48.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-12-12 19:55:53.000000000 +0100
@@ -2692,8 +2692,36 @@ static int b43_switch_phymode(struct b43
 	return err;
 }
 
-static int b43_antenna_from_ieee80211(u8 antenna)
+/* Check if the use of the antenna that ieee80211 told us to
+ * use is possible. This will fall back to DEFAULT.
+ * "antenna_nr" is the antenna identifier we got from ieee80211. */
+u8 b43_ieee80211_antenna_sanitize(struct b43_wldev *dev,
+				  u8 antenna_nr)
+{
+	u8 antenna_mask;
+
+	if (antenna_nr == 0) {
+		/* Zero means "use default antenna". That's always OK. */
+		return 0;
+	}
+
+	/* Get the mask of available antennas. */
+	if (dev->phy.gmode)
+		antenna_mask = dev->dev->bus->sprom.ant_available_bg;
+	else
+		antenna_mask = dev->dev->bus->sprom.ant_available_a;
+
+	if (!(antenna_mask & (1 << (antenna_nr - 1)))) {
+		/* This antenna is not available. Fall back to default. */
+		return 0;
+	}
+
+	return antenna_nr;
+}
+
+static int b43_antenna_from_ieee80211(struct b43_wldev *dev, u8 antenna)
 {
+	antenna = b43_ieee80211_antenna_sanitize(dev, antenna);
 	switch (antenna) {
 	case 0:		/* default/diversity */
 		return B43_ANTENNA_DEFAULT;
@@ -2713,14 +2741,10 @@ static int b43_op_config(struct ieee8021
 	struct b43_phy *phy;
 	unsigned long flags;
 	unsigned int new_phymode = 0xFFFF;
-	int antenna_tx;
-	int antenna_rx;
+	int antenna;
 	int err = 0;
 	u32 savedirqs;
 
-	antenna_tx = b43_antenna_from_ieee80211(conf->antenna_sel_tx);
-	antenna_rx = b43_antenna_from_ieee80211(conf->antenna_sel_rx);
-
 	mutex_lock(&wl->mutex);
 
 	/* Switch the PHY mode (if necessary). */
@@ -2781,8 +2805,10 @@ static int b43_op_config(struct ieee8021
 	}
 
 	/* Antennas for RX and management frame TX. */
-	b43_mgmtframe_txantenna(dev, antenna_tx);
-	b43_set_rx_antenna(dev, antenna_rx);
+	antenna = b43_antenna_from_ieee80211(dev, conf->antenna_sel_tx);
+	b43_mgmtframe_txantenna(dev, antenna);
+	antenna = b43_antenna_from_ieee80211(dev, conf->antenna_sel_rx);
+	b43_set_rx_antenna(dev, antenna);
 
 	/* Update templates for AP mode. */
 	if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP))
Index: wireless-2.6/drivers/net/wireless/b43/main.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.h	2007-12-12 18:29:32.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.h	2007-12-12 19:55:53.000000000 +0100
@@ -96,6 +96,9 @@ static inline int b43_is_ofdm_rate(int r
 	return !b43_is_cck_rate(rate);
 }
 
+u8 b43_ieee80211_antenna_sanitize(struct b43_wldev *dev,
+				  u8 antenna_nr);
+
 void b43_tsf_read(struct b43_wldev *dev, u64 * tsf);
 void b43_tsf_write(struct b43_wldev *dev, u64 tsf);
 
Index: wireless-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.c	2007-12-12 18:29:32.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/xmit.c	2007-12-12 19:55:53.000000000 +0100
@@ -270,14 +270,15 @@ static void generate_txhdr_fw4(struct b4
 		phy_ctl |= B43_TX4_PHY_OFDM;
 	if (dev->short_preamble)
 		phy_ctl |= B43_TX4_PHY_SHORTPRMBL;
-	switch (txctl->antenna_sel_tx) {
-	case 0:
+
+	switch (b43_ieee80211_antenna_sanitize(dev, txctl->antenna_sel_tx)) {
+	case 0: /* Default */
 		phy_ctl |= B43_TX4_PHY_ANTLAST;
 		break;
-	case 1:
+	case 1: /* Antenna 0 */
 		phy_ctl |= B43_TX4_PHY_ANT0;
 		break;
-	case 2:
+	case 2: /* Antenna 1 */
 		phy_ctl |= B43_TX4_PHY_ANT1;
 		break;
 	default:
