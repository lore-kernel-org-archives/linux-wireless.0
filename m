Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41579 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab1EMI5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 04:57:22 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so2644123wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 01:57:22 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 6/6] wl12xx: enter/exit psm on wowlan suspend/resume
Date: Fri, 13 May 2011 11:57:13 +0300
Message-Id: <1305277033-6662-7-git-send-email-eliad@wizery.com> (sfid-20110513_105727_999435_E3FD5C3B)
In-Reply-To: <1305277033-6662-1-git-send-email-eliad@wizery.com>
References: <1305277033-6662-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating as station, enter psm before suspending
the device into wowlan state.

Add a new completion event to signal when psm was entered
successfully.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v1->v2:
	define WL1271_PS_COMPLETE_TIMEOUT

 drivers/net/wireless/wl12xx/event.c  |    7 +++
 drivers/net/wireless/wl12xx/main.c   |   81 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/ps.h     |    2 +
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 4 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index ae69330..21e52ed 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -135,6 +135,13 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 
 		/* enable beacon early termination */
 		ret = wl1271_acx_bet_enable(wl, true);
+		if (ret < 0)
+			break;
+
+		if (wl->ps_compl) {
+			complete(wl->ps_compl);
+			wl->ps_compl = NULL;
+		}
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 308855a..1de0963 100644
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
+			&compl, msecs_to_jiffies(WL1271_PS_COMPLETE_TIMEOUT));
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
diff --git a/drivers/net/wireless/wl12xx/ps.h b/drivers/net/wireless/wl12xx/ps.h
index c41bd0a..25eb9bc 100644
--- a/drivers/net/wireless/wl12xx/ps.h
+++ b/drivers/net/wireless/wl12xx/ps.h
@@ -35,4 +35,6 @@ void wl1271_elp_work(struct work_struct *work);
 void wl1271_ps_link_start(struct wl1271 *wl, u8 hlid, bool clean_queues);
 void wl1271_ps_link_end(struct wl1271 *wl, u8 hlid);
 
+#define WL1271_PS_COMPLETE_TIMEOUT 500
+
 #endif /* __WL1271_PS_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index daf941d..cf08a9d 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -512,6 +512,7 @@ struct wl1271 {
 	unsigned int rx_filter;
 
 	struct completion *elp_compl;
+	struct completion *ps_compl;
 	struct delayed_work elp_work;
 	struct delayed_work pspoll_work;
 
-- 
1.7.0.4

