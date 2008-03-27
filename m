Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:23604 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760399AbYC0QQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 12:16:29 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1673912nfb.21
        for <linux-wireless@vger.kernel.org>; Thu, 27 Mar 2008 09:16:27 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Ignore set_state(STATE_SLEEP) failure
Date: Thu, 27 Mar 2008 17:15:24 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803271715.25247.IvDoorn@gmail.com> (sfid-20080327_161652_834144_B80766EB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some hardware never seem to accept the "goto sleep" command, since the legacy
drivers don't have suspend and resume handlers the entire code for it was
basically a educated guess (based on the "enable radio" code).
This patch will only print a warning when the "goto sleep" command fails, and
just continues as usual. Perhaps that means the device will not reach a sleep
state and consumes more power then it should, but it is equally possible it
simply needs some seconds longer to sleep. Anyway, by making the command
non-fatal it will not block the rest of the suspend procedure.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, this is a (partial) solution to kernel bugreport:
	[Bug 9428] panic in rt2x00 driver when resuming after hibernate
please push it to both 2.6.25 and 2.6.26 trees.
It should apply safely to the 2.6.25 with a minor fuzz warning only.

 drivers/net/wireless/rt2x00/rt2x00dev.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 62b58a6..50ea7bd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1252,11 +1252,20 @@ int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
 
 exit:
 	/*
-	 * Set device mode to sleep for power management.
+	 * Set device mode to sleep for power management,
+	 * on some hardware this call seems to consistently fail.
+	 * From the specifications it is hard to tell why it fails,
+	 * and if this is a "bad thing".
+	 * Overall it is safe to just ignore the failure and
+	 * continue suspending. The only downside is that the
+	 * device will not be in optimal power save mode, but with
+	 * the radio and the other components already disabled the
+	 * device is as good as disabled.
 	 */
 	retval = rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_SLEEP);
 	if (retval)
-		return retval;
+		WARNING(rt2x00dev, "Device failed to enter sleep state, "
+			"continue suspending.\n");
 
 	return 0;
 }
-- 
1.5.4.4

