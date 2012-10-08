Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49759 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2JHMRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 08:17:25 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1995605bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2012 05:17:24 -0700 (PDT)
Subject: [PATCH] carl9170: fix sleep in softirq context
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Ronald Wahl <ronald.wahl@raritan.com>
Date: Mon, 8 Oct 2012 14:17:07 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201210081417.07712.chunkeey@googlemail.com> (sfid-20121008_141729_572727_2AA7E0FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ronald Wahl <ronald.wahl@raritan.com>

This patch fixes the following bug:

usb 1-1.1: restart device (8)
BUG: sleeping function called from invalid context at drivers/usb/core/urb.c:654
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper
 (usb_poison_urb+0x1c/0xf8)
 (usb_poison_anchored_urbs+0x48/0x78)
 (carl9170_usb_handle_tx_err+0x128/0x150)
 (carl9170_usb_reset+0xc/0x20)
 (carl9170_handle_command_response+0x298/0xea8)
 (carl9170_usb_tasklet+0x68/0x184)
 (tasklet_hi_action+0x84/0xdc)

this only happens if the device is plugged in an USB port,
the driver is loaded but inactive (e.g. the wlan interface
is down). If the device is active everything is fine.

Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Due to a screw up on my part this patch has been stuck
in limbo for more than a year. So please always submit
patches and bugs to the ML directly!

Regards,
Chr 
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 +
 drivers/net/wireless/ath/carl9170/main.c     |   29 +++++++++++++-------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 2aa4a59..e85fcbb 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -304,6 +304,7 @@ struct ar9170 {
 	unsigned long max_queue_stop_timeout[__AR9170_NUM_TXQ];
 	bool needs_full_reset;
+	bool force_usb_reset;
 	atomic_t pending_restarts;
 
 	/* interface mode settings */
 	struct list_head vif_list;
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 67997b3..25a1e2f 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -465,27 +465,26 @@ static void carl9170_restart_work(struct work_struct *work)
 {
 	struct ar9170 *ar = container_of(work, struct ar9170,
 					 restart_work);
-	int err;
+	int err = -EIO;
 
 	ar->usedkeys = 0;
 	ar->filter_state = 0;
 	carl9170_cancel_worker(ar);
 
 	mutex_lock(&ar->mutex);
-	err = carl9170_usb_restart(ar);
-	if (net_ratelimit()) {
-		if (err) {
-			dev_err(&ar->udev->dev, "Failed to restart device "
-				" (%d).\n", err);
-		 } else {
-			dev_info(&ar->udev->dev, "device restarted "
-				 "successfully.\n");
+	if (!ar->force_usb_reset) {
+		err = carl9170_usb_restart(ar);
+		if (net_ratelimit()) {
+			if (err)
+				dev_err(&ar->udev->dev, "Failed to restart device (%d).\n", err);
+			else
+				dev_info(&ar->udev->dev, "device restarted successfully.\n");
 		}
 	}
-
 	carl9170_zap_queues(ar);
 	mutex_unlock(&ar->mutex);
-	if (!err) {
+
+	if (!err && !ar->force_usb_reset) {
 		ar->restart_counter++;
 		atomic_set(&ar->pending_restarts, 0);
 
@@ -526,10 +525,10 @@ void carl9170_restart(struct ar9170 *ar, const enum carl9170_restart_reasons r)
 	if (!ar->registered)
 		return;
 
-	if (IS_ACCEPTING_CMD(ar) && !ar->needs_full_reset)
-		ieee80211_queue_work(ar->hw, &ar->restart_work);
-	else
-		carl9170_usb_reset(ar);
+	if (!IS_ACCEPTING_CMD(ar) || ar->needs_full_reset)
+		ar->force_usb_reset = true;
+
+	ieee80211_queue_work(ar->hw, &ar->restart_work);
 
 	/*
 	 * At this point, the device instance might have vanished/disabled.
-- 
1.7.5.4

