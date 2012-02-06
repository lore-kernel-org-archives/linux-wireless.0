Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26040 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2BFOOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 09:14:34 -0500
Message-ID: <4F2FE044.2000106@qca.qualcomm.com> (sfid-20120206_151438_223505_90D87A48)
Date: Mon, 6 Feb 2012 16:14:28 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Check wow state before sending control and data
 pkt
References: <1328536613-17521-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1328536613-17521-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2012 03:56 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> * TX operation (ctrl tx and data tx) has to be controlled based on
>   WOW suspend state. i.e, control packets are allowed to send from
>   the host until the suspend state goes ATH6KL_STATE_WOW and
>   the data packets are allowed until WOW suspend operation starts.
> 
> * Similary, wow resume is NOT allowed if WOW suspend is in progress.
> 
> Both of the above scenarios are taken care in this patch.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

[...]

> +enum ath6kl_wow_state {
> +	ATH6KL_WOW_STATE_NONE,
> +	ATH6KL_WOW_STATE_SUSPENDING,
> +	ATH6KL_WOW_STATE_SUSPENDED,
> +};
> +
>  struct ath6kl {
>  	struct device *dev;
>  	struct wiphy *wiphy;
>  
>  	enum ath6kl_state state;
> +	enum ath6kl_wow_state wow_state;
>  	unsigned int testmode;

To be honest, adding a new state variable scares me. I don't see how we
are able to maintain two different state variables, the end result would
be a total mess.

I recommend to look at this problem by adding a new state to enum
ath6kl_state. That would make it a lot easier to handle all the
different states.

(I haven't looked rest of your patch yet.)

Kalle
