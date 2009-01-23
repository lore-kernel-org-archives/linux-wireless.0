Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:42095 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbZAWQEQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:04:16 -0500
Received: by mail-ew0-f20.google.com with SMTP id 13so3698997ewy.13
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 08:04:15 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 3/3] rt2x00: Simplify suspend/resume handling
Date: Fri, 23 Jan 2009 17:04:05 +0100
Cc: rt2400-devel@lists.sourceforge.net,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200901231703.06609.IvDoorn@gmail.com> <200901231703.24523.IvDoorn@gmail.com>
In-Reply-To: <200901231703.24523.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901231704.05404.IvDoorn@gmail.com> (sfid-20090123_170420_873251_53C53DEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With mac80211 handling all open interfaces during
suspend and resume we can simplify suspend/resume
within rt2x00lib.

The only thing rt2x00 needs to do is free up memory
during suspend and bring back the minimal required
components during resume.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 -
 drivers/net/wireless/rt2x00/rt2x00dev.c |   93 ++-----------------------------
 2 files changed, 5 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d39e834..bd03751 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -575,7 +575,6 @@ enum rt2x00_flags {
 	DEVICE_STATE_REGISTERED_HW,
 	DEVICE_STATE_INITIALIZED,
 	DEVICE_STATE_STARTED,
-	DEVICE_STATE_STARTED_SUSPEND,
 	DEVICE_STATE_ENABLED_RADIO,
 	DEVICE_STATE_DISABLED_RADIO_HW,
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index cd44475..e1b4054 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -881,23 +881,17 @@ EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
 #ifdef CONFIG_PM
 int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
 {
-	int retval;
-
 	NOTICE(rt2x00dev, "Going to sleep.\n");
 
 	/*
-	 * Only continue if mac80211 has open interfaces.
+	 * Prevent mac80211 from accessing driver while suspended.
 	 */
-	if (!test_and_clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
-	    !test_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags))
-		goto exit;
-
-	set_bit(DEVICE_STATE_STARTED_SUSPEND, &rt2x00dev->flags);
+	if (!test_and_clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		return 0;
 
 	/*
-	 * Disable radio.
+	 * Cleanup as much as possible.
 	 */
-	rt2x00lib_stop(rt2x00dev);
 	rt2x00lib_uninitialize(rt2x00dev);
 
 	/*
@@ -906,7 +900,6 @@ int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
 	rt2x00leds_suspend(rt2x00dev);
 	rt2x00debug_deregister(rt2x00dev);
 
-exit:
 	/*
 	 * Set device mode to sleep for power management,
 	 * on some hardware this call seems to consistently fail.
@@ -918,8 +911,7 @@ exit:
 	 * the radio and the other components already disabled the
 	 * device is as good as disabled.
 	 */
-	retval = rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_SLEEP);
-	if (retval)
+	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_SLEEP))
 		WARNING(rt2x00dev, "Device failed to enter sleep state, "
 			"continue suspending.\n");
 
@@ -927,34 +919,8 @@ exit:
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_suspend);
 
-static void rt2x00lib_resume_intf(void *data, u8 *mac,
-				  struct ieee80211_vif *vif)
-{
-	struct rt2x00_dev *rt2x00dev = data;
-	struct rt2x00_intf *intf = vif_to_intf(vif);
-
-	spin_lock(&intf->lock);
-
-	rt2x00lib_config_intf(rt2x00dev, intf,
-			      vif->type, intf->mac, intf->bssid);
-
-
-	/*
-	 * AP, Ad-hoc, and Mesh Point mode require a new beacon update.
-	 */
-	if (vif->type == NL80211_IFTYPE_AP ||
-	    vif->type == NL80211_IFTYPE_ADHOC ||
-	    vif->type == NL80211_IFTYPE_MESH_POINT ||
-	    vif->type == NL80211_IFTYPE_WDS)
-		intf->delayed_flags |= DELAYED_UPDATE_BEACON;
-
-	spin_unlock(&intf->lock);
-}
-
 int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 {
-	int retval;
-
 	NOTICE(rt2x00dev, "Waking up.\n");
 
 	/*
@@ -964,60 +930,11 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	rt2x00leds_resume(rt2x00dev);
 
 	/*
-	 * Only continue if mac80211 had open interfaces.
-	 */
-	if (!test_and_clear_bit(DEVICE_STATE_STARTED_SUSPEND, &rt2x00dev->flags))
-		return 0;
-
-	/*
-	 * Reinitialize device and all active interfaces.
-	 */
-	retval = rt2x00lib_start(rt2x00dev);
-	if (retval)
-		goto exit;
-
-	/*
-	 * Reconfigure device.
-	 */
-	retval = rt2x00mac_config(rt2x00dev->hw, ~0);
-	if (retval)
-		goto exit;
-
-	/*
-	 * Iterator over each active interface to
-	 * reconfigure the hardware.
-	 */
-	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
-					    rt2x00lib_resume_intf, rt2x00dev);
-
-	/*
 	 * We are ready again to receive requests from mac80211.
 	 */
 	set_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 
-	/*
-	 * It is possible that during that mac80211 has attempted
-	 * to send frames while we were suspending or resuming.
-	 * In that case we have disabled the TX queue and should
-	 * now enable it again
-	 */
-	ieee80211_wake_queues(rt2x00dev->hw);
-
-	/*
-	 * During interface iteration we might have changed the
-	 * delayed_flags, time to handles the event by calling
-	 * the work handler directly.
-	 */
-	rt2x00lib_intf_scheduled(&rt2x00dev->intf_work);
-
 	return 0;
-
-exit:
-	rt2x00lib_stop(rt2x00dev);
-	rt2x00lib_uninitialize(rt2x00dev);
-	rt2x00debug_deregister(rt2x00dev);
-
-	return retval;
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_resume);
 #endif /* CONFIG_PM */
-- 
1.5.6.1

