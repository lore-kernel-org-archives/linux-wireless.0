Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:28046 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbZITJ2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2009 05:28:18 -0400
Received: by fg-out-1718.google.com with SMTP id 22so869980fge.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2009 02:28:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253434164.19515.5.camel@ht.satnam>
References: <1253434164.19515.5.camel@ht.satnam>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 20 Sep 2009 11:28:01 +0200
Message-ID: <69e28c910909200228m675ffff8p5b5812158d41b6fb@mail.gmail.com>
Subject: Re: [RFC][PATCH] b43: Comment unused functions lpphy_restore_dig_flt_state
	and lpphy_disable_rx_gain_override
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These will be needed for calibration. (My calibration RFC already
makes use of them.)

On Sun, Sep 20, 2009 at 10:09 AM, Jaswinder Singh Rajput
<jaswinder@kernel.org> wrote:
>
> Commenting unused functions lpphy_restore_dig_flt_state and
> lpphy_disable_rx_gain_override, may be we need these functions in future.
>
> This also fixed following compilation warnings :
>  CC [M]  drivers/net/wireless/b43/phy_lp.o
> drivers/net/wireless/b43/phy_lp.c:383: warning: ‘lpphy_restore_dig_flt_state’ defined but not used
> drivers/net/wireless/b43/phy_lp.c:891: warning: ‘lpphy_disable_rx_gain_override’ defined but not used
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  drivers/net/wireless/b43/phy_lp.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> index 3e02d96..9c31462 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -379,6 +379,8 @@ static void lpphy_save_dig_flt_state(struct b43_wldev *dev)
>        }
>  }
>
> +/* lpphy_restore_dig_flt_state is unused but kept as a reference */
> +#if 0
>  static void lpphy_restore_dig_flt_state(struct b43_wldev *dev)
>  {
>        static const u16 addr[] = {
> @@ -399,6 +401,7 @@ static void lpphy_restore_dig_flt_state(struct b43_wldev *dev)
>        for (i = 0; i < ARRAY_SIZE(addr); i++)
>                b43_phy_write(dev, addr[i], lpphy->dig_flt_state[i]);
>  }
> +#endif
>
>  static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
>  {
> @@ -887,6 +890,8 @@ static void lpphy_rev2plus_set_rx_gain(struct b43_wldev *dev, u32 gain)
>        }
>  }
>
> +/* lpphy_disable_rx_gain_override is unused but kept as a reference */
> +#if 0
>  static void lpphy_disable_rx_gain_override(struct b43_wldev *dev)
>  {
>        b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFFFE);
> @@ -902,6 +907,7 @@ static void lpphy_disable_rx_gain_override(struct b43_wldev *dev)
>                b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFDFF);
>        }
>  }
> +#endif
>
>  static void lpphy_enable_rx_gain_override(struct b43_wldev *dev)
>  {
> --
> 1.6.4.4
>
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
