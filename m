Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52282 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaJTMen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 08:34:43 -0400
Received: by mail-lb0-f169.google.com with SMTP id 10so3800247lbg.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 05:34:42 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/3] ath10k: expose hw restart via debugfs
Date: Mon, 20 Oct 2014 14:22:37 +0200
Message-Id: <1413807758-30249-3-git-send-email-michal.kazior@tieto.com> (sfid-20141020_143448_565313_EE1C5992)
In-Reply-To: <1413807758-30249-1-git-send-email-michal.kazior@tieto.com>
References: <1413807758-30249-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Until now it was possible to simulate soft and
hard fw crashes but it wasn't possible to trigger
an immediately hw restart itself (without the fw
crash).

This can be useful when stress testing hw
restarting stability, e.g. during heavy tx/rx
traffic.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * s/request/hw-restart/ [Kalle]

 drivers/net/wireless/ath/ath10k/debug.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 0d94feb..3bc526b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -694,7 +694,8 @@ static ssize_t ath10k_read_simulate_fw_crash(struct file *file,
 		"To simulate firmware crash write one of the keywords to this file:\n"
 		"`soft` - this will send WMI_FORCE_FW_HANG_ASSERT to firmware if FW supports that command.\n"
 		"`hard` - this will send to firmware command with illegal parameters causing firmware crash.\n"
-		"`assert` - this will send special illegal parameter to firmware to cause assert failure and crash.\n";
+		"`assert` - this will send special illegal parameter to firmware to cause assert failure and crash.\n"
+		"`hw-restart` - this will simply queue hw restart without fw/hw actually crashing.\n";
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 }
@@ -747,6 +748,10 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 	} else if (!strcmp(buf, "assert")) {
 		ath10k_info(ar, "simulating firmware assert crash\n");
 		ret = ath10k_debug_fw_assert(ar);
+	} else if (!strcmp(buf, "hw-restart")) {
+		ath10k_info(ar, "user requested hw restart\n");
+		queue_work(ar->workqueue, &ar->restart_work);
+		ret = 0;
 	} else {
 		ret = -EINVAL;
 		goto exit;
-- 
1.8.5.3

