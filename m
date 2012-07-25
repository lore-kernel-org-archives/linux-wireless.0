Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:47870 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932943Ab2GYOKg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 10:10:36 -0400
Message-ID: <1343225435.1693.10.camel@joe2Laptop> (sfid-20120725_161126_540214_7C80E69E)
Subject: Re: [PATCH V2] b43: be more user friendly with PHY info
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Date: Wed, 25 Jul 2012 07:10:35 -0700
In-Reply-To: <1343227629-14161-1-git-send-email-zajec5@gmail.com>
References: <1343227629-14161-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-25 at 16:47 +0200, Rafał Miłecki wrote:
> use PHY names instead of magic numbers.
[]
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
[]
> @@ -4277,6 +4277,37 @@ out:
[]
> +static char *b43_phy_name(struct b43_wldev *dev, u8 phy_type)
> +{
> +	switch (phy_type) {
> +	case B43_PHYTYPE_A:
> +		return "A";
[]
> +	}
> +
> +	b43err(dev->wl, "Unknown PHY Type: %d\n", phy_type);
> +	return "UNKNOWN";

In general, it's a bad idea to emit error messages
in a generic call like this.

> @@ -4337,13 +4368,12 @@ static int b43_phy_versioning(struct b43_wldev *dev)
>  		unsupported = 1;
>  	}
>  	if (unsupported) {
> -		b43err(dev->wl, "FOUND UNSUPPORTED PHY "
> -		       "(Analog %u, Type %u, Revision %u)\n",
> -		       analog_type, phy_type, phy_rev);
> +		b43err(dev->wl, "FOUND UNSUPPORTED PHY (Analog %u, Type %s, Revision %u)\n",
> +		       analog_type, b43_phy_name(dev, phy_type), phy_rev);

The extra message doesn't add much useful info
and can also cause errors in continued messages.


