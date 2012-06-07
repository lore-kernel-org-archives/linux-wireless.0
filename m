Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:50573 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557Ab2FGJRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 05:17:36 -0400
Received: by lagz14 with SMTP id z14so367100lag.21
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 02:17:33 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Reis <idor@ti.com>
Subject: [PATCH 1/5] wl18xx: fix PHY_INIT addresses mem size
Date: Thu,  7 Jun 2012 12:17:21 +0300
Message-Id: <1339060645-3574-2-git-send-email-coelho@ti.com> (sfid-20120607_111740_389268_6AB09E8C)
In-Reply-To: <1339060645-3574-1-git-send-email-coelho@ti.com>
References: <1339060645-3574-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

was hardcoded 252, now uses the parameters struct size.

Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index c8d45f0..e030b12 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -540,8 +540,8 @@ static const struct wlcore_partition_set wl18xx_ptable[PART_TABLE_LEN] = {
 		.mem3 = { .start = 0x00000000, .size  = 0x00000000 },
 	},
 	[PART_PHY_INIT] = {
-		/* TODO: use the phy_conf struct size here */
-		.mem  = { .start = 0x80926000, .size = 252 },
+		.mem  = { .start = 0x80926000,
+			  .size = sizeof(struct wl18xx_mac_and_phy_params) },
 		.reg  = { .start = 0x00000000, .size = 0x00000000 },
 		.mem2 = { .start = 0x00000000, .size = 0x00000000 },
 		.mem3 = { .start = 0x00000000, .size = 0x00000000 },
-- 
1.7.10

