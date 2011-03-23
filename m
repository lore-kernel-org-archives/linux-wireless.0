Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52739 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab1CWUZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 16:25:00 -0400
Received: by fxm17 with SMTP id 17so7694724fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 13:24:59 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: rearrange some ELP wake_up/sleep calls
Date: Wed, 23 Mar 2011 22:22:15 +0200
Message-Id: <1300911735-27655-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ELP (Extremely/Enhanced Low Power, or something like that ;)) refers to
the powerstate of the 12xx chip, in which very low power is consumed,
and no commands (from the host) can be issued until the chip is woken up.

Wakeup/sleep commands must be protected by a wl->mutex, so it's generally
a good idea to call wakeup/sleep along with the mutex lock/unlock (where
needed). However, in some places the wl12xx driver calls wakeup/sleep in
some "inner" functions. This result in some "nested" wakeup/sleep calls
which might end up letting the chip go to sleep prematurely (e.g. during
event handling).

Fix it by rearranging the elp calls to come along with mutex_lock/unlock.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c |   11 +++++----
 drivers/net/wireless/wl12xx/main.c  |   43 +++++++++++++++++------------------
 drivers/net/wireless/wl12xx/ps.c    |    3 --
 drivers/net/wireless/wl12xx/tx.c    |   22 +++++++----------
 4 files changed, 36 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 1b170c5..d643f1c 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -33,6 +33,7 @@ void wl1271_pspoll_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
 	struct wl1271 *wl;
+	int ret;
 
 	dwork = container_of(work, struct delayed_work, work);
 	wl = container_of(dwork, struct wl1271, pspoll_work);
@@ -55,8 +56,13 @@ void wl1271_pspoll_work(struct work_struct *work)
 	 * delivery failure occurred, and no-one changed state since, so
 	 * we should go back to powersave.
 	 */
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
 	wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE, wl->basic_rate, true);
 
+	wl1271_ps_elp_sleep(wl);
 out:
 	mutex_unlock(&wl->mutex);
 };
@@ -129,11 +135,6 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 
 		/* enable beacon early termination */
 		ret = wl1271_acx_bet_enable(wl, true);
-		if (ret < 0)
-			break;
-
-		/* go to extremely low power mode */
-		wl1271_ps_elp_sleep(wl);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8b3c8d1..11d799c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2650,32 +2650,31 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		conf_tid->ack_policy = CONF_ACK_POLICY_LEGACY;
 		conf_tid->apsd_conf[0] = 0;
 		conf_tid->apsd_conf[1] = 0;
-	} else {
-		ret = wl1271_ps_elp_wakeup(wl);
-		if (ret < 0)
-			goto out;
+		goto out;
+	}
 
-		/*
-		 * the txop is confed in units of 32us by the mac80211,
-		 * we need us
-		 */
-		ret = wl1271_acx_ac_cfg(wl, wl1271_tx_get_queue(queue),
-					params->cw_min, params->cw_max,
-					params->aifs, params->txop << 5);
-		if (ret < 0)
-			goto out_sleep;
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
 
-		ret = wl1271_acx_tid_cfg(wl, wl1271_tx_get_queue(queue),
-					 CONF_CHANNEL_TYPE_EDCF,
-					 wl1271_tx_get_queue(queue),
-					 ps_scheme, CONF_ACK_POLICY_LEGACY,
-					 0, 0);
-		if (ret < 0)
-			goto out_sleep;
+	/*
+	 * the txop is confed in units of 32us by the mac80211,
+	 * we need us
+	 */
+	ret = wl1271_acx_ac_cfg(wl, wl1271_tx_get_queue(queue),
+				params->cw_min, params->cw_max,
+				params->aifs, params->txop << 5);
+	if (ret < 0)
+		goto out_sleep;
+
+	ret = wl1271_acx_tid_cfg(wl, wl1271_tx_get_queue(queue),
+				 CONF_CHANNEL_TYPE_EDCF,
+				 wl1271_tx_get_queue(queue),
+				 ps_scheme, CONF_ACK_POLICY_LEGACY,
+				 0, 0);
 
 out_sleep:
-		wl1271_ps_elp_sleep(wl);
-	}
+	wl1271_ps_elp_sleep(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 971f13e..b8deada 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -149,9 +149,6 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 	case STATION_ACTIVE_MODE:
 	default:
 		wl1271_debug(DEBUG_PSM, "leaving psm");
-		ret = wl1271_ps_elp_wakeup(wl);
-		if (ret < 0)
-			return ret;
 
 		/* disable beacon early termination */
 		ret = wl1271_acx_bet_enable(wl, false);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 5e9ef7d..20644f0 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -454,22 +454,14 @@ static void wl1271_skb_queue_head(struct wl1271 *wl, struct sk_buff *skb)
 void wl1271_tx_work_locked(struct wl1271 *wl)
 {
 	struct sk_buff *skb;
-	bool woken_up = false;
 	u32 buf_offset = 0;
 	bool sent_packets = false;
 	int ret;
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
-		goto out;
+		return;
 
 	while ((skb = wl1271_skb_dequeue(wl))) {
-		if (!woken_up) {
-			ret = wl1271_ps_elp_wakeup(wl);
-			if (ret < 0)
-				goto out_ack;
-			woken_up = true;
-		}
-
 		ret = wl1271_prepare_tx_frame(wl, skb, buf_offset);
 		if (ret == -EAGAIN) {
 			/*
@@ -516,18 +508,22 @@ out_ack:
 
 		wl1271_handle_tx_low_watermark(wl);
 	}
-
-out:
-	if (woken_up)
-		wl1271_ps_elp_sleep(wl);
 }
 
 void wl1271_tx_work(struct work_struct *work)
 {
 	struct wl1271 *wl = container_of(work, struct wl1271, tx_work);
+	int ret;
 
 	mutex_lock(&wl->mutex);
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
 	wl1271_tx_work_locked(wl);
+
+	wl1271_ps_elp_wakeup(wl);
+out:
 	mutex_unlock(&wl->mutex);
 }
 
-- 
1.7.0.4

