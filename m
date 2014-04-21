Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:38395 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaDUIyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 04:54:43 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so3502175eei.14
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 01:54:42 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [wireless-next][PATCH V2 2/2] b43: remove list of IEEE 802.11 devices
Date: Mon, 21 Apr 2014 10:54:29 +0200
Message-Id: <1398070469-23307-1-git-send-email-zajec5@gmail.com> (sfid-20140421_105507_656747_6610748E)
In-Reply-To: <1398018659-17263-2-git-send-email-zajec5@gmail.com>
References: <1398018659-17263-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the first step to remove leftover code.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
As Michael noticed there is much more to remove (e.g. struct b43_wl).
Change commit message to speciify what exactly we remove at this point.
No code changes to V1
---
 drivers/net/wireless/b43/b43.h  |  4 ----
 drivers/net/wireless/b43/main.c | 52 +++++++++++++++--------------------------
 2 files changed, 19 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 54376fd..4113b69 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -915,10 +915,6 @@ struct b43_wl {
 	char rng_name[30 + 1];
 #endif /* CONFIG_B43_HWRNG */
 
-	/* List of all wireless devices on this chip */
-	struct list_head devlist;
-	u8 nr_devs;
-
 	bool radiotap_enabled;
 	bool radio_enabled;
 
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index cf84cf2..07024c6 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3735,40 +3735,35 @@ static int b43_switch_band(struct b43_wl *wl, struct ieee80211_channel *chan)
 {
 	struct b43_wldev *up_dev = NULL;
 	struct b43_wldev *down_dev;
-	struct b43_wldev *d;
 	int err;
 	bool uninitialized_var(gmode);
 	int prev_status;
 
 	/* Find a device and PHY which supports the band. */
-	list_for_each_entry(d, &wl->devlist, list) {
-		switch (chan->band) {
-		case IEEE80211_BAND_5GHZ:
-			if (d->phy.supports_5ghz) {
-				up_dev = d;
-				gmode = false;
-			}
-			break;
-		case IEEE80211_BAND_2GHZ:
-			if (d->phy.supports_2ghz) {
-				up_dev = d;
-				gmode = true;
-			}
-			break;
-		default:
-			B43_WARN_ON(1);
-			return -EINVAL;
+	switch (chan->band) {
+	case IEEE80211_BAND_5GHZ:
+		if (wl->current_dev->phy.supports_5ghz) {
+			up_dev = wl->current_dev;
+			gmode = false;
 		}
-		if (up_dev)
-			break;
+		break;
+	case IEEE80211_BAND_2GHZ:
+		if (wl->current_dev->phy.supports_2ghz) {
+			up_dev = wl->current_dev;
+			gmode = true;
+		}
+		break;
+	default:
+		B43_WARN_ON(1);
+		return -EINVAL;
 	}
+
 	if (!up_dev) {
 		b43err(wl, "Could not find a device for %s-GHz band operation\n",
 		       band_to_string(chan->band));
 		return -ENODEV;
 	}
-	if ((up_dev == wl->current_dev) &&
-	    (!!wl->current_dev->phy.gmode == !!gmode)) {
+	if (!!wl->current_dev->phy.gmode == !!gmode) {
 		/* This device is already running. */
 		return 0;
 	}
@@ -5270,7 +5265,6 @@ static void b43_one_core_detach(struct b43_bus_dev *dev)
 	b43_debugfs_remove_device(wldev);
 	b43_wireless_core_detach(wldev);
 	list_del(&wldev->list);
-	wl->nr_devs--;
 	b43_bus_set_wldev(dev, NULL);
 	kfree(wldev);
 }
@@ -5295,8 +5289,6 @@ static int b43_one_core_attach(struct b43_bus_dev *dev, struct b43_wl *wl)
 	if (err)
 		goto err_kfree_wldev;
 
-	list_add(&wldev->list, &wl->devlist);
-	wl->nr_devs++;
 	b43_bus_set_wldev(dev, wldev);
 	b43_debugfs_add_device(wldev);
 
@@ -5386,7 +5378,6 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 	wl->hw = hw;
 	mutex_init(&wl->mutex);
 	spin_lock_init(&wl->hardirq_lock);
-	INIT_LIST_HEAD(&wl->devlist);
 	INIT_WORK(&wl->beacon_update_trigger, b43_beacon_update_trigger_work);
 	INIT_WORK(&wl->txpower_adjust_work, b43_phy_txpower_adjust_work);
 	INIT_WORK(&wl->tx_work, b43_tx_work);
@@ -5549,13 +5540,8 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 	/* Unregister HW RNG driver */
 	b43_rng_exit(wl);
 
-	if (list_empty(&wl->devlist)) {
-		b43_leds_unregister(wl);
-		/* Last core on the chip unregistered.
-		 * We can destroy common struct b43_wl.
-		 */
-		b43_wireless_exit(dev, wl);
-	}
+	b43_leds_unregister(wl);
+	b43_wireless_exit(dev, wl);
 }
 
 static struct ssb_driver b43_ssb_driver = {
-- 
1.8.4.5

