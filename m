Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:42136 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934568AbbI2KaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 06:30:12 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@qca.qualcomm.com, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath: fix DFS timestamp wraparound reset condition
Date: Tue, 29 Sep 2015 12:29:49 +0200
Message-Id: <1443522589-14421-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20150929_123017_195136_131C4137)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DFS pattern detector ought to reset the
detector lines when a pulse is added with
lower time stamp than the previous (which
indicates a TSF restart).

This did not work so far and is fixed with
this patch.

The modification does not change detection
performance within the driver, since it
only ensures early reset (which is later
performed by the PRI detectors anyway).
It is relevant for synthetic tests and
statistical evaluations, where millions
of pulse patterns are processed and an
early reset helps reducing load.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 656ce42..b52c209 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -290,10 +290,10 @@ dpd_add_pulse(struct dfs_pattern_detector *dpd, struct pulse_event *event)
 	if (cd == NULL)
 		return false;
 
-	dpd->last_pulse_ts = event->ts;
 	/* reset detector on time stamp wraparound, caused by TSF reset */
 	if (event->ts < dpd->last_pulse_ts)
 		dpd_reset(dpd);
+	dpd->last_pulse_ts = event->ts;
 
 	/* do type individual pattern matching */
 	for (i = 0; i < dpd->num_radar_types; i++) {
-- 
2.5.0

