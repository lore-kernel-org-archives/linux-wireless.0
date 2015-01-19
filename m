Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:42125 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbASOfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 09:35:15 -0500
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 68AFF7869D4
	for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 15:35:12 +0100 (CET)
From: Sabrina Dubroca <sd@queasysnail.net>
To: kvalo@codeaurora.org, stefano.brivio@polimi.it
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH] b43: stop leds during suspend
Date: Mon, 19 Jan 2015 15:34:32 +0100
Message-Id: <1421678072-28997-1-git-send-email-sd@queasysnail.net> (sfid-20150119_153521_392213_A233557A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Call b43_leds_stop during suspend to avoid this WARN:

WARNING: CPU: 1 PID: 0 at net/mac80211/util.c:755 ieee80211_can_queue_work.isra.11+0x35/0x50 [mac80211]()
queueing ieee80211 work while going to suspend

 [...]

Call Trace:
 [<c165fb2a>] dump_stack+0x48/0x69
 [<c1052f7b>] warn_slowpath_common+0x8b/0xc0
 [<f9c30225>] ? ieee80211_can_queue_work.isra.11+0x35/0x50 [mac80211]
 [<f9c30225>] ? ieee80211_can_queue_work.isra.11+0x35/0x50 [mac80211]
 [<c1052fe3>] warn_slowpath_fmt+0x33/0x40
 [<f9c30225>] ieee80211_can_queue_work.isra.11+0x35/0x50 [mac80211]
 [<f9c30260>] ieee80211_queue_work+0x20/0x40 [mac80211]
 [<f9f25d78>] b43_led_brightness_set+0x28/0x30 [b43]
 [<c14f3835>] led_timer_function+0xd5/0xe0
 [<c10cb534>] call_timer_fn+0xa4/0x4a0

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/wireless/b43/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 47731cb0d815..58a2e88631fb 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4318,6 +4318,7 @@ redo:
 	mutex_unlock(&wl->mutex);
 	cancel_delayed_work_sync(&dev->periodic_work);
 	cancel_work_sync(&wl->tx_work);
+	b43_leds_stop(dev);
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
 	if (!dev || b43_status(dev) < B43_STAT_STARTED) {
-- 
2.2.2

