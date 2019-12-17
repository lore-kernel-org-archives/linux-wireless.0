Return-Path: <SRS0=hdaX=2H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F80EC43603
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Dec 2019 17:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2105221D7D
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Dec 2019 17:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfLQRWE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:22:04 -0500
Received: from nbd.name ([46.4.11.11]:53648 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbfLQRWE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Dec 2019 12:22:04 -0500
Received: from pd95fd66b.dip0.t-ipconnect.de ([217.95.214.107] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1ihGXq-0007DR-Ln; Tue, 17 Dec 2019 18:22:02 +0100
From:   John Crispin <john@phrozen.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        Miles Hu <milehu@codeaurora.org>,
        John Crispin <john@phrozen.org>
Subject: [PATCH] ath11k: htt stats module does not handle multiple skbs
Date:   Tue, 17 Dec 2019 18:22:00 +0100
Message-Id: <20191217172200.7470-1-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Miles Hu <milehu@codeaurora.org>

This patch removes the "done" check from the stats handler thus allowing
the code to parse more skbs.

Reviewed-by: John Crispin <john@phrozen.org>
Signed-off-by: Miles Hu <milehu@codeaurora.org>
---
 drivers/net/wireless/ath/ath11k/debug_htt_stats.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debug_htt_stats.c b/drivers/net/wireless/ath/ath11k/debug_htt_stats.c
index 27b301bc1a1b..45dbffaca3bd 100644
--- a/drivers/net/wireless/ath/ath11k/debug_htt_stats.c
+++ b/drivers/net/wireless/ath/ath11k/debug_htt_stats.c
@@ -4119,6 +4119,7 @@ void ath11k_dbg_htt_ext_stats_handler(struct ath11k_base *ab,
 {
 	struct ath11k_htt_extd_stats_msg *msg;
 	struct debug_htt_stats_req *stats_req;
+	bool send_completion = false;
 	struct ath11k *ar;
 	u32 len;
 	u64 cookie;
@@ -4147,10 +4148,8 @@ void ath11k_dbg_htt_ext_stats_handler(struct ath11k_base *ab,
 		return;
 
 	spin_lock_bh(&ar->debug.htt_stats.lock);
-	if (stats_req->done) {
-		spin_unlock_bh(&ar->debug.htt_stats.lock);
-		return;
-	}
+	if (!stats_req->done)
+		send_completion = true;
 	stats_req->done = true;
 	spin_unlock_bh(&ar->debug.htt_stats.lock);
 
@@ -4161,7 +4160,8 @@ void ath11k_dbg_htt_ext_stats_handler(struct ath11k_base *ab,
 	if (ret)
 		ath11k_warn(ab, "Failed to parse tlv %d\n", ret);
 
-	complete(&stats_req->cmpln);
+	if (send_completion)
+		complete(&stats_req->cmpln);
 }
 
 static ssize_t ath11k_read_htt_stats_type(struct file *file,
-- 
2.20.1

