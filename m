Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53514 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbEIONu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 10:13:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Jean-Pierre TOSONI" <jp.tosoni@acksys.fr>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: allow up to 8 access point vifs on DFS channels
References: <773DB8A82AB6A046AE0195C68612A31901A7192A@sbs2003.acksys.local>
Date: Sat, 09 May 2015 17:13:44 +0300
In-Reply-To: <773DB8A82AB6A046AE0195C68612A31901A7192A@sbs2003.acksys.local>
	(Jean-Pierre TOSONI's message of "Wed, 6 May 2015 15:20:19 +0200")
Message-ID: <87sib5ltyf.fsf@kamboji.qca.qualcomm.com> (sfid-20150509_161414_434069_F3165F1B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Jean-Pierre TOSONI" <jp.tosoni@acksys.fr> writes:

> Allow the combination of 8 (AP + mesh) interfaces on radar channels
>
> Tested with hostapd, 2 and 8 BSSIDs, 1 or 2 DFS channels, BW 20 MHz
> TODO: test AP+mesh combination
> TODO: test 40 MHz BW
> ---
> This patch was done with quilt on Openwrt against compat-wireless
> 2014-11-04
>
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -723,6 +723,14 @@ static const struct ieee80211_iface_limi
>  				 BIT(NL80211_IFTYPE_ADHOC) },
>  };
>  
> +static const struct ieee80211_iface_limit if_dfs_limits_mvap[] = {
> +	{ .max = 8,	.types =
> +#ifdef CPTCFG_MAC80211_MESH
> +				 BIT(NL80211_IFTYPE_MESH_POINT) |
> +#endif
> +				 BIT(NL80211_IFTYPE_AP) },
> +};

CPTCFG_ prefix is a backports prefix and should not be used in kernel
patches.

-- 
Kalle Valo
