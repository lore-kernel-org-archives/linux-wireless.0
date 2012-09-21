Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48033 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab2IUJO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 05:14:59 -0400
Message-ID: <505C300F.3060407@qca.qualcomm.com> (sfid-20120921_111503_700951_A8D3A08B)
Date: Fri, 21 Sep 2012 12:14:55 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/3] ath6kl: Avoid null ptr dereference while printing
 reg domain pair
References: <1348122068-24648-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1348122068-24648-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2012 09:21 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Return value of ath6kl_get_regpair() is stored in 'regpair' in
> ath6kl_wmi_regdomain_event() func and it's directly accessed
> in the debug prints without checking for NULL value. There are
> situation to get NULL pointer as a return value from
> ath6kl_get_regpair() func. Fix this.
> 
> Found this on code review.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/wmi.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
> index 68b46bd..d5263ff 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -936,8 +936,9 @@ static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
>  
>  		regpair = ath6kl_get_regpair((u16) reg_code);
>  		country = ath6kl_regd_find_country_by_rd((u16) reg_code);
> -		ath6kl_dbg(ATH6KL_DBG_WMI, "Regpair used: 0x%0x\n",
> -			   regpair->regDmnEnum);
> +		if (regpair)
> +			ath6kl_dbg(ATH6KL_DBG_WMI, "Regpair used: 0x%0x\n",
> +				   regpair->regDmnEnum);

The problem with this is that the regpair debug print is not printed at
all. Maybe something like this:

if (regpair)
	ath6kl_dbg(ATH6KL_DBG_WMI, "Regpair used: 0x%0x\n",
			   regpair->regDmnEnum);
else
	ath6kl_warn("Regpair not found reg_code 0x%0x\n",
			reg_code);

I used the ath6kl_warn() here as this should not happen and we can more
easily notice the issue with ath6kl_warn(). Actually someone reported
about this crash on IRC earlier this week.

Kalle

