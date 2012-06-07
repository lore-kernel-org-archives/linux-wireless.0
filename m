Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:33695 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932082Ab2FGUkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:40:08 -0400
Received: by lbbgg6 with SMTP id gg6so975304lbb.36
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 13:39:43 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 2/9] wlcore: add debugfs control over rx interrupt pacing
Date: Thu,  7 Jun 2012 23:39:21 +0300
Message-Id: <1339101568-25346-3-git-send-email-coelho@ti.com> (sfid-20120607_224017_262330_8F06018F)
In-Reply-To: <1339101568-25346-1-git-send-email-coelho@ti.com>
References: <1339101568-25346-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Add control over several conf fields which combined
control the rx interrupt pacing mechanism, that is avoiding
getting an interrupt following a single frame rx but instead
have the FW trigger the interrupt only after a certain
amount of frames received or a timeout.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 50300ff..827a728 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -177,6 +177,14 @@ static inline void no_write_handler(struct wl1271 *wl,
 		.open = simple_open,					\
 		.llseek = default_llseek,				\
 	};
+
+WL12XX_CONF_DEBUGFS(irq_pkt_threshold, rx, 0, 65535,
+		    chip_op_handler, wl1271_acx_init_rx_interrupt)
+WL12XX_CONF_DEBUGFS(irq_blk_threshold, rx, 0, 65535,
+		    chip_op_handler, wl1271_acx_init_rx_interrupt)
+WL12XX_CONF_DEBUGFS(irq_timeout, rx, 0, 100,
+		    chip_op_handler, wl1271_acx_init_rx_interrupt)
+
 static ssize_t gpio_power_read(struct file *file, char __user *user_buf,
 			  size_t count, loff_t *ppos)
 {
@@ -957,6 +965,9 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(dynamic_ps_timeout, rootdir);
 	DEBUGFS_ADD(forced_ps, rootdir);
 	DEBUGFS_ADD(split_scan_timeout, rootdir);
+	DEBUGFS_ADD(irq_pkt_threshold, rootdir);
+	DEBUGFS_ADD(irq_blk_threshold, rootdir);
+	DEBUGFS_ADD(irq_timeout, rootdir);
 
 	streaming = debugfs_create_dir("rx_streaming", rootdir);
 	if (!streaming || IS_ERR(streaming))
-- 
1.7.10

