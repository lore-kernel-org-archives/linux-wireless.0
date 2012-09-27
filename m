Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:53714 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2I0Kip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:45 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Yariv <ido@wizery.com>
Subject: [PATCH 27/31] wlcore: Allow memory access when the FW crashes
Date: Thu, 27 Sep 2012 13:38:05 +0300
Message-Id: <1348742289-6587-28-git-send-email-luca@coelho.fi> (sfid-20120927_123926_509440_3E1E948B)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

When the no_recovery flag is used, the recovery work will not restart
the FW and the state will not be set to 'on'. To enable post-mortem
analysis, allow memory access in the 'restarting' state.

Also, since the FW might not be operational, don't fail the read/write
operations if elp_wakeup fails.

Reported-by: Arkady Miasnikov <a-miasnikov@ti.com>
Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/debugfs.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 3d39784d..c86bb00 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -1064,14 +1064,16 @@ static ssize_t dev_mem_read(struct file *file,
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state != WLCORE_STATE_ON)) {
+	if (unlikely(wl->state == WLCORE_STATE_OFF)) {
 		ret = -EFAULT;
 		goto skip_read;
 	}
 
-	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto skip_read;
+	/*
+	 * Don't fail if elp_wakeup returns an error, so the device's memory
+	 * could be read even if the FW crashed
+	 */
+	wl1271_ps_elp_wakeup(wl);
 
 	/* store current partition and switch partition */
 	memcpy(&old_part, &wl->curr_part, sizeof(old_part));
@@ -1149,14 +1151,16 @@ static ssize_t dev_mem_write(struct file *file, const char __user *user_buf,
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state != WLCORE_STATE_ON)) {
+	if (unlikely(wl->state == WLCORE_STATE_OFF)) {
 		ret = -EFAULT;
 		goto skip_write;
 	}
 
-	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto skip_write;
+	/*
+	 * Don't fail if elp_wakeup returns an error, so the device's memory
+	 * could be read even if the FW crashed
+	 */
+	wl1271_ps_elp_wakeup(wl);
 
 	/* store current partition and switch partition */
 	memcpy(&old_part, &wl->curr_part, sizeof(old_part));
-- 
1.7.10.4

