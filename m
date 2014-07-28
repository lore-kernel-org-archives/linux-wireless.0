Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:38060 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaG1Nhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 09:37:47 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so7265148wgh.6
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2014 06:37:45 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: improve channel switching
Date: Mon, 28 Jul 2014 15:28:52 +0200
Message-Id: <1406554132-17264-1-git-send-email-michal.kazior@tieto.com> (sfid-20140728_153751_200263_60C43885)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases during heavy tx vdev stop-start
would timeout on vdev synchronization causing
traffic to stall for a few seconds.

Instead of stop-starting use a dedicated vdev
restart command and down vdevs explicitly before
doing so.

This gets rid of the synchronization
warnings/timeouts and makes channel switching
smoother during traffic.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9d61bb1..b76efe2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -796,7 +796,7 @@ static void ath10k_recalc_radar_detection(struct ath10k *ar)
 	}
 }
 
-static int ath10k_vdev_start(struct ath10k_vif *arvif)
+static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
 {
 	struct ath10k *ar = arvif->ar;
 	struct cfg80211_chan_def *chandef = &ar->chandef;
@@ -838,7 +838,11 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 		   arg.vdev_id, arg.channel.freq,
 		   ath10k_wmi_phymode_str(arg.channel.mode));
 
-	ret = ath10k_wmi_vdev_start(ar, &arg);
+	if (restart)
+		ret = ath10k_wmi_vdev_restart(ar, &arg);
+	else
+		ret = ath10k_wmi_vdev_start(ar, &arg);
+
 	if (ret) {
 		ath10k_warn("failed to start WMI vdev %i: %d\n",
 			    arg.vdev_id, ret);
@@ -858,6 +862,16 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 	return ret;
 }
 
+static int ath10k_vdev_start(struct ath10k_vif *arvif)
+{
+	return ath10k_vdev_start_restart(arvif, false);
+}
+
+static int ath10k_vdev_restart(struct ath10k_vif *arvif)
+{
+	return ath10k_vdev_start_restart(arvif, true);
+}
+
 static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 {
 	struct ath10k *ar = arvif->ar;
@@ -2582,18 +2596,21 @@ static void ath10k_config_chan(struct ath10k *ar)
 		if (!arvif->is_started)
 			continue;
 
+		if (!arvif->is_up)
+			continue;
+
 		if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
 			continue;
 
-		ret = ath10k_vdev_stop(arvif);
+		ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
 		if (ret) {
-			ath10k_warn("failed to stop vdev %d: %d\n",
+			ath10k_warn("failed to down vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			continue;
 		}
 	}
 
-	/* all vdevs are now stopped - now attempt to restart them */
+	/* all vdevs are downed now - attempt to restart and re-up them */
 
 	list_for_each_entry(arvif, &ar->arvifs, list) {
 		if (!arvif->is_started)
@@ -2602,9 +2619,9 @@ static void ath10k_config_chan(struct ath10k *ar)
 		if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
 			continue;
 
-		ret = ath10k_vdev_start(arvif);
+		ret = ath10k_vdev_restart(arvif);
 		if (ret) {
-			ath10k_warn("failed to start vdev %d: %d\n",
+			ath10k_warn("failed to restart vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			continue;
 		}
-- 
1.8.5.3

