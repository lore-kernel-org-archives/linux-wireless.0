Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39630 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753218AbeB0Nnu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 08:43:50 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wcn36xx: reduce verbosity of drivers messages
References: <20180227133149.26805-1-rfried@codeaurora.org>
Date: Tue, 27 Feb 2018 15:43:45 +0200
In-Reply-To: <20180227133149.26805-1-rfried@codeaurora.org> (Ramon Fried's
        message of "Tue, 27 Feb 2018 15:31:49 +0200")
Message-ID: <87sh9msg32.fsf@kamboji.qca.qualcomm.com> (sfid-20180227_144405_706752_0B3E801B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> writes:

> Whenever the WLAN interface is started the FW
> version and caps are printed.
> The caps now will be displayed only in debug mode.
> Firmware version will be displayed only once on first
> startup of the interface.
>
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> ---
> v2: print the firwmare version as info but only
> 	onetime.

[...]

>  static int wcn36xx_smd_start_rsp(struct wcn36xx *wcn, void *buf, size_t len)
>  {
> +	static bool first = true;
>  	struct wcn36xx_hal_mac_start_rsp_msg *rsp;
>  
>  	if (len < sizeof(*rsp))
> @@ -409,15 +410,17 @@ static int wcn36xx_smd_start_rsp(struct wcn36xx *wcn, void *buf, size_t len)
>  	wcn->fw_minor = rsp->start_rsp_params.version.minor;
>  	wcn->fw_major = rsp->start_rsp_params.version.major;
>  
> -	wcn36xx_info("firmware WLAN version '%s' and CRM version '%s'\n",
> -		     wcn->wlan_version, wcn->crm_version);
> -
> -	wcn36xx_info("firmware API %u.%u.%u.%u, %u stations, %u bssids\n",
> -		     wcn->fw_major, wcn->fw_minor,
> -		     wcn->fw_version, wcn->fw_revision,
> -		     rsp->start_rsp_params.stations,
> -		     rsp->start_rsp_params.bssids);
> +	if (first) {
> +		first = false;

static variables are evil if you have more than one device on the same
host. Sure, I guess all current hardware only have one wcn36xx device
per hardware but still we should not endorse this bad practise. A much
better approach is to add a new field to struct wcn36xx.

-- 
Kalle Valo
