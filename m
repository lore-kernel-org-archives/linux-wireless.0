Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37538 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1BAJF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 04:05:28 -0500
Received: by fxm20 with SMTP id 20so6548696fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 01:05:26 -0800 (PST)
From: Gery Kahn <gery.kahn@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: update PLT initialization for new firmware
Date: Tue,  1 Feb 2011 11:03:08 +0200
Message-Id: <1296550988-24974-1-git-send-email-geryk@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In revision > 6.1.3.0.0 the firmware expects memory configuration command
as part of boot. This was missing if driver boots in PLT mode.
The patch adds the memory configuration command, which fixes PLT commands
tx continuous and rx statistics.

Signed-off-by: Gery Kahn <geryk@ti.com>
---
This patch depends on Eliad's new firmware patchseries

 drivers/net/wireless/wl12xx/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f5ad55a..4580728 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -482,6 +482,10 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
+	ret = wl1271_acx_sta_mem_cfg(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
 	/* Default fragmentation threshold */
 	ret = wl1271_acx_frag_threshold(wl, wl->conf.tx.frag_threshold);
 	if (ret < 0)
-- 
1.7.0.4

