Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63498 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab2GWQqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 12:46:33 -0400
Received: by gglu4 with SMTP id u4so5665183ggl.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 09:46:32 -0700 (PDT)
Message-ID: <500D7FE4.1090100@lwfinger.net> (sfid-20120723_184637_252162_1EC8740B)
Date: Mon, 23 Jul 2012 11:46:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: be more user friendly with PHY info
References: <1343063462-3719-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1343063462-3719-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/23/2012 12:11 PM, Rafał Miłecki wrote:
> First of all, use PHY names instead of magic numbers. It should make
> configuring kernel easier in case of not enabled PHY type support.
> Secondly, always print info about PHY. This is really basic info about
> hardware and quite important for the support level.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>   drivers/net/wireless/b43/main.c |   36 +++++++++++++++++++++++++++++++-----
>   1 files changed, 31 insertions(+), 5 deletions(-)

I like this change. It is worth the small increase in the size of b43.

Larry

>
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index b80352b..a56f182 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -4277,6 +4277,33 @@ out:
>   	return err;
>   }
>
> +static char *b43_phy_name(struct b43_wldev *dev, u8 phy_type)
> +{
> +	switch (phy_type) {
> +	case B43_PHYTYPE_A:
> +		return "A";
> +	case B43_PHYTYPE_B:
> +		return "B";
> +	case B43_PHYTYPE_G:
> +		return "G";
> +	case B43_PHYTYPE_N:
> +		return "N";
> +	case B43_PHYTYPE_LP:
> +		return "LP";
> +	case B43_PHYTYPE_SSLPN:
> +		return "SSLPN";
> +	case B43_PHYTYPE_HT:
> +		return "HT";
> +	case B43_PHYTYPE_LCN:
> +		return "LCN";
> +	case B43_PHYTYPE_LCNXN:
> +		return "LCNXN";
> +	}
> +
> +	b43err(dev->wl, "Unknown PHY Type: %d\n", phy_type);
> +	return "UNKNOWN";
> +}
> +
>   /* Get PHY and RADIO versioning numbers */
>   static int b43_phy_versioning(struct b43_wldev *dev)
>   {
> @@ -4337,13 +4364,12 @@ static int b43_phy_versioning(struct b43_wldev *dev)
>   		unsupported = 1;
>   	}
>   	if (unsupported) {
> -		b43err(dev->wl, "FOUND UNSUPPORTED PHY "
> -		       "(Analog %u, Type %u, Revision %u)\n",
> -		       analog_type, phy_type, phy_rev);
> +		b43err(dev->wl, "FOUND UNSUPPORTED PHY (Analog %u, Type %s, Revision %u)\n",
> +		       analog_type, b43_phy_name(dev, phy_type), phy_rev);
>   		return -EOPNOTSUPP;
>   	}
> -	b43dbg(dev->wl, "Found PHY: Analog %u, Type %u, Revision %u\n",
> -	       analog_type, phy_type, phy_rev);
> +	b43info(dev->wl, "Found PHY: Analog %u, Type %s, Revision %u\n",
> +		analog_type, b43_phy_name(dev, phy_type), phy_rev);
>
>   	/* Get RADIO versioning */
>   	if (dev->dev->core_rev >= 24) {
>


