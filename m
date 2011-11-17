Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52713 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522Ab1KQOsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 09:48:06 -0500
MIME-Version: 1.0
In-Reply-To: <1321481775-10853-1-git-send-email-gwingerde@gmail.com>
References: <1321481775-10853-1-git-send-email-gwingerde@gmail.com>
Date: Thu, 17 Nov 2011 15:48:03 +0100
Message-ID: <CAOZOX0WWRgYW44vVcHHW1F=h1mhJ55qHMuUcOAJemqKQRhVfdA@mail.gmail.com> (sfid-20111117_154810_096811_3534CE7F)
Subject: Re: [PATCH] rt2x00: Fix efuse EEPROM reading on PPC32.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.org>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 11:16 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Fix __le32 to __le16 conversion of the first word of an 8-word block
> of EEPROM read via the efuse method.
>
> Reported-and-tested-by: Ingvar Hagelund <ingvar@redpill-linpro.com>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> CC: <stable@vger.kernel.org>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 3f183a1..1ba079d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -3771,7 +3771,7 @@ static void rt2800_efuse_read(struct rt2x00_dev *rt2x00dev, unsigned int i)
>        /* Apparently the data is read from end to start */
>        rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3, &reg);
>        /* The returned value is in CPU order, but eeprom is le */
> -       rt2x00dev->eeprom[i] = cpu_to_le32(reg);
> +       *(u32 *)&rt2x00dev->eeprom[i] = cpu_to_le32(reg);
>        rt2800_register_read_lock(rt2x00dev, EFUSE_DATA2, &reg);
>        *(u32 *)&rt2x00dev->eeprom[i + 2] = cpu_to_le32(reg);
>        rt2800_register_read_lock(rt2x00dev, EFUSE_DATA1, &reg);
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
