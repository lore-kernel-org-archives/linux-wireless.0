Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:45177 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030573AbXBURZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 12:25:24 -0500
Received: by nf-out-0910.google.com with SMTP id o25so265574nfa
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2007 09:25:22 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 2/3] d80211: Split antenna selection into TX and RX antenna
Date: Wed, 21 Feb 2007 18:24:44 +0100
Cc: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702211702.47410.IvDoorn@gmail.com> <200702211806.44665.IvDoorn@gmail.com> <200702211819.52114.mb@bu3sch.de>
In-Reply-To: <200702211819.52114.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702211824.45011.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> No, there is no need to inline. Simple static in main.c above
> the config callback, please. :)
> And simply return BCM43xx_ANTENNA_DEFAULT for the default:
> case, so it doesn't break immediately, if someone decides
> to add something to d80211.
>
> ...But we've almost got it :D
> After that you'll get my sign-off.

bcm43xx_antenna_from_ieee80211 is no longer inlined,
and it returns BCM43xx_ANTENNA_DEFAULT by default.

Hopefully I got it this time. :)

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
index cdce227..798427f 100644
--- a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
@@ -2598,6 +2598,20 @@ static int bcm43xx_switch_phymode(struct bcm43xx_wl *wl,
 	return 0;
 }
 
+static int bcm43xx_antenna_from_ieee80211(u8 antenna)
+{
+	switch (antenna) {
+	case 0: /* default/diversity */
+		return BCM43xx_ANTENNA_DEFAULT;
+	case 1: /* Antenna 0 */
+		return BCM43xx_ANTENNA0;
+	case 2: /* Antenna 1 */
+		return BCM43xx_ANTENNA1;
+	default:
+		return BCM43xx_ANTENNA_DEFAULT;
+	}
+}
+
 static int bcm43xx_dev_config(struct ieee80211_hw *hw,
 			      struct ieee80211_conf *conf)
 {
@@ -2606,22 +2620,12 @@ static int bcm43xx_dev_config(struct ieee80211_hw *hw,
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
 
@@ -2682,8 +2686,8 @@ static int bcm43xx_dev_config(struct ieee80211_hw *hw,
 	}
 
 	/* Antennas for RX and management frame TX. */
-	bcm43xx_mgmtframe_txantenna(dev, antenna);
-	bcm43xx_set_rx_antenna(dev, antenna);
+	bcm43xx_mgmtframe_txantenna(dev, antenna_tx);
+	bcm43xx_set_rx_antenna(dev, antenna_rx);
 
 	/* Update templates for AP mode. */
 	if (bcm43xx_is_mode(wl, IEEE80211_IF_TYPE_AP))
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
