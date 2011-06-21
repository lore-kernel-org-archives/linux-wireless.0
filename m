Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54977 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab1FUSxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 14:53:46 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mb@bu3sch.de, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] ssb: fix ssb clock rate according to broadcom source
Date: Tue, 21 Jun 2011 20:53:20 +0200
Message-Id: <1308682400-25953-1-git-send-email-hauke@hauke-m.de> (sfid-20110621_205349_005261_D03FE1FE)
In-Reply-To: <1308681113-4706-1-git-send-email-hauke@hauke-m.de>
References: <1308681113-4706-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fix was done according to si_clock_rate function in broadcom siutils.c

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index e568664..57b7b64 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1002,8 +1002,8 @@ u32 ssb_calc_clock_rate(u32 plltype, u32 n, u32 m)
 	switch (plltype) {
 	case SSB_PLLTYPE_6: /* 100/200 or 120/240 only */
 		if (m & SSB_CHIPCO_CLK_T6_MMASK)
-			return SSB_CHIPCO_CLK_T6_M0;
-		return SSB_CHIPCO_CLK_T6_M1;
+			return SSB_CHIPCO_CLK_T6_M1;
+		return SSB_CHIPCO_CLK_T6_M0;
 	case SSB_PLLTYPE_1: /* 48Mhz base, 3 dividers */
 	case SSB_PLLTYPE_3: /* 25Mhz, 2 dividers */
 	case SSB_PLLTYPE_4: /* 48Mhz, 4 dividers */
-- 
1.7.4.1

