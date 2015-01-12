Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34824 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbbALTsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 14:48:45 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/8] ath10k:  fix spelling mistakes and add details to mac logging.
Date: Mon, 12 Jan 2015 10:32:39 -0800
Message-Id: <1421087564-10384-3-git-send-email-greearb@candelatech.com> (sfid-20150112_204854_702211_7FF8D695)
In-Reply-To: <1421087564-10384-1-git-send-email-greearb@candelatech.com>
References: <1421087564-10384-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

A bit of general cleanup to make debug messages more useful.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 924879f..85abb8a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -604,7 +604,7 @@ static int ath10k_monitor_vdev_start(struct ath10k *ar, int vdev_id)
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn(ar, "failed to synchronize setup for monitor vdev %i: %d\n",
+		ath10k_warn(ar, "failed to synchronize setup for monitor vdev %i: %d (start)\n",
 			    vdev_id, ret);
 		return ret;
 	}
@@ -651,7 +651,7 @@ static int ath10k_monitor_vdev_stop(struct ath10k *ar)
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret)
-		ath10k_warn(ar, "failed to synchronise monitor vdev %i: %d\n",
+		ath10k_warn(ar, "failed to synchronize monitor vdev %i: %d (stop)\n",
 			    ar->monitor_vdev_id, ret);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac monitor vdev %i stopped\n",
@@ -936,8 +936,8 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn(ar, "failed to synchronise setup for vdev %i: %d\n",
-			    arg.vdev_id, ret);
+		ath10k_warn(ar, "failed to synchronize setup for vdev %i: %d (restart %d)\n",
+			    arg.vdev_id, ret, restart);
 		return ret;
 	}
 
@@ -975,7 +975,7 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn(ar, "failed to syncronise setup for vdev %i: %d\n",
+		ath10k_warn(ar, "failed to synchronize setup for vdev %i: %d (stop)\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
-- 
1.7.11.7

