Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:54097 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972Ab2EJOLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 10:11:08 -0400
Received: by yenl13 with SMTP id l13so1206076yen.34
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 07:11:07 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <coelho@ti.com>, <arik@wizery.com>
Subject: [PATCH v2] wl12xx: fix fm_coex parameters configuration
Date: Thu, 10 May 2012 17:08:33 +0300
Message-Id: <1336658913-11396-1-git-send-email-victorg@ti.com> (sfid-20120510_161113_135350_3FD52701)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wrong fm_coex parameters were set during wl12xx
init phase, fix it.

Signed-off-by: Ziv Riesel <zivriesel@ti.com>
Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---

v2: changed the subject wlcore -> wl12xx

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

