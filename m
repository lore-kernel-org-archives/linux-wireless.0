Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:40740 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3IIJYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 05:24:54 -0400
Received: by mail-we0-f179.google.com with SMTP id x55so3936856wes.38
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 02:24:53 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/13] wlcore: print active channel in the driver_state
Date: Mon,  9 Sep 2013 12:24:33 +0300
Message-Id: <1378718684-14430-2-git-send-email-eliad@wizery.com> (sfid-20130909_112457_857297_7BCB7DB3)
In-Reply-To: <1378718684-14430-1-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

Print current active channel/s and a role type for
that channel in the driver_state debugfs.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index e17630c..89893c7 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -437,6 +437,7 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	int res = 0;
 	ssize_t ret;
 	char *buf;
+	struct wl12xx_vif *wlvif;
 
 #define DRIVER_STATE_BUF_LEN 1024
 
@@ -450,12 +451,28 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	(res += scnprintf(buf + res, DRIVER_STATE_BUF_LEN - res,\
 			  #x " = " fmt "\n", wl->x))
 
+#define DRIVER_STATE_PRINT_GENERIC(x, fmt, args...)   \
+	(res += scnprintf(buf + res, DRIVER_STATE_BUF_LEN - res,\
+			  #x " = " fmt "\n", args))
+
 #define DRIVER_STATE_PRINT_LONG(x) DRIVER_STATE_PRINT(x, "%ld")
 #define DRIVER_STATE_PRINT_INT(x)  DRIVER_STATE_PRINT(x, "%d")
 #define DRIVER_STATE_PRINT_STR(x)  DRIVER_STATE_PRINT(x, "%s")
 #define DRIVER_STATE_PRINT_LHEX(x) DRIVER_STATE_PRINT(x, "0x%lx")
 #define DRIVER_STATE_PRINT_HEX(x)  DRIVER_STATE_PRINT(x, "0x%x")
 
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+			continue;
+
+		DRIVER_STATE_PRINT_GENERIC(channel, "%d (%s)", wlvif->channel,
+					   wlvif->p2p ? "P2P-CL" : "STA");
+	}
+
+	wl12xx_for_each_wlvif_ap(wl, wlvif)
+		DRIVER_STATE_PRINT_GENERIC(channel, "%d (%s)", wlvif->channel,
+					   wlvif->p2p ? "P2P-GO" : "AP");
+
 	DRIVER_STATE_PRINT_INT(tx_blocks_available);
 	DRIVER_STATE_PRINT_INT(tx_allocated_blocks);
 	DRIVER_STATE_PRINT_INT(tx_allocated_pkts[0]);
@@ -474,7 +491,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(tx_blocks_freed);
 	DRIVER_STATE_PRINT_INT(rx_counter);
 	DRIVER_STATE_PRINT_INT(state);
-	DRIVER_STATE_PRINT_INT(channel);
 	DRIVER_STATE_PRINT_INT(band);
 	DRIVER_STATE_PRINT_INT(power_level);
 	DRIVER_STATE_PRINT_INT(sg_enabled);
-- 
1.8.3.rc1.35.g9b79519

