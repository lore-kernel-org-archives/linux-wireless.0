Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:12666 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161319AbXBUQD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 11:03:28 -0500
Received: by nf-out-0910.google.com with SMTP id o25so242963nfa
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2007 08:03:27 -0800 (PST)
To: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH 2/3] d80211: Split antenna selection into TX and RX antenna
Date: Wed, 21 Feb 2007 17:02:47 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702211702.47410.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let broadcom use the antenna_tx field for hardware configuration.
I did not check if the device is also capable of RX antenna selection,
but current implementation only suggested support for the TX antenna.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
index cdce227..580ea33 100644
--- a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
@@ -2609,7 +2609,7 @@ static int bcm43xx_dev_config(struct ieee80211_hw *hw,
 	int antenna = -1;
 	int err = 0;
 
-	switch (conf->antenna_sel) {
+	switch (conf->antenna_sel_tx) {
 	case 0: /* default/diversity */
 		antenna = BCM43xx_ANTENNA_DEFAULT;
 		break;
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
