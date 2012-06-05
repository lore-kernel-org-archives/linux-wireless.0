Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54420 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2FESx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 14:53:29 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <bug-track@fisher-privat.net>,
	b43-dev@lists.infradead.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] b43: do not call ieee80211_unregister_hw if we are not registred
Date: Tue,  5 Jun 2012 13:53:22 -0500
Message-Id: <1338922402-6855-1-git-send-email-seth.forshee@canonical.com> (sfid-20120605_205333_347842_EA78E748)
In-Reply-To: <20120605182410.GA1937@tuxdriver.com>
References: <20120605182410.GA1937@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oleksij Rempel <bug-track@fisher-privat.net>

this patch fixes kernel Oops on "rmmod b43" if firmware was not loaded:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
IP: [<ffffffff8104e988>] drain_workqueue+0x25/0x142
PGD 153ac6067 PUD 153b82067 PMD 0
Oops: 0000 [#1] SMP

Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
Tested-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/b43/b43.h  |    4 ++++
 drivers/net/wireless/b43/main.c |   19 ++++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 67c13af..c06b6cb 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -877,6 +877,10 @@ struct b43_wl {
 	 * from the mac80211 subsystem. */
 	u16 mac80211_initially_registered_queues;
 
+	/* Set this if we call ieee80211_register_hw() and check if we call
+	 * ieee80211_unregister_hw(). */
+	bool hw_registred;
+
 	/* We can only have one operating interface (802.11 core)
 	 * at a time. General information about this interface follows.
 	 */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index e4d6dc2..747079b 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2437,6 +2437,7 @@ start_ieee80211:
 	err = ieee80211_register_hw(wl->hw);
 	if (err)
 		goto err_one_core_detach;
+	wl->hw_registred = true;
 	b43_leds_register(wl->current_dev);
 	goto out;
 
@@ -5283,6 +5284,7 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 
 	hw->queues = modparam_qos ? B43_QOS_QUEUE_NUM : 1;
 	wl->mac80211_initially_registered_queues = hw->queues;
+	wl->hw_registred = false;
 	hw->max_rates = 2;
 	SET_IEEE80211_DEV(hw, dev->dev);
 	if (is_valid_ether_addr(sprom->et1mac))
@@ -5354,12 +5356,15 @@ static void b43_bcma_remove(struct bcma_device *core)
 	 * as the ieee80211 unreg will destroy the workqueue. */
 	cancel_work_sync(&wldev->restart_work);
 
-	/* Restore the queues count before unregistering, because firmware detect
-	 * might have modified it. Restoring is important, so the networking
-	 * stack can properly free resources. */
-	wl->hw->queues = wl->mac80211_initially_registered_queues;
-	b43_leds_stop(wldev);
-	ieee80211_unregister_hw(wl->hw);
+	B43_WARN_ON(!wl);
+	if (wl->current_dev == wldev && wl->hw_registred) {
+		/* Restore the queues count before unregistering, because firmware detect
+		 * might have modified it. Restoring is important, so the networking
+		 * stack can properly free resources. */
+		wl->hw->queues = wl->mac80211_initially_registered_queues;
+		b43_leds_stop(wldev);
+		ieee80211_unregister_hw(wl->hw);
+	}
 
 	b43_one_core_detach(wldev->dev);
 
@@ -5430,7 +5435,7 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 	cancel_work_sync(&wldev->restart_work);
 
 	B43_WARN_ON(!wl);
-	if (wl->current_dev == wldev) {
+	if (wl->current_dev == wldev && wl->hw_registred) {
 		/* Restore the queues count before unregistering, because firmware detect
 		 * might have modified it. Restoring is important, so the networking
 		 * stack can properly free resources. */
-- 
1.7.9.5

