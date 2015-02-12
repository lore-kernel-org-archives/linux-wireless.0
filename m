Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4346 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbbBLVSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 16:18:31 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath: Enhance radar detection by looking up chirp
Date: Thu, 12 Feb 2015 13:17:05 -0800
Message-ID: <1423775825-19498-3-git-send-email-poh@qca.qualcomm.com> (sfid-20150212_221836_801326_B597D303)
In-Reply-To: <1423775825-19498-1-git-send-email-poh@qca.qualcomm.com>
References: <1423775825-19498-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Certain radar types such as FCC radar type 5 are using chirp
in their pulses, hence looking up the chirp status will enhance
to avoid false radar detection.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/dfs_pri_detector.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/dfs_pri_detector.c b/drivers/net/wireless/ath/dfs_pri_detector.c
index 43b6081..1b5ad19 100644
--- a/drivers/net/wireless/ath/dfs_pri_detector.c
+++ b/drivers/net/wireless/ath/dfs_pri_detector.c
@@ -390,6 +390,10 @@ static struct pri_sequence *pri_detector_add_pulse(struct pri_detector *de,
 	if ((ts - de->last_ts) < rs->max_pri_tolerance)
 		/* if delta to last pulse is too short, don't use this pulse */
 		return NULL;
+	/* radar detector spec needs chirp, but not detected */
+	if (rs->chirp && rs->chirp != event->chirp)
+		return NULL;
+
 	de->last_ts = ts;
 
 	max_updated_seq = pseq_handler_add_to_existing_seqs(de, ts);
-- 
1.9.1

