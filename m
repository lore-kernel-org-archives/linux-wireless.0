Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47006 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab2K0GpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:12 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so3808120wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:12 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Ido Yariv <ido@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 03/20] wlcore: Allow memory access when the FW crashes
Date: Tue, 27 Nov 2012 08:44:44 +0200
Message-Id: <1353998701-18171-4-git-send-email-arik@wizery.com> (sfid-20121127_074520_498931_409ED199)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
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
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 78d2eb3..e61fc2b 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -1063,7 +1063,7 @@ static ssize_t dev_mem_read(struct file *file,
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state != WLCORE_STATE_ON)) {
+	if (unlikely(wl->state == WLCORE_STATE_OFF)) {
 		ret = -EFAULT;
 		goto skip_read;
 	}
@@ -1150,7 +1150,7 @@ static ssize_t dev_mem_write(struct file *file, const char __user *user_buf,
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state != WLCORE_STATE_ON)) {
+	if (unlikely(wl->state == WLCORE_STATE_OFF)) {
 		ret = -EFAULT;
 		goto skip_write;
 	}
-- 
1.7.9.5

