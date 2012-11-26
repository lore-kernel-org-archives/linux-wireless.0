Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60777 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2KZQGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:16 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so3516168wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 08:06:15 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 09/11] wlcore: don't allow access to FW mem when chip is off
Date: Mon, 26 Nov 2012 18:05:48 +0200
Message-Id: <1353945950-3899-10-git-send-email-arik@wizery.com> (sfid-20121126_170622_195662_41F90FC7)
In-Reply-To: <1353945950-3899-1-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Don't allow read/writes to FW memory when the FW is not powered on.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 1cf2cdb..7fbab3c 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -1062,7 +1062,7 @@ static ssize_t dev_mem_read(struct file *file,
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WLCORE_STATE_OFF)) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		ret = -EFAULT;
 		goto skip_read;
 	}
@@ -1149,7 +1149,7 @@ static ssize_t dev_mem_write(struct file *file, const char __user *user_buf,
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WLCORE_STATE_OFF)) {
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		ret = -EFAULT;
 		goto skip_write;
 	}
-- 
1.7.9.5

