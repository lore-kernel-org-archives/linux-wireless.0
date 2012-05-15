Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:57544 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755808Ab2EOOSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:18:03 -0400
Received: by ggcs5 with SMTP id s5so4991634ggc.36
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:18:02 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <coelho@ti.com>, <arik@wizery.com>
Subject: [PATCH] wl18xx: fix fm_coex parameters configuration
Date: Tue, 15 May 2012 17:15:40 +0300
Message-Id: <1337091340-24800-1-git-send-email-victorg@ti.com> (sfid-20120515_161810_854695_97375F62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wrong fm_coex parameters were set during wl18xx
init phase, fix it.

Signed-off-by: Ziv Riesel <zivriesel@ti.com>
Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 1bbf195..50dfd7f 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -428,8 +428,8 @@ static struct wlcore_conf wl18xx_conf = {
 		.swallow_period               = 5,
 		.n_divider_fref_set_1         = 0xff,       /* default */
 		.n_divider_fref_set_2         = 12,
-		.m_divider_fref_set_1         = 148,
-		.m_divider_fref_set_2         = 0xffff,     /* default */
+		.m_divider_fref_set_1         = 0xffff,
+		.m_divider_fref_set_2         = 148,        /* default */
 		.coex_pll_stabilization_time  = 0xffffffff, /* default */
 		.ldo_stabilization_time       = 0xffff,     /* default */
 		.fm_disturbed_band_margin     = 0xff,       /* default */
-- 
1.7.5.4

