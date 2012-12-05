Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:43307 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab2LER51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 12:57:27 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless:  Fix ethtool stats and other ops.
References: <1354729192-22945-1-git-send-email-greearb@candelatech.com>
Date: Wed, 05 Dec 2012 18:57:21 +0100
In-Reply-To: <1354729192-22945-1-git-send-email-greearb@candelatech.com>
	(greearb-my8's message of "Wed, 5 Dec 2012 09:39:52 -0800")
Message-ID: <87a9ts4c1q.fsf@nemi.mork.no> (sfid-20121205_185731_303939_703F3387)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> net/core/dev.c now assigns a default ethtool ops, so
> the net/wireless/core.c check for existing ops is always true
> so the wireless ops would never be assigned.
>
> Simply remove the check for existing ops and always assign
> the wireless ops.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  net/wireless/core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 4e6fe62..6309699 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -863,8 +863,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>  		/* allow mac80211 to determine the timeout */
>  		wdev->ps_timeout = -1;
>  
> -		if (!dev->ethtool_ops)
> -			dev->ethtool_ops = &cfg80211_ethtool_ops;
> +		dev->ethtool_ops = &cfg80211_ethtool_ops;
>  
>  		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
>  		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||


Won't this break drivers which for some reason have their own
ethtool_ops?

bjorn@nemi:/usr/local/src/git/linux$ git grep -- "->ethtool_ops" drivers/net/wireless/
drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c:    ndev->ethtool_ops = &brcmf_ethtool_ops;
drivers/net/wireless/ipw2x00/ipw2100.c: dev->ethtool_ops = &ipw2100_ethtool_ops;
drivers/net/wireless/ipw2x00/ipw2200.c: net_dev->ethtool_ops = &ipw_ethtool_ops;
drivers/net/wireless/libertas/main.c:   dev->ethtool_ops = &lbs_ethtool_ops;
drivers/net/wireless/libertas/mesh.c:   mesh_dev->ethtool_ops = &lbs_ethtool_ops;
drivers/net/wireless/prism54/islpci_dev.c:      ndev->ethtool_ops = &islpci_ethtool_ops;



Bjørn
