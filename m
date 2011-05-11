Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32823 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab1EKQBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:01:05 -0400
Received: by wya21 with SMTP id 21so495830wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 09:01:04 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/7] wl12xx: enter/exit psm on wowlan suspend/resume
Date: Wed, 11 May 2011 11:54:28 +0300
Message-Id: <1305104068-32240-8-git-send-email-eliad@wizery.com> (sfid-20110511_180114_335969_69360F90)
In-Reply-To: <1305104068-32240-1-git-send-email-eliad@wizery.com>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating as station, enter psm before suspending
the device into wowlan state.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   81 ++++++++++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 308855a..b4dd1d9 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1332,6 +1332,79 @@ static struct notifier_block wl1271_dev_notifier = {
 	.notifier_call = wl1271_dev_notify,
 };
 
+static int wl1271_configure_suspend(struct wl1271 *wl)
+{
+	int ret;
+
+	if (wl->bss_type != BSS_TYPE_STA_BSS)
+		return 0;
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out_unlock;
+
+	/* enter psm if needed*/
+	if (!test_bit(WL1271_FLAG_PSM, &wl->flags)) {
+		DECLARE_COMPLETION_ONSTACK(compl);
+
+		wl->ps_compl = &compl;
+		ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
+				   wl->basic_rate, true);
+		if (ret < 0)
+			goto out_sleep;
+
+		/* we must unlock here so we will be able to get events */
+		wl1271_ps_elp_sleep(wl);
+		mutex_unlock(&wl->mutex);
+
+		ret = wait_for_completion_timeout(
+			&compl, msecs_to_jiffies(500));
+		if (ret <= 0) {
+			wl1271_warning("couldn't enter ps mode!");
+			ret = -EBUSY;
+			goto out;
+		}
+
+		/* take mutex again, and wakeup */
+		mutex_lock(&wl->mutex);
+
+		ret = wl1271_ps_elp_wakeup(wl);
+		if (ret < 0)
+			goto out_unlock;
+	}
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+out_unlock:
+	mutex_unlock(&wl->mutex);
+out:
+	return ret;
+
+}
+
+static void wl1271_configure_resume(struct wl1271 *wl)
+{
+	int ret;
+
+	if (wl->bss_type != BSS_TYPE_STA_BSS)
+		return;
+
+	mutex_lock(&wl->mutex);
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	/* exit psm if it wasn't configured */
+	if (!test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags))
+		wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
+				   wl->basic_rate, true);
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static int wl1271_op_suspend(struct ieee80211_hw *hw,
 			    struct cfg80211_wowlan *wow)
 {
@@ -1339,6 +1412,12 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
 	wl->wow_enabled = !!wow;
 	if (wl->wow_enabled) {
+		int ret;
+		ret = wl1271_configure_suspend(wl);
+		if (ret < 0) {
+			wl1271_warning("couldn't prepare device to suspend");
+			return ret;
+		}
 		/* flush any remaining work */
 		wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
 		flush_delayed_work(&wl->scan_complete_work);
@@ -1390,6 +1469,8 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 			wl1271_irq(0, wl);
 			wl1271_enable_interrupts(wl);
 		}
+
+		wl1271_configure_resume(wl);
 	}
 
 	return 0;
-- 
1.7.0.4

