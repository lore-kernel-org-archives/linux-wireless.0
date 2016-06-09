Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25002 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbcFIHIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 03:08:51 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Prasun Maiti <prasunmaiti87@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	Linux Next <linux-next@vger.kernel.org>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>,
	Prasun Maiti <prasunmaii87@gmail.com>
Subject: Re: [PATCH] Add .set_antenna callback in ath6kl driver to fix
 wireless core warns
Date: Thu, 9 Jun 2016 07:08:42 +0000
Message-ID: <87ziquomff.fsf@qca.qualcomm.com> (sfid-20160609_090920_357929_44391C73)
References: <CAGRGNgV4sL2TypkR+zsaDHN26KCF0kjtWPsi9y9D_JkGpvWrUw@mail.gmail.com>
	<1465450591-23543-1-git-send-email-prasunmaiti87@gmail.com>
In-Reply-To: <1465450591-23543-1-git-send-email-prasunmaiti87@gmail.com>
	(Prasun Maiti's message of "Thu, 9 Jun 2016 11:06:31 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prasun Maiti <prasunmaiti87@gmail.com> writes:

> Since add more warnings for inconsistent ops in cfg80211, the wireless
> core warns if a driver implements a cfg80211 callback but doesn't
> implements the inverse operation. The ath6kl driver implements a cfg80211
> .get_antenna operation handler but doesn't have the inverse .set_antenna
> callback. So, it makes warning.
>
> To remove this warning, add .set_antenna callback in ath6kl driver which
> is unimplemented.
>
> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>

[...]

> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -3231,6 +3231,16 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>  					wait, buf, len, no_cck);
>  }
>  
> +static int ath6kl_set_antenna(struct wiphy *wiphy,
> +				u32 tx_ant, u32 rx_ant)
> +{
> +	/*
> +	 * Note: This callback should be implement when firmware support this
> +	 * command.
> +	 */
> +	return 0;
> +}
> +
>  static int ath6kl_get_antenna(struct wiphy *wiphy,
>  			      u32 *tx_ant, u32 *rx_ant)
>  {
> @@ -3456,6 +3466,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
>  	.cancel_remain_on_channel = ath6kl_cancel_remain_on_channel,
>  	.mgmt_tx = ath6kl_mgmt_tx,
>  	.mgmt_frame_register = ath6kl_mgmt_frame_register,
> +	.set_antenna = ath6kl_set_antenna,

Now we are claiming that ath6kl supports set antenna command but it
actually doesn't do anything, I don't like that. I would rather look at
why cfg80211 issues the warning and is it really necessary.

-- 
Kalle Valo