Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:51613 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644Ab2EJN5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 09:57:05 -0400
Received: by yenl6 with SMTP id l6so1875938yen.23
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 06:57:04 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <coelho@ti.com>, <arik@wizery.com>
Subject: [PATCH] wlcore: fix fm_coex parameters configuration
Date: Thu, 10 May 2012 16:54:31 +0300
Message-Id: <1336658071-11317-1-git-send-email-victorg@ti.com> (sfid-20120510_155716_845286_C76FF75A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wrong fm_coex parameters were set during wlcore
init phase, fix it.

Signed-off-by: Ziv Riesel <zivriesel@ti.com>
Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index d7dd3de..5131375 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -305,8 +305,8 @@ static struct wlcore_conf wl12xx_conf = {
 		.swallow_period               = 5,
 		.n_divider_fref_set_1         = 0xff,       /* default */
 		.n_divider_fref_set_2         = 12,
-		.m_divider_fref_set_1         = 148,
-		.m_divider_fref_set_2         = 0xffff,     /* default */
+		.m_divider_fref_set_1         = 0xffff,
+		.m_divider_fref_set_2         = 148,	    /* default */
 		.coex_pll_stabilization_time  = 0xffffffff, /* default */
 		.ldo_stabilization_time       = 0xffff,     /* default */
 		.fm_disturbed_band_margin     = 0xff,       /* default */
-- 
1.7.5.4

