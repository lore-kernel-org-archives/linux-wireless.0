Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34803 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYLXOby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 09:31:54 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43: detect N PHY revision/radio
Date: Wed, 24 Dec 2008 15:30:52 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1230128800.4566.3.camel@johannes>
In-Reply-To: <1230128800.4566.3.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812241530.52838.mb@bu3sch.de> (sfid-20081224_153206_432088_195B256B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 24 December 2008 15:26:40 Johannes Berg wrote:
> Does nothing unless you enable the hidden N PHY config.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/b43/main.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

ACK, please apply to 2.6.29

> --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-12-24 15:00:50.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/b43/main.c	2008-12-24 15:25:03.000000000 +0100
> @@ -3758,7 +3758,7 @@ static int b43_phy_versioning(struct b43
>  		break;
>  #ifdef CONFIG_B43_NPHY
>  	case B43_PHYTYPE_N:
> -		if (phy_rev > 1)
> +		if (phy_rev > 4)
>  			unsupported = 1;
>  		break;
>  #endif
> @@ -3811,7 +3811,7 @@ static int b43_phy_versioning(struct b43
>  			unsupported = 1;
>  		break;
>  	case B43_PHYTYPE_N:
> -		if (radio_ver != 0x2055)
> +		if (radio_ver != 0x2055 && radio_ver != 0x2056)
>  			unsupported = 1;
>  		break;
>  	default:
> 
> 
> 
> 



-- 
Greetings, Michael.
