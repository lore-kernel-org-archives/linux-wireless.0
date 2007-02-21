Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:24438 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422702AbXBURHZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 12:07:25 -0500
Received: by nf-out-0910.google.com with SMTP id o25so260439nfa
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2007 09:07:23 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 2/3] d80211: Split antenna selection into TX and RX antenna
Date: Wed, 21 Feb 2007 18:06:44 +0100
Cc: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702211702.47410.IvDoorn@gmail.com> <200702211744.24034.IvDoorn@gmail.com> <200702211751.27245.mb@bu3sch.de>
In-Reply-To: <200702211751.27245.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702211806.44665.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > Nope, this is conf->antenna_sel_rx
> > > ;)
> > 
> > On further inspection not even that. :P
> > The outcome of that switch is stored in the antenna variable, which is used with
> > 
> > 	bcm43xx_mgmtframe_txantenna(dev, antenna);
> > 	bcm43xx_set_rx_antenna(dev, antenna);
> > 
> > So I guess that needs to be fixed to create a switch statement for
> > the RX antenna and one for the TX antenna?
> 
> Ah, yeah. I didn't have the complete code for this in my head. :)
> 
> I'd rather like to have a helper function
> int bcm43xx_antenna_from_ieee80211(u8 antenna)
> which includes the switch statement and use it twice in the
> config callback. Wanna do that?

Fixed. This will make the bcm43xx driver make use of both
RX and TX antenna selection capabilities.

Signed-off-by: Ivo van Doorn<IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
index cdce227..1256549 100644
--- a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
@@ -2606,22 +2606,12 @@ static int bcm43xx_dev_config(struct ieee80211_hw *hw,
 	struct bcm43xx_phy *phy;
 	unsigned long flags;
 	unsigned int new_phymode = 0xFFFF;
-	int antenna = -1;
+	int antenna_tx;
+	int antenna_rx;
 	int err = 0;
 
-	switch (conf->antenna_sel) {
-	case 0: /* default/diversity */
-		antenna = BCM43xx_ANTENNA_DEFAULT;
-		break;
-	case 1: /* Antenna 0 */
-		antenna = BCM43xx_ANTENNA0;
-		break;
-	case 2: /* Antenna 1 */
-		antenna = BCM43xx_ANTENNA1;
-		break;
-	default:
-		assert(0);
-	}
+	antenna_tx = bcm43xx_antenna_from_ieee80211(conf->antenna_sel_tx);
+	antenna_rx = bcm43xx_antenna_from_ieee80211(conf->antenna_sel_rx);
 
 	mutex_lock(&wl->mutex);
 
@@ -2682,8 +2672,8 @@ static int bcm43xx_dev_config(struct ieee80211_hw *hw,
 	}
 
 	/* Antennas for RX and management frame TX. */
-	bcm43xx_mgmtframe_txantenna(dev, antenna);
-	bcm43xx_set_rx_antenna(dev, antenna);
+	bcm43xx_mgmtframe_txantenna(dev, antenna_tx);
+	bcm43xx_set_rx_antenna(dev, antenna_rx);
 
 	/* Update templates for AP mode. */
 	if (bcm43xx_is_mode(wl, IEEE80211_IF_TYPE_AP))
diff --git a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.h b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.h
index e56efc1..bba6606 100644
--- a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.h
+++ b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.h
@@ -110,6 +110,22 @@ int bcm43xx_is_ofdm_rate(int rate)
 }
 
 static inline
+int bcm43xx_antenna_from_ieee80211(u8 antenna)
+{
+	switch (antenna) {
+	case 0: /* default/diversity */
+		return BCM43xx_ANTENNA_DEFAULT;
+	case 1: /* Antenna 0 */
+		return BCM43xx_ANTENNA0;
+	case 2: /* Antenna 1 */
+		return BCM43xx_ANTENNA1;
+	default:
+		assert(0);
+		return -EINVAL;
+	}
+}
+
+static inline
 int bcm43xx_is_hw_radio_enabled(struct bcm43xx_wldev *dev)
 {
 	/* function to return state of hardware enable of radio
diff --git a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_xmit.c b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_xmit.c
index 71cba92..cfc84cd 100644
--- a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_xmit.c
+++ b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_xmit.c
@@ -281,7 +281,7 @@ static void generate_txhdr_fw4(struct bcm43xx_wldev *dev,
 		phy_ctl |= BCM43xx_TX4_PHY_OFDM;
 	if (dev->short_preamble)
 		phy_ctl |= BCM43xx_TX4_PHY_SHORTPRMBL;
-	switch (txctl->antenna_sel) {
+	switch (txctl->antenna_sel_tx) {
 	case 0:
 		phy_ctl |= BCM43xx_TX4_PHY_ANTLAST;
 		break;
