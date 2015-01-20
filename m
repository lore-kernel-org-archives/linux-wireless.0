Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59926 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbbATEgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 23:36:13 -0500
Message-ID: <54BDDB3B.3020902@candelatech.com> (sfid-20150120_053615_980046_EDCF449E)
Date: Mon, 19 Jan 2015 20:36:11 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org, martin@darmstadt.freifunk.net
Subject: Re: [RFC/RFT] ath10k: enable IBSS in multi-vif
References: <54B97B96.4040903@darmstadt.freifunk.net> <1421658833-13311-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1421658833-13311-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/19/2015 01:13 AM, Michal Kazior wrote:
> The 999.999.0.636 firmware seems to support
> concurrent IBSS + AP/STA. At least basic stuff
> works so enable it since some people are
> interested in this stuff.
>
> If it's broken we can fix, restrict or disable it
> later.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
> Hi Martin,
>
> Feel free to take this patch and run whatever case
> you had in mind. If this proves to work for you
> without any major issues (like notorious crashes,
> traffic issues and such) I guess we could try
> pulling this upstream.
>
> Make sure you use 999.999.0.636 firmware. The 10.x
> doesn't support IBSS at all.

Likely my 10.1.467 based CT firmware will support this as well...

Ben

>
>
>   drivers/net/wireless/ath/ath10k/mac.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 9524bc5..11170ce 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -5032,6 +5032,10 @@ static const struct ieee80211_iface_limit ath10k_if_limits[] = {
>   	.max	= 7,
>   	.types	= BIT(NL80211_IFTYPE_AP)
>   	},
> +	{
> +	.max	= 1,
> +	.types	= BIT(NL80211_IFTYPE_ADHOC)
> +	},
>   };
>
>   static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
