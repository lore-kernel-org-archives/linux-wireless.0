Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:34979 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbbAEEh7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2015 23:37:59 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: Remove unused variable
Date: Mon,  5 Jan 2015 10:10:22 +0530
Message-Id: <1420432822-10819-1-git-send-email-sujith@msujith.org> (sfid-20150105_053803_273912_D9F893AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

htt->max_throughput_mbps is not used anywhere.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.c | 1 -
 drivers/net/wireless/ath/ath10k/htt.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 56cb4ac..ceec764 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -53,7 +53,6 @@ int ath10k_htt_init(struct ath10k *ar)
 	struct ath10k_htt *htt = &ar->htt;
 
 	htt->ar = ar;
-	htt->max_throughput_mbps = 800;
 
 	/*
 	 * Prefetch enough data to satisfy target
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 1aa5db1..1d2a8c5 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1184,7 +1184,6 @@ struct ath10k_htt {
 	struct ath10k *ar;
 	enum ath10k_htc_ep_id eid;
 
-	int max_throughput_mbps;
 	u8 target_version_major;
 	u8 target_version_minor;
 	struct completion target_version_received;
-- 
2.2.1

