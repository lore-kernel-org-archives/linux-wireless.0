Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:41310 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab0LGVIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:08:46 -0500
Subject: Re: [PATCH 2/4] b43: set TMS to work with current band width for
 N-PHY
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <1291755360-21570-3-git-send-email-zajec5@gmail.com> (sfid-20101207_155651_681285_648FF7A9)
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
	 <1291755360-21570-3-git-send-email-zajec5@gmail.com>
	 (sfid-20101207_155651_681285_648FF7A9)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 22:08:37 +0100
Message-ID: <1291756117.27497.101.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 21:55 +0100, Rafał Miłecki wrote: 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/main.c       |    6 ++++++
>  drivers/net/wireless/b43/phy_common.c |    7 +++++++
>  drivers/net/wireless/b43/phy_common.h |    2 ++
>  drivers/net/wireless/b43/phy_n.c      |    7 -------
>  4 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index fa48803..670fd7b 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -1150,6 +1150,12 @@ void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
>  
>  	flags |= B43_TMSLOW_PHYCLKEN;
>  	flags |= B43_TMSLOW_PHYRESET;
> +	if (dev->phy.type == B43_PHYTYPE_N) {
> +		if (b43_channel_type_is_40mhz(dev->phy.channel_type))

Is channel_type already set at this time?

> +			flags |= B43_TMSLOW_PHYCLKSPEED_160MHZ;
> +		else
> +			flags |= B43_TMSLOW_PHYCLKSPEED_80MHZ;
> +	}


-- 
Greetings Michael.

