Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:2089 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932Ab1KLSRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Nov 2011 13:17:11 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] rt2x00: Fix sleep-while-atomic bug in powersaving code.
Date: Sat, 12 Nov 2011 19:10:44 +0100
Message-Id: <1321121444-31528-2-git-send-email-gwingerde@gmail.com> (sfid-20111112_191725_676017_2758EBFF)
In-Reply-To: <1321121444-31528-1-git-send-email-gwingerde@gmail.com>
References: <1321121444-31528-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The generic powersaving code that determines after reception of a frame
whether the device should go back to sleep or whether is could stay
awake was calling rt2x00lib_config directly from RX tasklet context.
On a number of the devices this call can actually sleep, due to having
to confirm that the sleeping commands have been executed successfully.

Fix this by moving the call to rt2x00lib_config to a workqueue call.

This fixes bug https://bugzilla.redhat.com/show_bug.cgi?id=731672

Tested-by: Tomas Trnka <tomastrnka@gmx.com>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: <stable@vger.kernel.org>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c |   22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 2ec5c00..99ff12d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -943,6 +943,7 @@ struct rt2x00_dev {
 	 * Powersaving work
 	 */
 	struct delayed_work autowakeup_work;
+	struct work_struct sleep_work;
 
 	/*
 	 * Data queue arrays for RX, TX, Beacon and ATIM.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e1fb2a8..edd317f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -465,6 +465,23 @@ static u8 *rt2x00lib_find_ie(u8 *data, unsigned int len, u8 ie)
 	return NULL;
 }
 
+static void rt2x00lib_sleep(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, sleep_work);
+
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		return;
+
+	/*
+	 * Check again is powersaving is enabled, to prevent races from delayed
+	 * work execution.
+	 */
+	if (!test_bit(CONFIG_POWERSAVING, &rt2x00dev->flags))
+		rt2x00lib_config(rt2x00dev, &rt2x00dev->hw->conf,
+				 IEEE80211_CONF_CHANGE_PS);
+}
+
 static void rt2x00lib_rxdone_check_ps(struct rt2x00_dev *rt2x00dev,
 				      struct sk_buff *skb,
 				      struct rxdone_entry_desc *rxdesc)
@@ -512,8 +529,7 @@ static void rt2x00lib_rxdone_check_ps(struct rt2x00_dev *rt2x00dev,
 	cam |= (tim_ie->bitmap_ctrl & 0x01);
 
 	if (!cam && !test_bit(CONFIG_POWERSAVING, &rt2x00dev->flags))
-		rt2x00lib_config(rt2x00dev, &rt2x00dev->hw->conf,
-				 IEEE80211_CONF_CHANGE_PS);
+		queue_work(rt2x00dev->workqueue, &rt2x00dev->sleep_work);
 }
 
 static int rt2x00lib_rxdone_read_signal(struct rt2x00_dev *rt2x00dev,
@@ -1141,6 +1157,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 
 	INIT_WORK(&rt2x00dev->intf_work, rt2x00lib_intf_scheduled);
 	INIT_DELAYED_WORK(&rt2x00dev->autowakeup_work, rt2x00lib_autowakeup);
+	INIT_WORK(&rt2x00dev->sleep_work, rt2x00lib_sleep);
 
 	/*
 	 * Let the driver probe the device to detect the capabilities.
@@ -1197,6 +1214,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	 */
 	cancel_work_sync(&rt2x00dev->intf_work);
 	cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
+	cancel_work_sync(&rt2x00dev->sleep_work);
 	if (rt2x00_is_usb(rt2x00dev)) {
 		del_timer_sync(&rt2x00dev->txstatus_timer);
 		cancel_work_sync(&rt2x00dev->rxdone_work);
-- 
1.7.7

