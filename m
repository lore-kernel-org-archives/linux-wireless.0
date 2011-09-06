Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24782 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab1IFG6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 02:58:41 -0400
Message-ID: <4E65C49B.2000201@qca.qualcomm.com> (sfid-20110906_085844_570828_A87EF427)
Date: Tue, 6 Sep 2011 09:58:35 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath6kl: Allow enabling of P2P support
References: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com> <1315233527-6234-5-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1315233527-6234-5-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2011 05:38 PM, Jouni Malinen wrote:
> For now, use a module parameter (ath6kl_p2p) to allow P2P support
> to be enabled. This is needed since there is no mechanism for
> enabling the P2P mode more dynamically for a single netdev.

[...]

> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -20,6 +20,10 @@
>  #include "hif-ops.h"
>  #include "testmode.h"
>  
> +static unsigned int ath6kl_p2p;
> +
> +module_param(ath6kl_p2p, uint, 0644);

Currently all module parameters are in init.c. It's not the best place
and most likely will move to core.c soon, but I still would prefer to
have them all in one place. I think moving this to init.c would make sense.

> --- a/drivers/net/wireless/ath/ath6kl/core.h
> +++ b/drivers/net/wireless/ath/ath6kl/core.h
> @@ -471,6 +471,8 @@ struct ath6kl {
>  	bool probe_req_report;
>  	u16 next_chan;
>  
> +	bool p2p;

We have struct ath6kl::conf_flags exactly for this purpose, see
ATH6KL_CONF_ENABLE_11N for an example. I think we should use it also
with P2P.

> +	if (ar->p2p) {
> +		ret = ath6kl_wmi_info_req_cmd(ar->wmi,
> +					      P2P_FLAG_CAPABILITIES_REQ |
> +					      P2P_FLAG_MACADDR_REQ |
> +					      P2P_FLAG_HMODEL_REQ);
> +		if (ret) {
> +			ath6kl_dbg(ATH6KL_DBG_TRC, "failed to request P2P "
> +				   "capabilities (%d) - assuming P2P not "
> +				   "supported\n", ret);
> +			ar->p2p = 0;
> +		}
> +	}
> +
> +	if (ar->p2p) {

Can we combine this if block with the first one?

If it's ok for you, I'll commit the first three patches and we can talk
more about this patch.

Kalle
