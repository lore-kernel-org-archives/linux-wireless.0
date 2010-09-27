Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:55997 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab0I0IiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:10 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8bvwJ023998
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:38:07 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 03/25] wl1271: Add trigger to net_device oper_state to change BT coex priority
Date: Mon, 27 Sep 2010 11:37:27 +0300
Message-Id: <1285576669-8070-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add a trigger to net_device changes to monitor for oper_state changes in order
to be able to inform the firmware when association is fully complete (including
the EAP negotiation.)

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   69 +++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 4134f44..1098d16 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -350,6 +350,7 @@ struct wl1271 {
 #define WL1271_FLAG_IDLE              (10)
 #define WL1271_FLAG_IDLE_REQUESTED    (11)
 #define WL1271_FLAG_PSPOLL_FAILURE    (12)
+#define WL1271_FLAG_STA_STATE_SENT    (13)
 	unsigned long flags;
 
 	struct wl1271_partition_set part;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 776cd7c..45d4ce3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -277,6 +277,67 @@ static struct platform_device wl1271_device = {
 
 static LIST_HEAD(wl_list);
 
+static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
+			     void *arg)
+{
+	struct net_device *dev = arg;
+	struct wireless_dev *wdev;
+	struct wiphy *wiphy;
+	struct ieee80211_hw *hw;
+	struct wl1271 *wl;
+	struct wl1271 *wl_temp;
+	int ret = 0;
+
+	/* Check that this notification is for us. */
+	if (what != NETDEV_CHANGE)
+		return NOTIFY_DONE;
+
+	wdev = dev->ieee80211_ptr;
+	if (wdev == NULL)
+		return NOTIFY_DONE;
+
+	wiphy = wdev->wiphy;
+	if (wiphy == NULL)
+		return NOTIFY_DONE;
+
+	hw = wiphy_priv(wiphy);
+	if (hw == NULL)
+		return NOTIFY_DONE;
+
+	wl_temp = hw->priv;
+	list_for_each_entry(wl, &wl_list, list) {
+		if (wl == wl_temp)
+			break;
+	}
+	if (wl != wl_temp)
+		return NOTIFY_DONE;
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
+	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	if ((dev->operstate == IF_OPER_UP) &&
+	    !test_and_set_bit(WL1271_FLAG_STA_STATE_SENT, &wl->flags)) {
+		wl1271_cmd_set_sta_state(wl);
+		wl1271_info("Association completed.");
+	}
+
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return NOTIFY_OK;
+}
+
 static void wl1271_conf_init(struct wl1271 *wl)
 {
 
@@ -814,6 +875,10 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
+static struct notifier_block wl1271_dev_notifier = {
+	.notifier_call = wl1271_dev_notify,
+};
+
 static int wl1271_op_start(struct ieee80211_hw *hw)
 {
 	wl1271_debug(DEBUG_MAC80211, "mac80211 start");
@@ -1783,6 +1848,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			}
 		} else {
 			/* use defaults when not associated */
+			clear_bit(WL1271_FLAG_STA_STATE_SENT, &wl->flags);
 			clear_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 			wl->aid = 0;
 
@@ -2307,6 +2373,8 @@ int wl1271_register_hw(struct wl1271 *wl)
 
 	wl->mac80211_registered = true;
 
+	register_netdevice_notifier(&wl1271_dev_notifier);
+
 	wl1271_notice("loaded");
 
 	return 0;
@@ -2315,6 +2383,7 @@ EXPORT_SYMBOL_GPL(wl1271_register_hw);
 
 void wl1271_unregister_hw(struct wl1271 *wl)
 {
+	unregister_netdevice_notifier(&wl1271_dev_notifier);
 	ieee80211_unregister_hw(wl->hw);
 	wl->mac80211_registered = false;
 
-- 
1.6.3.3

