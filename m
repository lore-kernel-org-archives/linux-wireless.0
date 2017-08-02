Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:37193 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752442AbdHBR5c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 13:57:32 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, harish.patil@cavium.com,
        manish.chopra@cavium.com, Dept-GELinuxNICDev@cavium.com
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 1/2] wlcore: add const to bin_attribute structure
Date: Wed,  2 Aug 2017 23:27:13 +0530
Message-Id: <1501696634-15765-2-git-send-email-bhumirks@gmail.com> (sfid-20170802_195823_038608_38E600B1)
In-Reply-To: <1501696634-15765-1-git-send-email-bhumirks@gmail.com>
References: <1501696634-15765-1-git-send-email-bhumirks@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add const to bin_attribute structure as it is only passed to the
functions sysfs_{remove/create}_bin_file. The corresponding arguments
are of type const, so declare the structure to be const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/net/wireless/ti/wlcore/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/sysfs.c b/drivers/net/wireless/ti/wlcore/sysfs.c
index a9218e5..b72e210 100644
--- a/drivers/net/wireless/ti/wlcore/sysfs.c
+++ b/drivers/net/wireless/ti/wlcore/sysfs.c
@@ -138,7 +138,7 @@ static ssize_t wl1271_sysfs_read_fwlog(struct file *filp, struct kobject *kobj,
 	return len;
 }
 
-static struct bin_attribute fwlog_attr = {
+static const struct bin_attribute fwlog_attr = {
 	.attr = {.name = "fwlog", .mode = S_IRUSR},
 	.read = wl1271_sysfs_read_fwlog,
 };
-- 
1.9.1
