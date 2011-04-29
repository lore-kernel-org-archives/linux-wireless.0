Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:37809 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391Ab1D2UBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 16:01:10 -0400
Received: by mail-ey0-f180.google.com with SMTP id 24so1735324eyg.11
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 13:01:05 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: eliad@wizery.com
Subject: [PATCH] wl12xx: strict_stroul introduced converted to kstrtoul
Date: Fri, 29 Apr 2011 23:00:57 +0300
Message-Id: <1304107257-23215-1-git-send-email-coelho@ti.com> (sfid-20110429_220114_153513_8B84B7DE)
In-Reply-To: <1303028447-16264-1-git-send-email-eliad@wizery.com>
References: <1303028447-16264-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One new patch applied added a couple of new strict_strtoul calls.
Converted those to kstroul().

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 88c6efe..b17cff6 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -321,7 +321,7 @@ static ssize_t dtim_interval_write(struct file *file,
 		return -EFAULT;
 	buf[len] = '\0';
 
-	ret = strict_strtoul(buf, 0, &value);
+	ret = kstrtoul(buf, 0, &value);
 	if (ret < 0) {
 		wl1271_warning("illegal value for dtim_interval");
 		return -EINVAL;
@@ -386,7 +386,7 @@ static ssize_t beacon_interval_write(struct file *file,
 		return -EFAULT;
 	buf[len] = '\0';
 
-	ret = strict_strtoul(buf, 0, &value);
+	ret = kstrtoul(buf, 0, &value);
 	if (ret < 0) {
 		wl1271_warning("illegal value for beacon_interval");
 		return -EINVAL;
-- 
1.7.1

