Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51341 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab0D1IMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 04:12:07 -0400
Received: by wye20 with SMTP id 20so549896wye.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Apr 2010 01:12:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201004280958.59704.helmut.schaa@googlemail.com>
References: <201004280958.59704.helmut.schaa@googlemail.com>
Date: Wed, 28 Apr 2010 10:12:04 +0200
Message-ID: <s2x14add3d11004280112o1012b76eq861fc7df27d361f5@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: rt2800lib: update rfcsr & bbp init code for SoC
	devices
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/28 Helmut Schaa <helmut.schaa@googlemail.com>:
> Update the rfcsr and bbp init code for SoC devices to match with the
> latest Ralink driver.
>
> To have better control over which values are used for the register
> initialization create a new function rt2800_is_305x_soc which checks
> for SoC interface type, the correct RT chipset and the correct RF
> chipset. This is based on the assumption that all rt305x SoC devices
> use a rt2872 and rf3020/rf3021/rf3022.
>
> In case an unknown RF chipset is found on a SoC device with a rt2872
> don't treat it as rt305x and just print a message.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Looks good to me.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>
> Gertjan, this approach should be pretty safe and if there really exists
> a rt305x board with a different rf chipset we'll get a log message.
>
> At the moment rt2800_is_305x_soc is only used in rt2800lib.c but maybe
> it's worth to move it to one of the headers?

Well, at the moment I don't see a use case beyond rt2800lib.c.
So, let's leave it where it is now, and we'll move it when the need to
move it to
a header file when the need arises.

>
>  drivers/net/wireless/rt2x00/rt2800lib.c |   43 ++++++++++++++++++++++++------
>  1 files changed, 34 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 50f4451..e7a61a3 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -76,6 +76,23 @@ MODULE_LICENSE("GPL");
>        rt2800_regbusy_read((__dev), H2M_MAILBOX_CSR, \
>                            H2M_MAILBOX_CSR_OWNER, (__reg))
>
> +static inline bool rt2800_is_305x_soc(struct rt2x00_dev *rt2x00dev)
> +{
> +       /* check for rt2872 on SoC */
> +       if (!rt2x00_is_soc(rt2x00dev) ||
> +           !rt2x00_rt(rt2x00dev, RT2872))
> +               return false;
> +
> +       /* we know for sure that these rf chipsets are used on rt305x boards */
> +       if (rt2x00_rf(rt2x00dev, RF3020) ||
> +           rt2x00_rf(rt2x00dev, RF3021) ||
> +           rt2x00_rf(rt2x00dev, RF3022))
> +               return true;
> +
> +       NOTICE(rt2x00dev, "Unknown RF chipset on rt305x\n");
> +       return false;
> +}
> +
>  static void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
>                             const unsigned int word, const u8 value)
>  {
> @@ -1556,6 +1573,9 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>                     rt2800_wait_bbp_ready(rt2x00dev)))
>                return -EACCES;
>
> +       if (rt2800_is_305x_soc(rt2x00dev))
> +               rt2800_bbp_write(rt2x00dev, 31, 0x08);
> +
>        rt2800_bbp_write(rt2x00dev, 65, 0x2c);
>        rt2800_bbp_write(rt2x00dev, 66, 0x38);
>
> @@ -1576,6 +1596,9 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>                rt2800_bbp_write(rt2x00dev, 79, 0x13);
>                rt2800_bbp_write(rt2x00dev, 80, 0x05);
>                rt2800_bbp_write(rt2x00dev, 81, 0x33);
> +       } else if (rt2800_is_305x_soc(rt2x00dev)) {
> +               rt2800_bbp_write(rt2x00dev, 78, 0x0e);
> +               rt2800_bbp_write(rt2x00dev, 80, 0x08);
>        } else {
>                rt2800_bbp_write(rt2x00dev, 81, 0x37);
>        }
> @@ -1596,12 +1619,16 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>        if (rt2x00_rt_rev_gte(rt2x00dev, RT3070, REV_RT3070F) ||
>            rt2x00_rt_rev_gte(rt2x00dev, RT3071, REV_RT3071E) ||
>            rt2x00_rt_rev_gte(rt2x00dev, RT3090, REV_RT3090E) ||
> -           rt2x00_rt_rev_gte(rt2x00dev, RT3390, REV_RT3390E))
> +           rt2x00_rt_rev_gte(rt2x00dev, RT3390, REV_RT3390E) ||
> +           rt2800_is_305x_soc(rt2x00dev))
>                rt2800_bbp_write(rt2x00dev, 103, 0xc0);
>        else
>                rt2800_bbp_write(rt2x00dev, 103, 0x00);
>
> -       rt2800_bbp_write(rt2x00dev, 105, 0x05);
> +       if (rt2800_is_305x_soc(rt2x00dev))
> +               rt2800_bbp_write(rt2x00dev, 105, 0x01);
> +       else
> +               rt2800_bbp_write(rt2x00dev, 105, 0x05);
>        rt2800_bbp_write(rt2x00dev, 106, 0x35);
>
>        if (rt2x00_rt(rt2x00dev, RT3071) ||
> @@ -1618,11 +1645,6 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>                rt2800_bbp_write(rt2x00dev, 138, value);
>        }
>
> -       if (rt2x00_rt(rt2x00dev, RT2872)) {
> -               rt2800_bbp_write(rt2x00dev, 31, 0x08);
> -               rt2800_bbp_write(rt2x00dev, 78, 0x0e);
> -               rt2800_bbp_write(rt2x00dev, 80, 0x08);
> -       }
>
>        for (i = 0; i < EEPROM_BBP_SIZE; i++) {
>                rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
> @@ -1709,7 +1731,7 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>            !rt2x00_rt(rt2x00dev, RT3071) &&
>            !rt2x00_rt(rt2x00dev, RT3090) &&
>            !rt2x00_rt(rt2x00dev, RT3390) &&
> -           !(rt2x00_is_soc(rt2x00dev) && rt2x00_rt(rt2x00dev, RT2872)))
> +           !rt2800_is_305x_soc(rt2x00dev))
>                return 0;
>
>        /*
> @@ -1777,7 +1799,7 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>                rt2800_rfcsr_write(rt2x00dev, 29, 0x8f);
>                rt2800_rfcsr_write(rt2x00dev, 30, 0x20);
>                rt2800_rfcsr_write(rt2x00dev, 31, 0x0f);
> -       } else if (rt2x00_rt(rt2x00dev, RT2872)) {
> +       } else if (rt2800_is_305x_soc(rt2x00dev)) {
>                rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
>                rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
>                rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
> @@ -1808,6 +1830,9 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>                rt2800_rfcsr_write(rt2x00dev, 27, 0x23);
>                rt2800_rfcsr_write(rt2x00dev, 28, 0x13);
>                rt2800_rfcsr_write(rt2x00dev, 29, 0x83);
> +               rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 31, 0x00);
> +               return 0;
>        }
>
>        if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
> --
> 1.6.4.2
>
>
