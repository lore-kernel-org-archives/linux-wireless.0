Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:50564 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbZHJCIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 22:08:34 -0400
Received: by pzk34 with SMTP id 34so2595464pzk.4
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2009 19:08:35 -0700 (PDT)
Message-ID: <4A7F811F.4070908@lwfinger.net>
Date: Sun, 09 Aug 2009 21:08:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH] b43: Implement LP-PHY baseband table initialization
References: <4A7F713E.8040405@gmail.com>
In-Reply-To: <4A7F713E.8040405@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> Implement LP-PHY baseband table init for all revisions.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> 
> ---
> Sorry for the size; it's difficult to cut short changes like this
> (most of the patch is just table data). Please review, there may always be
> bugs that I failed to catch while reading through the code. I have added
> comments to places that were not quite clear to me.
> 
> phy_lp.c       |   41 tables_lpphy.c | 3223
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> tables_lpphy.h |    3 3 files changed, 3263 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_lp.c
> b/drivers/net/wireless/b43/phy_lp.c
> index 27eadee..cf17489 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -59,9 +59,43 @@ static void b43_lpphy_op_free(struct b43_wldev *dev)
>     dev->phy.lp = NULL;
> }
> 
> +static void lpphy_adjust_gain_table(struct b43_wldev *dev)
> +{
> +    struct b43_phy_lp *lpphy = dev->phy.lp;
> +    u32 freq = dev->wl->hw->conf.channel->center_freq;
> +    u16 temp[3];
> +    u16 isolation;
> +
> +    B43_WARN_ON(dev->phy.rev >= 2);
> +
> +    if (freq < 2400) /* FIXME Can this ever happen? Should we WARN_ON? */

This was a typo. It should be 2500, not 2400.

> +        isolation = lpphy->tx_isolation_med_band;
> +    else if (freq <= 5320)

--snip --

> +void lpphy_rev2plus_table_init(struct b43_wldev *dev)
> +{
> +    struct ssb_bus *bus = dev->dev->bus;
> +    int i;
> +
> +    B43_WARN_ON(dev->phy.rev < 2);
> +
> +    //XXX should this be done using b43_lptab_write_bulk?
> +    for (i = 0; i < 704; i++)
> +        b43_lptab_write(dev, B43_LPTAB32(7, i), 0);

No. The bulk write is for writing tables with length greater than 1.
In this case, you have 704 different tables each of length 1.

I am still looking through the patch. I'll let you know of any thing I
find.

Larry

