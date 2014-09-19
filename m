Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5163 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbaISIhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2014 04:37:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/9] ath10k: deduplicate wmi service ready logic
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
	<1411046487-19544-7-git-send-email-michal.kazior@tieto.com>
Date: Fri, 19 Sep 2014 11:37:10 +0300
In-Reply-To: <1411046487-19544-7-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 18 Sep 2014 15:21:24 +0200")
Message-ID: <87a95wngzt.fsf@kamboji.qca.qualcomm.com> (sfid-20140919_103729_677953_1C67D775)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The logic responsible for processing the event is
> no different across different firmware binaries.
> The difference that needs to be dealt with is the
> ABI of data structures.
>
> The intermediate structure uses __le32 to avoid
> extra memory allocations to byteswap
> variable-length substructures (i.e. host mem
> chunks).
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
> +		ret = ath10k_wmi_10x_pull_svc_rdy_ev(skb, &arg);
> +		wmi_10x_svc_map(arg.service_map, svc_bmap);
> +	} else {
> +		ret = ath10k_wmi_pull_svc_rdy_ev(skb, &arg);
> +		wmi_main_svc_map(arg.service_map, svc_bmap);
> +	}

For consistency shouldn't the latter be
ath10k_wmi_main_pull_svc_rdy_ev()?

> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -1394,6 +1394,7 @@ struct wlan_host_mem_req {
>   * wmi_service_ready_event,e.g., 11ac pass some of the
>   * device capability to the host.
>   */
> +
>  struct wmi_service_ready_event {
>  	__le32 sw_version;
>  	__le32 sw_version_1;

Isn't this unneeded change?

-- 
Kalle Valo
