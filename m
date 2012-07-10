Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60476 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2GJGd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 02:33:56 -0400
Received: by ghrr11 with SMTP id r11so10933997ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 23:33:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341837708-22689-1-git-send-email-sgruszka@redhat.com>
References: <1341837708-22689-1-git-send-email-sgruszka@redhat.com>
Date: Tue, 10 Jul 2012 08:33:56 +0200
Message-ID: <CAGXE3d_qEAmMaCtEDFTV9YUYWuYQvGkTayLHi8VfTGHKVHRxEA@mail.gmail.com> (sfid-20120710_083400_539316_DD3D4A06)
Subject: Re: [PATCH 1/2] rt2x00pci: small 3290 changes cleanup
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Woody Hung <Woody.Hung@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2012 at 2:41 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Fix indention and remove unnecessary brackets and compares.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks for cleaning this up Stanislaw!

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index dd43612..bf0e71e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -986,7 +986,7 @@ static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
>         int i, count;
>
>         rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
> -       if ((rt2x00_get_field32(reg, WLAN_EN) == 1))
> +       if (rt2x00_get_field32(reg, WLAN_EN))
>                 return 0;
>
>         rt2x00_set_field32(&reg, WLAN_GPIO_OUT_OE_BIT_ALL, 0xff);
> @@ -1004,9 +1004,9 @@ static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
>                  */
>                 for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
>                         rt2800_register_read(rt2x00dev, CMB_CTRL, &reg);
> -                       if ((rt2x00_get_field32(reg, PLL_LD) == 1) &&
> -                               (rt2x00_get_field32(reg, XTAL_RDY) == 1))
> -                                       break;
> +                       if (rt2x00_get_field32(reg, PLL_LD) &&
> +                           rt2x00_get_field32(reg, XTAL_RDY))
> +                               break;
>                         udelay(REGISTER_BUSY_DELAY);
>                 }
>
> @@ -1022,9 +1022,8 @@ static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
>                         rt2800_register_write(rt2x00dev, 0x58, 0x618);
>                         udelay(REGISTER_BUSY_DELAY);
>                         count++;
> -               } else {
> +               } else
>                         count = 0;
> -               }
>
>                 rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
>                 rt2x00_set_field32(&reg, PCIE_APP0_CLK_REQ, 0);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
