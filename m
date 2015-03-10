Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:19929 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbbCJQtk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 12:49:40 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 1/3] ath9k: restart only triggering DFS detector line
Date: Tue, 10 Mar 2015 17:49:29 +0100
Message-Id: <1426006171-2555-2-git-send-email-zefir.kurtisi@neratec.com> (sfid-20150310_174949_643603_8E30310D)
In-Reply-To: <1426006171-2555-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1426006171-2555-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To support HT40 DFS mode, a triggering detector must
reset only itself but not other detector lines.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 3d57f87..c657ca2 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -289,7 +289,7 @@ dpd_add_pulse(struct dfs_pattern_detector *dpd, struct pulse_event *event)
 				"count=%d, count_false=%d\n",
 				event->freq, pd->rs->type_id,
 				ps->pri, ps->count, ps->count_falses);
-			channel_detector_reset(dpd, cd);
+			pd->reset(pd, dpd->last_pulse_ts);
 			return true;
 		}
 	}
-- 
1.9.1

