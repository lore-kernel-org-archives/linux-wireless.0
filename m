Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61538 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab2IBUhx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 16:37:53 -0400
MIME-Version: 1.0
In-Reply-To: <1346433734-3337-3-git-send-email-gwingerde@gmail.com>
References: <1346433734-3337-1-git-send-email-gwingerde@gmail.com>
	<1346433734-3337-2-git-send-email-gwingerde@gmail.com>
	<1346433734-3337-3-git-send-email-gwingerde@gmail.com>
Date: Sun, 2 Sep 2012 22:37:52 +0200
Message-ID: <CAOZOX0WqWbV_UavHdamVucdPNnGnNo9PjS0QiQEe2mtbyBuDjQ@mail.gmail.com> (sfid-20120902_223801_377755_B5E1C014)
Subject: Re: [PATCH v2 2/6] rt2x00: Fix word size of rt2500usb MAC_CSR19 register.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 31, 2012 at 7:22 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> The register is 16 bits wide, not 32.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: <stable@vger.kernel.org>

Acked-by: Ivo van Doorn@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 3aae36b..b3a1d73 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -283,7 +283,7 @@ static int rt2500usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
>         u16 reg;
>
>         rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
> -       return rt2x00_get_field32(reg, MAC_CSR19_BIT7);
> +       return rt2x00_get_field16(reg, MAC_CSR19_BIT7);
>  }
>
>  #ifdef CONFIG_RT2X00_LIB_LEDS
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
> index b493306..192531d 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.h
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.h
> @@ -189,14 +189,14 @@
>   * MAC_CSR19: GPIO control register.
>   */
>  #define MAC_CSR19                      0x0426
> -#define MAC_CSR19_BIT0                 FIELD32(0x0001)
> -#define MAC_CSR19_BIT1                 FIELD32(0x0002)
> -#define MAC_CSR19_BIT2                 FIELD32(0x0004)
> -#define MAC_CSR19_BIT3                 FIELD32(0x0008)
> -#define MAC_CSR19_BIT4                 FIELD32(0x0010)
> -#define MAC_CSR19_BIT5                 FIELD32(0x0020)
> -#define MAC_CSR19_BIT6                 FIELD32(0x0040)
> -#define MAC_CSR19_BIT7                 FIELD32(0x0080)
> +#define MAC_CSR19_BIT0                 FIELD16(0x0001)
> +#define MAC_CSR19_BIT1                 FIELD16(0x0002)
> +#define MAC_CSR19_BIT2                 FIELD16(0x0004)
> +#define MAC_CSR19_BIT3                 FIELD16(0x0008)
> +#define MAC_CSR19_BIT4                 FIELD16(0x0010)
> +#define MAC_CSR19_BIT5                 FIELD16(0x0020)
> +#define MAC_CSR19_BIT6                 FIELD16(0x0040)
> +#define MAC_CSR19_BIT7                 FIELD16(0x0080)
>
>  /*
>   * MAC_CSR20: LED control register.
> --
> 1.7.11.1
>
