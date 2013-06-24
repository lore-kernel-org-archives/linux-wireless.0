Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:55917 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3FXNBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:01:10 -0400
Received: by mail-ie0-f182.google.com with SMTP id s9so24903209iec.27
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jun 2013 06:01:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371915734-13966-2-git-send-email-juhosg@openwrt.org>
References: <1371915734-13966-1-git-send-email-juhosg@openwrt.org>
	<1371915734-13966-2-git-send-email-juhosg@openwrt.org>
Date: Mon, 24 Jun 2013 15:01:09 +0200
Message-ID: <CAGXE3d9xj+UwZ-Woyp0s5dVxe2NOarnYg3sAquBkO7rsxXdAHg@mail.gmail.com> (sfid-20130624_150113_261967_7544917C)
Subject: Re: [PATCH 1/3] rt2x00: rt2800: increase EEPROM_SIZE to 512 bytes
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 22, 2013 at 5:42 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> Ralink 3T chipsets are using a different EEPROM
> layout than the others. The EEPROM on these devices
> contain more data than the others which does not fit
> into 272 byte which the rt2800 driver actually uses.
>
> The Ralink reference driver defines EEPROM_SIZE to
> 512/1024 bytes for PCI/USB devices respectively.
>
> Increase the EEPROM_SIZE constant to 512 bytes, in
> order to make room for EEPROM data of 3T devices.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Fine with me.
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index fe43d01..d78c495 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -100,7 +100,7 @@
>  #define CSR_REG_BASE                   0x1000
>  #define CSR_REG_SIZE                   0x0800
>  #define EEPROM_BASE                    0x0000
> -#define EEPROM_SIZE                    0x0110
> +#define EEPROM_SIZE                    0x0200
>  #define BBP_BASE                       0x0000
>  #define BBP_SIZE                       0x00ff
>  #define RF_BASE                                0x0004
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
