Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43835 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaKDXYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 18:24:02 -0500
From: greearb@candelatech.com
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org, rmanohar@qti.qualcomm.com,
	nbd@openwrt.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath9k:  fix misc debugfs when not using chan context
Date: Tue,  4 Nov 2014 15:22:49 -0800
Message-Id: <1415143370-15173-1-git-send-email-greearb@candelatech.com> (sfid-20141105_002406_891854_C71CD5FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When channel-context is not enabled, all vifs belong to
the first context, but it is not configured as 'assigned'.

Fix misc debugfs file to print out info for non-assigned
contexts, and also print whether ctx is assigned or not.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This is not overly critical, but fixes regression in 3.17 kernel.

 drivers/net/wireless/ath/ath9k/debug.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 46f20a3..3f6d971 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -828,13 +828,14 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 
 	i = 0;
 	ath_for_each_chanctx(sc, ctx) {
-		if (!ctx->assigned || list_empty(&ctx->vifs))
+		if (list_empty(&ctx->vifs))
 			continue;
 		ath9k_calculate_iter_data(sc, ctx, &iter_data);
 
 		len += scnprintf(buf + len, sizeof(buf) - len,
-			"VIF-COUNTS: CTX %i AP: %i STA: %i MESH: %i WDS: %i",
-			i++, iter_data.naps, iter_data.nstations,
+			"VIFS: CTX %i(%i) AP: %i STA: %i MESH: %i WDS: %i",
+			i++, (int)(ctx->assigned), iter_data.naps,
+			iter_data.nstations,
 			iter_data.nmeshes, iter_data.nwds);
 		len += scnprintf(buf + len, sizeof(buf) - len,
 			" ADHOC: %i TOTAL: %hi BEACON-VIF: %hi\n",
-- 
1.9.3

