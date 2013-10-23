Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:53925 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab3JWLFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 07:05:22 -0400
Received: by mail-ea0-f180.google.com with SMTP id l9so267660eaj.25
        for <linux-wireless@vger.kernel.org>; Wed, 23 Oct 2013 04:05:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: setup min channel power to a reasonable value
Date: Wed, 23 Oct 2013 04:02:13 -0700
Message-Id: <1382526135-3215-2-git-send-email-michal.kazior@tieto.com> (sfid-20131023_130527_059026_65A26378)
In-Reply-To: <1382526135-3215-1-git-send-email-michal.kazior@tieto.com>
References: <1382526135-3215-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be needed for proper support of (user)
configurable tx power level.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index da23c3f..35d5d3a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -450,7 +450,7 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 
 	arg.channel.mode = chan_to_phymode(&conf->chandef);
 
-	arg.channel.min_power = channel->max_power * 3;
+	arg.channel.min_power = 0;
 	arg.channel.max_power = channel->max_power * 4;
 	arg.channel.max_reg_power = channel->max_reg_power * 4;
 	arg.channel.max_antenna_gain = channel->max_antenna_gain;
@@ -529,7 +529,7 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 	   don't have any vifs? */
 	arg.channel.mode = chan_to_phymode(&ar->hw->conf.chandef);
 
-	arg.channel.min_power = channel->max_power * 3;
+	arg.channel.min_power = 0;
 	arg.channel.max_power = channel->max_power * 4;
 	arg.channel.max_reg_power = channel->max_reg_power * 4;
 	arg.channel.max_antenna_gain = channel->max_antenna_gain;
@@ -1375,7 +1375,7 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 			ch->passive = passive;
 
 			ch->freq = channel->center_freq;
-			ch->min_power = channel->max_power * 3;
+			ch->min_power = 0;
 			ch->max_power = channel->max_power * 4;
 			ch->max_reg_power = channel->max_reg_power * 4;
 			ch->max_antenna_gain = channel->max_antenna_gain;
-- 
1.8.4.rc3

