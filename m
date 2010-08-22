Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52538 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab0HVXUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 19:20:31 -0400
Received: by bwz11 with SMTP id 11so3454815bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 16:20:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282506589-8220-1-git-send-email-zajec5@gmail.com>
References: <1282506589-8220-1-git-send-email-zajec5@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 23 Aug 2010 09:20:10 +1000
Message-ID: <AANLkTi=TMhmTF+ztooAu=E1e1zdw-cBnaSZCKj=Utik0@mail.gmail.com>
Subject: Re: [PATCH 1/2] b43: N-PHY: band width setting with dumb clock
 control call
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org,
	=?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafal,

Couple of minor style issues, if you're re-submitting.

2010/8/23 Rafał Miłecki <zajec5@gmail.com>:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/phy_common.c |   20 ++++++++++++++++++++
>  drivers/net/wireless/b43/phy_common.h |   11 +++++++++++
>  drivers/net/wireless/b43/phy_n.c      |    4 ++--
>  drivers/net/wireless/b43/phy_n.h      |    1 -
>  4 files changed, 33 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
> index 8f7d7ef..b06e3f0 100644
> --- a/drivers/net/wireless/b43/phy_common.c
> +++ b/drivers/net/wireless/b43/phy_common.c
> @@ -466,3 +466,23 @@ struct b43_c32 b43_cordic(int theta)
>
>        return ret;
>  }
> +
> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/ClkCtlClk */
> +static void b43_clock_control(struct b43_wldev *dev, u32 mode)
> +{
> +       ; /* TODO */

You don't need the semicolon here, as I understand it.

> +}
> +
> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacBwSet */
> +void b43_bmac_set_b_width(struct b43_wldev *dev, u8 b_width)
> +{
> +       bool fast = dev->phy.forcefastclk;;

Double semicolon - and is it necessary to assign a local variable here?

> +       if (!fast)
> +               b43_clock_control(dev, 0);
> +       dev->phy.b_width = b_width;
> +       b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
> +       /* TODO: Call PHY BMAC Reset */
> +       dev->phy.ops->init(dev);
> +       if (fast)
> +               b43_clock_control(dev, 2);
> +}

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
