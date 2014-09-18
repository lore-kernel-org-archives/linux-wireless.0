Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:46747 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbaIRNcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 09:32:11 -0400
Received: by mail-we0-f178.google.com with SMTP id q58so932516wes.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 06:32:10 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/9] ath10k: deduplicate wmi_channel code
Date: Thu, 18 Sep 2014 15:21:21 +0200
Message-Id: <1411046487-19544-4-git-send-email-michal.kazior@tieto.com> (sfid-20140918_153218_621586_071383E5)
In-Reply-To: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The structure is being set up in 2 places.
Deduplicate the code by creating a helper.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c | 77 ++++++++++++++++-------------------
 2 files changed, 37 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c738827..f0d11e2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1729,6 +1729,7 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 			ch->passive = passive;
 
 			ch->freq = channel->center_freq;
+			ch->band_center_freq1 = channel->center_freq;
 			ch->min_power = 0;
 			ch->max_power = channel->max_power * 2;
 			ch->max_reg_power = channel->max_reg_power * 2;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 89e63d5..78fc5aaf 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -609,6 +609,40 @@ static struct wmi_cmd_map wmi_10_2_cmd_map = {
 	.gpio_output_cmdid = WMI_10_2_GPIO_OUTPUT_CMDID,
 };
 
+static void
+ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
+			   const struct wmi_channel_arg *arg)
+{
+	u32 flags = 0;
+
+	memset(ch, 0, sizeof(*ch));
+
+	if (arg->passive)
+		flags |= WMI_CHAN_FLAG_PASSIVE;
+	if (arg->allow_ibss)
+		flags |= WMI_CHAN_FLAG_ADHOC_ALLOWED;
+	if (arg->allow_ht)
+		flags |= WMI_CHAN_FLAG_ALLOW_HT;
+	if (arg->allow_vht)
+		flags |= WMI_CHAN_FLAG_ALLOW_VHT;
+	if (arg->ht40plus)
+		flags |= WMI_CHAN_FLAG_HT40_PLUS;
+	if (arg->chan_radar)
+		flags |= WMI_CHAN_FLAG_DFS;
+
+	ch->mhz = __cpu_to_le32(arg->freq);
+	ch->band_center_freq1 = __cpu_to_le32(arg->band_center_freq1);
+	ch->band_center_freq2 = 0;
+	ch->min_power = arg->min_power;
+	ch->max_power = arg->max_power;
+	ch->reg_power = arg->max_reg_power;
+	ch->antenna_max = arg->max_antenna_gain;
+
+	/* mode & flags share storage */
+	ch->mode = arg->mode;
+	ch->flags |= __cpu_to_le32(flags);
+}
+
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
 	int ret;
@@ -3502,7 +3536,6 @@ ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 	struct sk_buff *skb;
 	const char *cmdname;
 	u32 flags = 0;
-	u32 ch_flags = 0;
 
 	if (cmd_id != ar->wmi.cmd->vdev_start_request_cmdid &&
 	    cmd_id != ar->wmi.cmd->vdev_restart_request_cmdid)
@@ -3529,8 +3562,6 @@ ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 		flags |= WMI_VDEV_START_HIDDEN_SSID;
 	if (arg->pmf_enabled)
 		flags |= WMI_VDEV_START_PMF_ENABLED;
-	if (arg->channel.chan_radar)
-		ch_flags |= WMI_CHAN_FLAG_DFS;
 
 	cmd = (struct wmi_vdev_start_request_cmd *)skb->data;
 	cmd->vdev_id         = __cpu_to_le32(arg->vdev_id);
@@ -3546,18 +3577,7 @@ ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 		memcpy(cmd->ssid.ssid, arg->ssid, arg->ssid_len);
 	}
 
-	cmd->chan.mhz = __cpu_to_le32(arg->channel.freq);
-
-	cmd->chan.band_center_freq1 =
-		__cpu_to_le32(arg->channel.band_center_freq1);
-
-	cmd->chan.mode = arg->channel.mode;
-	cmd->chan.flags |= __cpu_to_le32(ch_flags);
-	cmd->chan.min_power = arg->channel.min_power;
-	cmd->chan.max_power = arg->channel.max_power;
-	cmd->chan.reg_power = arg->channel.max_reg_power;
-	cmd->chan.reg_classid = arg->channel.reg_class_id;
-	cmd->chan.antenna_max = arg->channel.max_antenna_gain;
+	ath10k_wmi_put_wmi_channel(&cmd->chan, &arg->channel);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi vdev %s id 0x%x flags: 0x%0X, freq %d, mode %d, ch_flags: 0x%0X, max_power: %d\n",
@@ -3938,35 +3958,10 @@ int ath10k_wmi_scan_chan_list(struct ath10k *ar,
 	cmd->num_scan_chans = __cpu_to_le32(arg->n_channels);
 
 	for (i = 0; i < arg->n_channels; i++) {
-		u32 flags = 0;
-
 		ch = &arg->channels[i];
 		ci = &cmd->chan_info[i];
 
-		if (ch->passive)
-			flags |= WMI_CHAN_FLAG_PASSIVE;
-		if (ch->allow_ibss)
-			flags |= WMI_CHAN_FLAG_ADHOC_ALLOWED;
-		if (ch->allow_ht)
-			flags |= WMI_CHAN_FLAG_ALLOW_HT;
-		if (ch->allow_vht)
-			flags |= WMI_CHAN_FLAG_ALLOW_VHT;
-		if (ch->ht40plus)
-			flags |= WMI_CHAN_FLAG_HT40_PLUS;
-		if (ch->chan_radar)
-			flags |= WMI_CHAN_FLAG_DFS;
-
-		ci->mhz               = __cpu_to_le32(ch->freq);
-		ci->band_center_freq1 = __cpu_to_le32(ch->freq);
-		ci->band_center_freq2 = 0;
-		ci->min_power         = ch->min_power;
-		ci->max_power         = ch->max_power;
-		ci->reg_power         = ch->max_reg_power;
-		ci->antenna_max       = ch->max_antenna_gain;
-
-		/* mode & flags share storage */
-		ci->mode              = ch->mode;
-		ci->flags            |= __cpu_to_le32(flags);
+		ath10k_wmi_put_wmi_channel(ci, ch);
 	}
 
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->scan_chan_list_cmdid);
-- 
1.8.5.3

