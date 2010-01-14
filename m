Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36153 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab0ANXGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 18:06:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 1/2] b43: make finding the most significant bit common function
Date: Fri, 15 Jan 2010 00:06:07 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <op.u6iu91z39lhzdc@linux-g0th.site>
In-Reply-To: <op.u6iu91z39lhzdc@linux-g0th.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001150006.08621.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 14 January 2010 13:21:27 Rafał Miłecki wrote:
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>   drivers/net/wireless/b43/phy_common.c |   14 ++++++++++++++
>   drivers/net/wireless/b43/phy_common.h |    1 +
>   drivers/net/wireless/b43/phy_lp.c     |   17 ++---------------
>   3 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
> index 75b26e1..1389ab2 100644
> --- a/drivers/net/wireless/b43/phy_common.c
> +++ b/drivers/net/wireless/b43/phy_common.c
> @@ -421,3 +421,17 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on)
>   {
>   	b43_write16(dev, B43_MMIO_PHY0, on ? 0 : 0xF4);
>   }
> +
> +/* Find the position of the most significant bit */
> +u8 phy_nbits(s32 val)
> +{
> +	u32 tmp = abs(val);
> +	u8 nbits = 0;
> +
> +	while (tmp != 0) {
> +		nbits++;
> +		tmp >>= 1;
> +	}
> +
> +	return nbits;
> +}

We already have fls() in bitops.h
I think the following call would be equivalent:

x = fls(abs(val));

So we don't need our own implementation in phy_common.c.
Just use the standard funcs.

-- 
Greetings, Michael.
