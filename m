Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:54416 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbZHJXOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 19:14:32 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1217816wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 16:14:33 -0700 (PDT)
Message-ID: <4A80A9D5.2060704@lwfinger.net>
Date: Mon, 10 Aug 2009 18:14:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Fix a typo in the sync_stx routine
References: <4A80A522.2020200@gmail.com>
In-Reply-To: <4A80A522.2020200@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> I completely missed the "one's complement" instruction from the specs.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> drivers/net/wireless/b43/phy_lp.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_lp.c
> b/drivers/net/wireless/b43/phy_lp.c
> index 46fe476..34ad738 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -578,7 +578,7 @@ static void lpphy_sync_stx(struct b43_wldev *dev)
>         tmp >>= e->rf_shift;
>         tmp <<= e->phy_shift;
>         b43_phy_maskset(dev, B43_PHY_OFDM(0xF2 + e->phy_offset),
> -                e->mask << e->phy_shift, tmp);
> +                ~(e->mask << e->phy_shift), tmp);
>     }
> }
> 

I should have caught that one.

When debugging gets started, it might be useful to add a statement

      WARN_ON(mask & set);

at the start of b43_radio_maskset() and b43_phy_maskset(). That way
these kind of mistakes will be caught early.

Larry


