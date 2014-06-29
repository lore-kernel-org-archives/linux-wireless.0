Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:50756 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaF2Tk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 15:40:28 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so7218174wes.29
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2014 12:40:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/2] staging: vt6656: implement get_stats ieee80211_low_level_stats
Date: Sun, 29 Jun 2014 20:39:54 +0100
Message-Id: <1404070795-3034-1-git-send-email-tvboxspy@gmail.com> (sfid-20140629_214032_182418_37CE2DD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver already report low_level_stats via vnt_interrupt_data.

Allow mac80211 to collect them via vnt_get_stats

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  1 +
 drivers/staging/vt6656/int.c      |  6 ++++++
 drivers/staging/vt6656/main_usb.c | 11 +++++++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index f1ed43e..4d1eb22 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -438,6 +438,7 @@ struct vnt_private {
 	u8 byChannelSwitchCount;
 
 	struct iw_statistics wstats; /* wireless stats */
+	struct ieee80211_low_level_stats low_stats;
 };
 
 #define ADD_ONE_WITH_WRAP_AROUND(uVar, uModulo) {   \
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 23d045c..1913b73 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -79,6 +79,7 @@ void INTnsProcessData(struct vnt_private *priv)
 {
 	struct vnt_interrupt_data *int_data;
 	struct net_device_stats *stats = &priv->stats;
+	struct ieee80211_low_level_stats *low_stats = &priv->low_stats;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptProcessData\n");
 
@@ -133,6 +134,11 @@ void INTnsProcessData(struct vnt_private *priv)
 #endif
 		}
 		priv->qwCurrTSF = le64_to_cpu(int_data->tsf);
+
+		low_stats->dot11RTSSuccessCount += int_data->rts_success;
+		low_stats->dot11RTSFailureCount += int_data->rts_fail;
+		low_stats->dot11ACKFailureCount += int_data->ack_fail;
+		low_stats->dot11FCSErrorCount += int_data->fcs_err;
 	}
 
 	if (int_data->isr1 != 0)
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 14845ec..8a4695e 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1006,6 +1006,16 @@ static void vnt_sw_scan_complete(struct ieee80211_hw *hw)
 	BBvUpdatePreEDThreshold(priv, false);
 }
 
+static int vnt_get_stats(struct ieee80211_hw *hw,
+				struct ieee80211_low_level_stats *stats)
+{
+	struct vnt_private *priv = hw->priv;
+
+	memcpy(stats, &priv->low_stats, sizeof(*stats));
+
+	return 0;
+}
+
 static u64 vnt_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct vnt_private *priv = hw->priv;
@@ -1043,6 +1053,7 @@ static const struct ieee80211_ops vnt_mac_ops = {
 	.set_key		= vnt_set_key,
 	.sw_scan_start		= vnt_sw_scan_start,
 	.sw_scan_complete	= vnt_sw_scan_complete,
+	.get_stats		= vnt_get_stats,
 	.get_tsf		= vnt_get_tsf,
 	.set_tsf		= vnt_set_tsf,
 	.reset_tsf		= vnt_reset_tsf,
-- 
1.9.1

