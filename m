Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:33386 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaGaUZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 16:25:54 -0400
Received: by mail-oa0-f42.google.com with SMTP id n16so2463388oag.1
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2014 13:25:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406836788-23704-4-git-send-email-zajec5@gmail.com>
References: <1406836788-23704-1-git-send-email-zajec5@gmail.com> <1406836788-23704-4-git-send-email-zajec5@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 31 Jul 2014 13:25:13 -0700
Message-ID: <CAGVrzcaWKwAdY=cgbb9GNoEG8hkjrPa5OWBHKjftcOdLJKJARQ@mail.gmail.com> (sfid-20140731_222605_194010_E98E8E38)
Subject: Re: [PATCH 3.18 3/7] b43: flush some writes on Broadcom MIPS SoCs
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"open list:ATHEROS ATH5K WIR..." <linux-wireless@vger.kernel.org>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-07-31 12:59 GMT-07:00 Rafał Miłecki <zajec5@gmail.com>:
> Access to PHY and radio registers is indirect on Broadcom hardware and
> it seems that addressing on MIPS SoCs may require flushing. Broadcom
> code does that unconditionally on MIPS, so let's do the same to make
> sure hardware won't miss anything important.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/b43.h        |  8 ++++++++
>  drivers/net/wireless/b43/main.c       | 17 ++++++++---------
>  drivers/net/wireless/b43/phy_a.c      |  4 ++--
>  drivers/net/wireless/b43/phy_common.c |  4 ++--
>  drivers/net/wireless/b43/phy_g.c      |  8 ++++----
>  drivers/net/wireless/b43/phy_ht.c     |  6 +++---
>  drivers/net/wireless/b43/phy_lcn.c    |  6 +++---
>  drivers/net/wireless/b43/phy_lp.c     |  6 +++---
>  drivers/net/wireless/b43/phy_n.c      |  6 +++---
>  9 files changed, 36 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
> index 4113b69..ff0c666 100644
> --- a/drivers/net/wireless/b43/b43.h
> +++ b/drivers/net/wireless/b43/b43.h
> @@ -1012,6 +1012,14 @@ static inline void b43_write16(struct b43_wldev *dev, u16 offset, u16 value)
>         dev->dev->write16(dev->dev, offset, value);
>  }
>
> +static inline void b43_write16f(struct b43_wldev *dev, u16 offset, u16 value)
> +{
> +       b43_write16(dev, offset, value);
> +#if defined(CONFIG_BCM47XX) || defined(CONFIG_BCM63XX)
> +       b43_read16(dev, offset);
> +#endif
> +}

How about you leave the calls to b43_write16() to avoid missing call
sites, but you re-define it for BCM47XX and BCM63XX? Or, you could
introduce a __b43_write16() that defaults to dev->dev->write16 in the
normal case, and gets called by b43_write16() such that we you'd get:


static u16 void __b43_read16(struct b43_wldev *dev, u16 offset)
{
     return dev->dev->readt16(dev->dev, offset);
|

static inline void __b43_write16(struct b43_wldev *dev, u16 offset, u16 value)
{
      dev->dev->write16(dev->dev, offset, value);
#if defined(CONFIG_BCM47XX) || defined(CONFIG_BCM63XX)
      __b43_read16(dev, offset);
#endif
}

static inline void b43_write16(struct b43_wldev *dev, u16 offset, u16 value)
{
      __b43_write16(dev, offset, value);
}

> +
>  static inline void b43_maskset16(struct b43_wldev *dev, u16 offset, u16 mask,
>                                  u16 set)
>  {
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index 2af1ac3..66ff718 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -4466,10 +4466,10 @@ static int b43_phy_versioning(struct b43_wldev *dev)
>         if (core_rev == 40 || core_rev == 42) {
>                 radio_manuf = 0x17F;
>
> -               b43_write16(dev, B43_MMIO_RADIO24_CONTROL, 0);
> +               b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, 0);
>                 radio_rev = b43_read16(dev, B43_MMIO_RADIO24_DATA);
>
> -               b43_write16(dev, B43_MMIO_RADIO24_CONTROL, 1);
> +               b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, 1);
>                 radio_id = b43_read16(dev, B43_MMIO_RADIO24_DATA);
>
>                 radio_ver = 0; /* Is there version somewhere? */
> @@ -4477,7 +4477,7 @@ static int b43_phy_versioning(struct b43_wldev *dev)
>                 u16 radio24[3];
>
>                 for (tmp = 0; tmp < 3; tmp++) {
> -                       b43_write16(dev, B43_MMIO_RADIO24_CONTROL, tmp);
> +                       b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, tmp);
>                         radio24[tmp] = b43_read16(dev, B43_MMIO_RADIO24_DATA);
>                 }
>
> @@ -4494,13 +4494,12 @@ static int b43_phy_versioning(struct b43_wldev *dev)
>                         else
>                                 tmp = 0x5205017F;
>                 } else {
> -                       b43_write16(dev, B43_MMIO_RADIO_CONTROL,
> -                                   B43_RADIOCTL_ID);
> +                       b43_write16f(dev, B43_MMIO_RADIO_CONTROL,
> +                                    B43_RADIOCTL_ID);
>                         tmp = b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
> -                       b43_write16(dev, B43_MMIO_RADIO_CONTROL,
> -                                   B43_RADIOCTL_ID);
> -                       tmp |= (u32)b43_read16(dev, B43_MMIO_RADIO_DATA_HIGH)
> -                               << 16;
> +                       b43_write16f(dev, B43_MMIO_RADIO_CONTROL,
> +                                    B43_RADIOCTL_ID);
> +                       tmp |= b43_read16(dev, B43_MMIO_RADIO_DATA_HIGH) << 16;
>                 }
>                 radio_manuf = (tmp & 0x00000FFF);
>                 radio_id = (tmp & 0x0FFFF000) >> 12;
> diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
> index 25e4043..99c036f 100644
> --- a/drivers/net/wireless/b43/phy_a.c
> +++ b/drivers/net/wireless/b43/phy_a.c
> @@ -444,14 +444,14 @@ static inline u16 adjust_phyreg(struct b43_wldev *dev, u16 offset)
>  static u16 b43_aphy_op_read(struct b43_wldev *dev, u16 reg)
>  {
>         reg = adjust_phyreg(dev, reg);
> -       b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
>         return b43_read16(dev, B43_MMIO_PHY_DATA);
>  }
>
>  static void b43_aphy_op_write(struct b43_wldev *dev, u16 reg, u16 value)
>  {
>         reg = adjust_phyreg(dev, reg);
> -       b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
>         b43_write16(dev, B43_MMIO_PHY_DATA, value);
>  }
>
> diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
> index 08ca524..1dfc682 100644
> --- a/drivers/net/wireless/b43/phy_common.c
> +++ b/drivers/net/wireless/b43/phy_common.c
> @@ -278,7 +278,7 @@ u16 b43_phy_read(struct b43_wldev *dev, u16 reg)
>         if (dev->phy.ops->phy_read)
>                 return dev->phy.ops->phy_read(dev, reg);
>
> -       b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
>         return b43_read16(dev, B43_MMIO_PHY_DATA);
>  }
>
> @@ -294,7 +294,7 @@ void b43_phy_write(struct b43_wldev *dev, u16 reg, u16 value)
>         if (dev->phy.ops->phy_write)
>                 return dev->phy.ops->phy_write(dev, reg, value);
>
> -       b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
>         b43_write16(dev, B43_MMIO_PHY_DATA, value);
>  }
>
> diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
> index 8f5c14b..727ce6e 100644
> --- a/drivers/net/wireless/b43/phy_g.c
> +++ b/drivers/net/wireless/b43/phy_g.c
> @@ -2555,13 +2555,13 @@ static void b43_gphy_op_exit(struct b43_wldev *dev)
>
>  static u16 b43_gphy_op_read(struct b43_wldev *dev, u16 reg)
>  {
> -       b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
>         return b43_read16(dev, B43_MMIO_PHY_DATA);
>  }
>
>  static void b43_gphy_op_write(struct b43_wldev *dev, u16 reg, u16 value)
>  {
> -       b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
>         b43_write16(dev, B43_MMIO_PHY_DATA, value);
>  }
>
> @@ -2572,7 +2572,7 @@ static u16 b43_gphy_op_radio_read(struct b43_wldev *dev, u16 reg)
>         /* G-PHY needs 0x80 for read access. */
>         reg |= 0x80;
>
> -       b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_RADIO_CONTROL, reg);
>         return b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
>  }
>
> @@ -2581,7 +2581,7 @@ static void b43_gphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
>         /* Register 1 is a 32-bit register. */
>         B43_WARN_ON(reg == 1);
>
> -       b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_RADIO_CONTROL, reg);
>         b43_write16(dev, B43_MMIO_RADIO_DATA_LOW, value);
>  }
>
> diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
> index 8b0b4b6..c4dc8b0 100644
> --- a/drivers/net/wireless/b43/phy_ht.c
> +++ b/drivers/net/wireless/b43/phy_ht.c
> @@ -1074,7 +1074,7 @@ static unsigned int b43_phy_ht_op_get_default_chan(struct b43_wldev *dev)
>  static void b43_phy_ht_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
>                                  u16 set)
>  {
> -       b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
>         b43_write16(dev, B43_MMIO_PHY_DATA,
>                     (b43_read16(dev, B43_MMIO_PHY_DATA) & mask) | set);
>  }
> @@ -1084,14 +1084,14 @@ static u16 b43_phy_ht_op_radio_read(struct b43_wldev *dev, u16 reg)
>         /* HT-PHY needs 0x200 for read access */
>         reg |= 0x200;
>
> -       b43_write16(dev, B43_MMIO_RADIO24_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, reg);
>         return b43_read16(dev, B43_MMIO_RADIO24_DATA);
>  }
>
>  static void b43_phy_ht_op_radio_write(struct b43_wldev *dev, u16 reg,
>                                       u16 value)
>  {
> -       b43_write16(dev, B43_MMIO_RADIO24_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, reg);
>         b43_write16(dev, B43_MMIO_RADIO24_DATA, value);
>  }
>
> diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
> index bf29c3e..97461cc 100644
> --- a/drivers/net/wireless/b43/phy_lcn.c
> +++ b/drivers/net/wireless/b43/phy_lcn.c
> @@ -813,7 +813,7 @@ static void b43_phy_lcn_op_adjust_txpower(struct b43_wldev *dev)
>  static void b43_phy_lcn_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
>                                    u16 set)
>  {
> -       b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
>         b43_write16(dev, B43_MMIO_PHY_DATA,
>                     (b43_read16(dev, B43_MMIO_PHY_DATA) & mask) | set);
>  }
> @@ -823,14 +823,14 @@ static u16 b43_phy_lcn_op_radio_read(struct b43_wldev *dev, u16 reg)
>         /* LCN-PHY needs 0x200 for read access */
>         reg |= 0x200;
>
> -       b43_write16(dev, B43_MMIO_RADIO24_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, reg);
>         return b43_read16(dev, B43_MMIO_RADIO24_DATA);
>  }
>
>  static void b43_phy_lcn_op_radio_write(struct b43_wldev *dev, u16 reg,
>                                        u16 value)
>  {
> -       b43_write16(dev, B43_MMIO_RADIO24_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, reg);
>         b43_write16(dev, B43_MMIO_RADIO24_DATA, value);
>  }
>
> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> index 1e9bae6..058a9f2 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -1988,7 +1988,7 @@ static void lpphy_calibration(struct b43_wldev *dev)
>  static void b43_lpphy_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
>                                  u16 set)
>  {
> -       b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
>         b43_write16(dev, B43_MMIO_PHY_DATA,
>                     (b43_read16(dev, B43_MMIO_PHY_DATA) & mask) | set);
>  }
> @@ -2004,7 +2004,7 @@ static u16 b43_lpphy_op_radio_read(struct b43_wldev *dev, u16 reg)
>         } else
>                 reg |= 0x200;
>
> -       b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_RADIO_CONTROL, reg);
>         return b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
>  }
>
> @@ -2013,7 +2013,7 @@ static void b43_lpphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
>         /* Register 1 is a 32-bit register. */
>         B43_WARN_ON(reg == 1);
>
> -       b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_RADIO_CONTROL, reg);
>         b43_write16(dev, B43_MMIO_RADIO_DATA_LOW, value);
>  }
>
> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
> index 5565318..df64032 100644
> --- a/drivers/net/wireless/b43/phy_n.c
> +++ b/drivers/net/wireless/b43/phy_n.c
> @@ -6501,7 +6501,7 @@ static void b43_nphy_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
>                                  u16 set)
>  {
>         check_phyreg(dev, reg);
> -       b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
>         b43_maskset16(dev, B43_MMIO_PHY_DATA, mask, set);
>         dev->phy.writes_counter = 1;
>  }
> @@ -6516,7 +6516,7 @@ static u16 b43_nphy_op_radio_read(struct b43_wldev *dev, u16 reg)
>         else
>                 reg |= 0x100;
>
> -       b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_RADIO_CONTROL, reg);
>         return b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
>  }
>
> @@ -6525,7 +6525,7 @@ static void b43_nphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
>         /* Register 1 is a 32-bit register. */
>         B43_WARN_ON(dev->phy.rev < 7 && reg == 1);
>
> -       b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
> +       b43_write16f(dev, B43_MMIO_RADIO_CONTROL, reg);
>         b43_write16(dev, B43_MMIO_RADIO_DATA_LOW, value);
>  }
>
> --
> 1.8.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Florian
