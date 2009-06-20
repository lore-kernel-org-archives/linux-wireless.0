Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZFTR6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 13:58:06 -0400
Date: Sat, 20 Jun 2009 12:58:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43/b43legacy: Fix condition in which radio LED did not
 initialize correctly, and remove 4 compilation warnings
Message-ID: <4a3d2333.IHa7mZz1Wz4zGqpJ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the recent changes in rfkill, the radio LED used by b43/b43legacy
did not always initialize correctly.

Both b43 and b43legacy used the deprecated variable radio_enabled in
struct ieee80211_conf.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 b43/b43.h             |    1 +
 b43/main.c            |    7 +++++--
 b43legacy/b43legacy.h |    1 +
 b43legacy/main.c      |    7 +++++--
 4 files changed, 12 insertions(+), 4 deletions(-)

John,

This patch fixes a bug in 2.6.31, but it is not a severe one, and no bug
report has been filed on it. In addition, four compilation warnings when
building b43 and b43legacy have been fixed. You make the call on whether
it is to be included in 2.6.31.

Larry
---

 b43/b43.h             |    1 +
 b43/main.c            |    7 +++++--
 b43legacy/b43legacy.h |    1 +
 b43legacy/main.c      |    7 +++++--
 4 files changed, 12 insertions(+), 4 deletions(-)

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -3497,8 +3497,8 @@ static int b43_op_config(struct ieee8021
 	if (phy->ops->set_rx_antenna)
 		phy->ops->set_rx_antenna(dev, antenna);
 
-	if (!!conf->radio_enabled != phy->radio_on) {
-		if (conf->radio_enabled) {
+	if (wl->radio_enabled != phy->radio_on) {
+		if (wl->radio_enabled) {
 			b43_software_rfkill(dev, false);
 			b43info(dev->wl, "Radio turned on by software\n");
 			if (!dev->radio_hw_enable) {
@@ -4339,6 +4339,7 @@ static int b43_op_start(struct ieee80211
 	wl->beacon0_uploaded = 0;
 	wl->beacon1_uploaded = 0;
 	wl->beacon_templates_virgin = 1;
+	wl->radio_enabled = 1;
 
 	mutex_lock(&wl->mutex);
 
@@ -4378,6 +4379,7 @@ static void b43_op_stop(struct ieee80211
 	if (b43_status(dev) >= B43_STAT_STARTED)
 		b43_wireless_core_stop(dev);
 	b43_wireless_core_exit(dev);
+	wl->radio_enabled = 0;
 	mutex_unlock(&wl->mutex);
 
 	cancel_work_sync(&(wl->txpower_adjust_work));
@@ -4560,6 +4562,7 @@ static int b43_wireless_core_attach(stru
 		B43_WARN_ON(1);
 
 	dev->phy.gmode = have_2ghz_phy;
+	dev->phy.radio_on = 1;
 	tmp = dev->phy.gmode ? B43_TMSLOW_GMODE : 0;
 	b43_wireless_core_reset(dev, tmp);
 
Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h
+++ wireless-testing/drivers/net/wireless/b43/b43.h
@@ -648,6 +648,7 @@ struct b43_wl {
 	u8 nr_devs;
 
 	bool radiotap_enabled;
+	bool radio_enabled;
 
 	/* The beacon we are currently using (AP or IBSS mode).
 	 * This beacon stuff is protected by the irq_lock. */
Index: wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
@@ -607,6 +607,7 @@ struct b43legacy_wl {
 	u8 nr_devs;
 
 	bool radiotap_enabled;
+	bool radio_enabled;
 
 	/* The beacon we are currently using (AP or IBSS mode).
 	 * This beacon stuff is protected by the irq_lock. */
Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c
@@ -2689,8 +2689,8 @@ static int b43legacy_op_dev_config(struc
 	/* Antennas for RX and management frame TX. */
 	b43legacy_mgmtframe_txantenna(dev, antenna_tx);
 
-	if (!!conf->radio_enabled != phy->radio_on) {
-		if (conf->radio_enabled) {
+	if (wl->radio_enabled != phy->radio_on) {
+		if (wl->radio_enabled) {
 			b43legacy_radio_turn_on(dev);
 			b43legacyinfo(dev->wl, "Radio turned on by software\n");
 			if (!dev->radio_hw_enable)
@@ -3441,6 +3441,7 @@ static int b43legacy_op_start(struct iee
 	wl->beacon0_uploaded = 0;
 	wl->beacon1_uploaded = 0;
 	wl->beacon_templates_virgin = 1;
+	wl->radio_enabled = 1;
 
 	mutex_lock(&wl->mutex);
 
@@ -3479,6 +3480,7 @@ static void b43legacy_op_stop(struct iee
 	if (b43legacy_status(dev) >= B43legacy_STAT_STARTED)
 		b43legacy_wireless_core_stop(dev);
 	b43legacy_wireless_core_exit(dev);
+	wl->radio_enabled = 0;
 	mutex_unlock(&wl->mutex);
 }
 
@@ -3620,6 +3622,7 @@ static int b43legacy_wireless_core_attac
 		have_bphy = 1;
 
 	dev->phy.gmode = (have_gphy || have_bphy);
+	dev->phy.radio_on = 1;
 	tmp = dev->phy.gmode ? B43legacy_TMSLOW_GMODE : 0;
 	b43legacy_wireless_core_reset(dev, tmp);
 
