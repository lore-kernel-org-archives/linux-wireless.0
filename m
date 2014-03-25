Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50412 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaCYH4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 03:56:04 -0400
Received: by mail-pa0-f47.google.com with SMTP id lj1so93432pab.34
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 00:56:03 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath10k: fix printing of peer stats in non-AP firmware
Date: Tue, 25 Mar 2014 15:55:46 +0800
Message-Id: <1395734146-10907-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140325_085610_607633_0748732F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is intended to fix the problem if we use the
firmware 999.999.0.636 to get peer stats when the number
of peer is more than 3. The WMI_UPDATE_STATS_EVENTID may
trigger more than 1 time if the number of peers is more
than 3. So this patch allows us to do the checking on this
and make sure that we print the peer stats correctly.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 7be284c..4a4072e 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -245,10 +245,17 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 	if (num_peer_stats) {
 		struct wmi_peer_stats_10x *peer_stats;
 		struct ath10k_peer_stat *s;
+		int j = 0;
+
+		if (!test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features) &&
+		    !num_pdev_stats) {
+			j = 3;
+			num_peer_stats += 3;
+		}
 
 		stats->peers = num_peer_stats;
 
-		for (i = 0; i < num_peer_stats; i++) {
+		for (i = j; i < num_peer_stats; i++) {
 			peer_stats = (struct wmi_peer_stats_10x *)tmp;
 			s = &stats->peer_stat[i];
 
-- 
1.7.9.5

