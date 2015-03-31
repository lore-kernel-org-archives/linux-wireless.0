Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35705 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbbCaLHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 07:07:50 -0400
Received: by lbdc10 with SMTP id c10so9576890lbd.2
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2015 04:07:48 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: use scan burst for hw roc
Date: Tue, 31 Mar 2015 11:03:48 +0000
Message-Id: <1427799828-9539-2-git-send-email-michal.kazior@tieto.com> (sfid-20150331_130754_442356_54EAEA93)
In-Reply-To: <1427799828-9539-1-git-send-email-michal.kazior@tieto.com>
References: <1427799828-9539-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This improves chances of getting onto a foreign
channel and thus makes P2P a bit more reliable.

Without scan burst it was possible for firmware to
not switch to foreign channel resulting in "failed
to switch to channel for roc scan" warning. This
would also effectively fail some offchan tx
requests and lead to P2P find/connect taking
longer. This could be observed when other vifs
were running/busy, e.g. with P2P GO.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     | 1 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 +-
 drivers/net/wireless/ath/ath10k/wmi.h     | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index cb5d253e87d9..1d48eaafe42b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5069,6 +5069,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 	arg.max_scan_time = scan_time_msec;
 	arg.scan_ctrl_flags |= WMI_SCAN_FLAG_PASSIVE;
 	arg.scan_ctrl_flags |= WMI_SCAN_FILTER_PROBE_REQ;
+	arg.burst_duration_ms = duration;
 
 	ret = ath10k_start_scan(ar, &arg);
 	if (ret) {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 7bfb45492027..8a6f6fdf4bdc 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1358,7 +1358,7 @@ ath10k_wmi_tlv_op_gen_start_scan(struct ath10k *ar,
 	cmd = (void *)tlv->value;
 
 	ath10k_wmi_put_start_scan_common(&cmd->common, arg);
-	cmd->burst_duration_ms = __cpu_to_le32(0);
+	cmd->burst_duration_ms = __cpu_to_le32(arg->burst_duration_ms);
 	cmd->num_channels = __cpu_to_le32(arg->n_channels);
 	cmd->num_ssids = __cpu_to_le32(arg->n_ssids);
 	cmd->num_bssids = __cpu_to_le32(arg->n_bssids);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 00b5799c5cdb..ef47ab5c4c9f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2168,6 +2168,7 @@ struct wmi_start_scan_arg {
 	u32 max_scan_time;
 	u32 probe_delay;
 	u32 scan_ctrl_flags;
+	u32 burst_duration_ms;
 
 	u32 ie_len;
 	u32 n_channels;
-- 
2.1.4

