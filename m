Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:40005 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab3JWLFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 07:05:24 -0400
Received: by mail-ea0-f182.google.com with SMTP id o10so338939eaj.27
        for <linux-wireless@vger.kernel.org>; Wed, 23 Oct 2013 04:05:23 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: use proper tx power unit
Date: Wed, 23 Oct 2013 04:02:14 -0700
Message-Id: <1382526135-3215-3-git-send-email-michal.kazior@tieto.com> (sfid-20131023_130529_486169_6ABF1DC6)
In-Reply-To: <1382526135-3215-1-git-send-email-michal.kazior@tieto.com>
References: <1382526135-3215-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was previously thought that FW expects tx power
in quarters of dBm.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 18 +++++++++---------
 drivers/net/wireless/ath/ath10k/wmi.h |  3 ++-
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 35d5d3a..1d91201 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -451,9 +451,9 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 	arg.channel.mode = chan_to_phymode(&conf->chandef);
 
 	arg.channel.min_power = 0;
-	arg.channel.max_power = channel->max_power * 4;
-	arg.channel.max_reg_power = channel->max_reg_power * 4;
-	arg.channel.max_antenna_gain = channel->max_antenna_gain;
+	arg.channel.max_power = channel->max_power * 2;
+	arg.channel.max_reg_power = channel->max_reg_power * 2;
+	arg.channel.max_antenna_gain = channel->max_antenna_gain * 2;
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		arg.ssid = arvif->u.ap.ssid;
@@ -530,9 +530,9 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 	arg.channel.mode = chan_to_phymode(&ar->hw->conf.chandef);
 
 	arg.channel.min_power = 0;
-	arg.channel.max_power = channel->max_power * 4;
-	arg.channel.max_reg_power = channel->max_reg_power * 4;
-	arg.channel.max_antenna_gain = channel->max_antenna_gain;
+	arg.channel.max_power = channel->max_power * 2;
+	arg.channel.max_reg_power = channel->max_reg_power * 2;
+	arg.channel.max_antenna_gain = channel->max_antenna_gain * 2;
 
 	ret = ath10k_wmi_vdev_start(ar, &arg);
 	if (ret) {
@@ -1376,9 +1376,9 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 
 			ch->freq = channel->center_freq;
 			ch->min_power = 0;
-			ch->max_power = channel->max_power * 4;
-			ch->max_reg_power = channel->max_reg_power * 4;
-			ch->max_antenna_gain = channel->max_antenna_gain;
+			ch->max_power = channel->max_power * 2;
+			ch->max_reg_power = channel->max_reg_power * 2;
+			ch->max_antenna_gain = channel->max_antenna_gain * 2;
 			ch->reg_class_id = 0; /* FIXME */
 
 			/* FIXME: why use only legacy modes, why not any
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 78c991a..81e33a7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -893,6 +893,7 @@ struct wmi_channel {
 	union {
 		__le32 reginfo0;
 		struct {
+			/* note: power unit is 0.5 dBm */
 			u8 min_power;
 			u8 max_power;
 			u8 reg_power;
@@ -915,7 +916,7 @@ struct wmi_channel_arg {
 	bool allow_ht;
 	bool allow_vht;
 	bool ht40plus;
-	/* note: power unit is 1/4th of dBm */
+	/* note: power unit is 0.5 dBm */
 	u32 min_power;
 	u32 max_power;
 	u32 max_reg_power;
-- 
1.8.4.rc3

