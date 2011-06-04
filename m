Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:47909 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490Ab1FDOry (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 10:47:54 -0400
Date: Sat, 4 Jun 2011 16:48:54 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH wireless-2.6 v2] rt2x00: fix rmmod crash
Message-ID: <20110604144854.GA4865@localhost.localdomain> (sfid-20110604_164758_154614_2993826C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid queue and run autowakeup_work when device is not present anymore.
That prevent rmmod and device remove crash introduced by:

commit 1c0bcf89d85cc97a0d9ce4cd909351a81fa4fdde
Author: Ivo van Doorn <ivdoorn@gmail.com>
Date:   Sat Apr 30 17:18:18 2011 +0200

    rt2x00: Add autowake support for USB hardware

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    4 ++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 555180d..b704e5b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -250,7 +250,8 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	if (ieee80211_flags & IEEE80211_CONF_CHANGE_CHANNEL)
 		rt2x00link_reset_tuner(rt2x00dev, false);
 
-	if (test_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags) &&
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
+	    test_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags) &&
 	    (ieee80211_flags & IEEE80211_CONF_CHANGE_PS) &&
 	    (conf->flags & IEEE80211_CONF_PS)) {
 		beacon_diff = (long)jiffies - (long)rt2x00dev->last_beacon;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c018d67..939821b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -146,6 +146,9 @@ static void rt2x00lib_autowakeup(struct work_struct *work)
 	struct rt2x00_dev *rt2x00dev =
 	    container_of(work, struct rt2x00_dev, autowakeup_work.work);
 
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		return;
+
 	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
 		ERROR(rt2x00dev, "Device failed to wakeup.\n");
 	clear_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
@@ -1160,6 +1163,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	 * Stop all work.
 	 */
 	cancel_work_sync(&rt2x00dev->intf_work);
+	cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
 	if (rt2x00_is_usb(rt2x00dev)) {
 		del_timer_sync(&rt2x00dev->txstatus_timer);
 		cancel_work_sync(&rt2x00dev->rxdone_work);
-- 
1.7.4

