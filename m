Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38973 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZHPNnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 09:43:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Fix a spec error in the B2062 channel switch routine
Date: Sun, 16 Aug 2009 15:43:11 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A880A78.9050205@gmail.com>
In-Reply-To: <4A880A78.9050205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908161543.11499.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 16 August 2009 15:32:40 Gábor Stefanik wrote:
> The channel switch routine had a whole instruction missing. Add it.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>

ack

> ---
>  drivers/net/wireless/b43/phy_lp.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> index a51da6e..3889519 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -1939,6 +1939,10 @@ static int lpphy_b2062_tune(struct b43_wldev *dev,
>  	tmp5 = tmp7 * 0x100;
>  	tmp6 = tmp5 / tmp4;
>  	tmp7 = tmp5 % tmp4;
> +	b43_radio_write(dev, B2062_S_RFPLL_CTL27, tmp6);
> +	tmp5 = tmp7 * 0x100;
> +	tmp6 = tmp5 / tmp4;
> +	tmp7 = tmp5 % tmp4;
>  	b43_radio_write(dev, B2062_S_RFPLL_CTL28, tmp6);
>  	tmp5 = tmp7 * 0x100;
>  	tmp6 = tmp5 / tmp4;



-- 
Greetings, Michael.
