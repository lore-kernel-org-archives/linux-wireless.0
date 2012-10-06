Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64747 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2JFUYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2012 16:24:07 -0400
Received: by mail-wi0-f170.google.com with SMTP id hm2so1888664wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2012 13:24:06 -0700 (PDT)
Message-Id: <c2d07cb672d8aa930feb1d1a37252574e8563baa.1349554197.git.chunkeey@googlemail.com> (sfid-20121006_222413_034814_655B5A1B)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 6 Oct 2012 20:42:54 +0200
Subject: [PATCH] carl9170: handle traps from firmware loader
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the way the driver deals with
command responses and traps which are sent through
the special interrupt input endpoint 3.

While the carl9170 firmware does not use this
endpoint for command responses or traps, the
firmware loader on the device does. It uses it
to notify the host about 'watchdog triggered'
in case the firmware/hardware has crashed.

Note:
Even without this patch, the driver is still
able to detect the mishap and reset the device.
But previously it did that because the trap
event caused an out-of-order message sequence
number error, which also triggered a reset.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/rx.c  |    6 +++---
 drivers/net/wireless/ath/carl9170/usb.c |    7 +++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index a0b7230..9cd93f1 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -164,9 +164,6 @@ void carl9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
 	struct carl9170_rsp *cmd = buf;
 	struct ieee80211_vif *vif;
 
-	if (carl9170_check_sequence(ar, cmd->hdr.seq))
-		return;
-
 	if ((cmd->hdr.cmd & CARL9170_RSP_FLAG) != CARL9170_RSP_FLAG) {
 		if (!(cmd->hdr.cmd & CARL9170_CMD_ASYNC_FLAG))
 			carl9170_cmd_callback(ar, len, buf);
@@ -820,6 +817,9 @@ static void carl9170_rx_untie_cmds(struct ar9170 *ar, const u8 *respbuf,
 		if (unlikely(i > resplen))
 			break;
 
+		if (carl9170_check_sequence(ar, cmd->hdr.seq))
+			break;
+
 		carl9170_handle_command_response(ar, cmd, cmd->hdr.len + 4);
 	}
 
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 888152c..307bc0d 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -295,6 +295,13 @@ static void carl9170_usb_rx_irq_complete(struct urb *urb)
 		goto resubmit;
 	}
 
+	/*
+	 * While the carl9170 firmware does not use this EP, the
+	 * firmware loader in the EEPROM unfortunately does.
+	 * Therefore we need to be ready to handle out-of-band
+	 * responses and traps in case the firmware crashed and
+	 * the loader took over again.
+	 */
 	carl9170_handle_command_response(ar, urb->transfer_buffer,
 					 urb->actual_length);
 
-- 
1.7.10.4

