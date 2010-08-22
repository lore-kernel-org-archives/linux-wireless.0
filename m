Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60630 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0HVTuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 15:50:08 -0400
Received: by qyk9 with SMTP id 9so2127570qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 12:50:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282506452-8159-1-git-send-email-zajec5@gmail.com>
References: <1282506452-8159-1-git-send-email-zajec5@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 22 Aug 2010 21:49:47 +0200
Message-ID: <AANLkTikP5hQKMyJD1-7+gaY8PykQ77At+Vpkqf=HRT0H@mail.gmail.com>
Subject: Re: [PATCH] b43: N-PHY: add missing phyrxchain setting and fix
 warning in RX core function
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/8/22 Rafał Miłecki <zajec5@gmail.com>:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> Gábor: please kindly, watch out for such a missing calls/sets. We may lose a
> lot of time looking for such a missing lines later.
> ---
>  drivers/net/wireless/b43/phy_n.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
> index d116229..2466c0a 100644
> --- a/drivers/net/wireless/b43/phy_n.c
> +++ b/drivers/net/wireless/b43/phy_n.c
> @@ -3092,6 +3092,8 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
>        struct b43_phy_n *nphy = phy->n;
>        u16 buf[16];
>
> +       nphy->phyrxchain = mask;
> +
>        if (0 /* FIXME clk */)
>                return;
>
> @@ -3103,7 +3105,7 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
>        b43_phy_maskset(dev, B43_NPHY_RFSEQCA, ~B43_NPHY_RFSEQCA_RXEN,
>                        (mask & 0x3) << B43_NPHY_RFSEQCA_RXEN_SHIFT);
>
> -       if (mask & 0x3 != 0x3) {
> +       if ((mask & 0x3) != 0x3) {

Why is this needed? An & doesn't magically transform into an && under
any circumstances...

>                b43_phy_write(dev, B43_NPHY_HPANT_SWTHRES, 1);
>                if (dev->phy.rev >= 3) {
>                        /* TODO */
> --
> 1.7.1
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
