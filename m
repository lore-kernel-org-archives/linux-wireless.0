Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56333 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbcGRRTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 13:19:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 5/9] mwifiex: cfg80211 set_default_mgmt_key handler
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
	<1468248832-21969-6-git-send-email-akarwar@marvell.com>
Date: Mon, 18 Jul 2016 20:19:01 +0300
In-Reply-To: <1468248832-21969-6-git-send-email-akarwar@marvell.com>
	(Amitkumar Karwar's message of "Mon, 11 Jul 2016 20:23:48 +0530")
Message-ID: <87r3aqx3sq.fsf@kamboji.qca.qualcomm.com> (sfid-20160718_191912_478826_CF446B63)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> It is observed that hostapd fails to setup with management frame
> protection mode enabled when using mwifiex. This patch adds
> cfg80211_set_default_mgmt_key handler to resolve the problem.
>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index 8955f8c..bf95cca 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -484,6 +484,18 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
>  }
>  
>  /*
> + * CFG802.11 operation handler to set default mgmt key.
> + */
> +static int
> +mwifiex_cfg80211_set_default_mgmt_key(struct wiphy *wiphy,
> +				      struct net_device *netdev,
> +				      u8 key_index)
> +{
> +	wiphy_dbg(wiphy, "set default mgmt key, key index=%d\n", key_index);
> +	return 0;
> +}
> +
> +/*
>   * This function sends domain information to the firmware.
>   *
>   * The following information are passed to the firmware -
> @@ -4002,6 +4014,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
>  	.leave_ibss = mwifiex_cfg80211_leave_ibss,
>  	.add_key = mwifiex_cfg80211_add_key,
>  	.del_key = mwifiex_cfg80211_del_key,
> +	.set_default_mgmt_key = mwifiex_cfg80211_set_default_mgmt_key,
>  	.mgmt_tx = mwifiex_cfg80211_mgmt_tx,
>  	.mgmt_frame_register = mwifiex_cfg80211_mgmt_frame_register,
>  	.remain_on_channel = mwifiex_cfg80211_remain_on_channel,

Is it correct to ignore the key index? I see that brcmfmac ignores it as
well but I want to still confirm this.

Does this mean that with this patcfh mwifiex properly supports MFP?

-- 
Kalle Valo
