Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:45181 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755788Ab1EJMD1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 08:03:27 -0400
Received: by mail-ey0-f180.google.com with SMTP id 24so1886163eyg.25
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 05:03:26 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 5/5] wl12xx: export scheduled scan state in debugfs
Date: Tue, 10 May 2011 15:03:10 +0300
Message-Id: <1305028990-14044-6-git-send-email-coelho@ti.com> (sfid-20110510_140331_286705_A79EEEE6)
In-Reply-To: <1305028990-14044-1-git-send-email-coelho@ti.com>
References: <1305028990-14044-1-git-send-email-coelho@ti.com>
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

