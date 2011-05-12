Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:37017 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757476Ab1ELOP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 10:15:59 -0400
Received: by eyg7 with SMTP id 7so1033049eyg.27
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 07:15:56 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] wl12xx: export scheduled scan state in debugfs
Date: Thu, 12 May 2011 17:15:38 +0300
Message-Id: <1305209740-30287-6-git-send-email-coelho@ti.com> (sfid-20110512_161602_677777_BAEB6349)
In-Reply-To: <1305209740-30287-1-git-send-email-coelho@ti.com>
References: <1305209740-30287-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the sched_scanning value to the driver_status debugfs entry.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index b2f692b..f1f8df9 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -377,6 +377,7 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_HEX(platform_quirks);
 	DRIVER_STATE_PRINT_HEX(chip.id);
 	DRIVER_STATE_PRINT_STR(chip.fw_ver_str);
+	DRIVER_STATE_PRINT_INT(sched_scanning);
 
 #undef DRIVER_STATE_PRINT_INT
 #undef DRIVER_STATE_PRINT_LONG
-- 
1.7.1

