Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37789 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2GZGCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 02:02:19 -0400
Received: by eeil10 with SMTP id l10so249172eei.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 23:02:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343283361-4050-1-git-send-email-zajec5@gmail.com>
References: <1343283361-4050-1-git-send-email-zajec5@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 26 Jul 2012 08:01:57 +0200
Message-ID: <CA+XFjiofydQef-7GaUvZKXrH8Wx1sb1mh5j2jTHxh5bvd6NK5w@mail.gmail.com> (sfid-20120726_080224_503129_F4801FFA)
Subject: Re: [PATCH V3] b43: be more user friendly with PHY info
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 26, 2012 at 8:16 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
> First of all, use PHY names instead of magic numbers. It should make
> configuring kernel easier in case of not enabled PHY type support.
> Secondly, always print info about PHY. This is really basic info about
> hardware and quite important for the support level.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: add new PHYTYPEs
> V3: don't printk error in b43_phy_name, just return "UNKNOWN". We still
>     can know PHY type thanks to change in caller, which prints both:
>     %d and %s. Thanks Joe!
> ---
>  drivers/net/wireless/b43/b43.h  |    2 ++
>  drivers/net/wireless/b43/main.c |   39 ++++++++++++++++++++++++++++++++++-----
>  2 files changed, 36 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
> index 7c899fc..b0c7f47 100644
> --- a/drivers/net/wireless/b43/b43.h
> +++ b/drivers/net/wireless/b43/b43.h
> @@ -415,6 +415,8 @@ enum {
>  #define B43_PHYTYPE_HT                 0x07
>  #define B43_PHYTYPE_LCN                        0x08
>  #define B43_PHYTYPE_LCNXN              0x09
> +#define B43_PHYTYPE_LCN40              0x0a
> +#define B43_PHYTYPE_AC                 0x0b
>
>  /* PHYRegisters */
>  #define B43_PHY_ILT_A_CTRL             0x0072
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index b80352b..a8f812b 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -4277,6 +4277,35 @@ out:
>         return err;
>  }
>
> +static char *b43_phy_name(struct b43_wldev *dev, u8 phy_type)
> +{
> +       switch (phy_type) {
> +       case B43_PHYTYPE_A:
> +               return "A";
> +       case B43_PHYTYPE_B:
> +               return "B";
> +       case B43_PHYTYPE_G:
> +               return "G";
> +       case B43_PHYTYPE_N:
> +               return "N";
> +       case B43_PHYTYPE_LP:
> +               return "LP";
> +       case B43_PHYTYPE_SSLPN:
> +               return "SSLPN";
> +       case B43_PHYTYPE_HT:
> +               return "HT";
> +       case B43_PHYTYPE_LCN:
> +               return "LCN";
> +       case B43_PHYTYPE_LCNXN:
> +               return "LCNXN";
> +       case B43_PHYTYPE_LCN40:
> +               return "LCN40";
> +       case B43_PHYTYPE_AC:
> +               return "AC";
> +       }
> +       return "UNKNOWN";

How about putting the PHY type ID into the string in the Unknown case?
Or will it be printed somewhere else?

> +}
> +
>  /* Get PHY and RADIO versioning numbers */
>  static int b43_phy_versioning(struct b43_wldev *dev)
>  {
> @@ -4337,13 +4366,13 @@ static int b43_phy_versioning(struct b43_wldev *dev)
>                 unsupported = 1;
>         }
>         if (unsupported) {
> -               b43err(dev->wl, "FOUND UNSUPPORTED PHY "
> -                      "(Analog %u, Type %u, Revision %u)\n",
> -                      analog_type, phy_type, phy_rev);
> +               b43err(dev->wl, "FOUND UNSUPPORTED PHY (Analog %u, Type %d (%s), Revision %u)\n",
> +                      analog_type, phy_type, b43_phy_name(dev, phy_type),
> +                      phy_rev);
>                 return -EOPNOTSUPP;
>         }
> -       b43dbg(dev->wl, "Found PHY: Analog %u, Type %u, Revision %u\n",
> -              analog_type, phy_type, phy_rev);
> +       b43info(dev->wl, "Found PHY: Analog %u, Type %d (%s), Revision %u\n",
> +               analog_type, phy_type, b43_phy_name(dev, phy_type), phy_rev);
>
>         /* Get RADIO versioning */
>         if (dev->dev->core_rev >= 24) {
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
