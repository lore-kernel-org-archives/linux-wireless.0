Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:53753 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751803Ab2FLUzc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 16:55:32 -0400
Message-ID: <1339534531.4501.3.camel@joe2Laptop> (sfid-20120612_225536_270278_7B5CBA84)
Subject: Re: [PATCH] ath6kl: support rssi threshold for sched scan
From: Joe Perches <joe@perches.com>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Tue, 12 Jun 2012 13:55:31 -0700
In-Reply-To: <1339533979-32084-1-git-send-email-c_tpeder@qca.qualcomm.com>
References: <1339533979-32084-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 13:46 -0700, Thomas Pedersen wrote:
> The ath6kl firmware can filter scan results based on rssi. This is
> useful to limit hosts wakeups on scheduled scans.
[]
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> index 6f20998..4f20693 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -3267,6 +3267,16 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
>  			return ret;
>  	}
>  
> +	if (test_bit(ATH6KL_FW_CAPABILITY_RSSI_SCAN_THOLD,
> +		     ar->fw_capabilities)) {
> +		ret = ath6kl_wmi_set_rssi_filter_cmd(ar->wmi, vif->fw_vif_idx,
> +						    request->rssi_thold);

poor argument alignment.

> +		if (ret) {
> +			ath6kl_err("failed to set RSSI threshold for scan");

missing newline termination.


