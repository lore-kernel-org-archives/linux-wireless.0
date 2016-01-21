Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34529 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbcAUQqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 11:46:43 -0500
Received: by mail-wm0-f46.google.com with SMTP id u188so234221773wmu.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 08:46:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1453390448-87417-1-git-send-email-nbd@openwrt.org>
References: <1453390448-87417-1-git-send-email-nbd@openwrt.org>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Thu, 21 Jan 2016 17:46:22 +0100
Message-ID: <CAFBinCByH_HSMHNhQO93U+K21ssb5W_abzOVTp=XWqOcqAnL_w@mail.gmail.com> (sfid-20160121_174647_260977_83E34E79)
Subject: Re: [PATCH] ath9k_hw: ignore eeprom magic mismatch on flash based devices
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2016 at 4:34 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Many AR913x based devices (maybe others too) do not have a valid EEPROM
> magic in their calibration data partition.
>
> Fixes: 6fa658fd5ab2 ("ath9k: Simplify and fix eeprom endianness swapping")
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

After I misread the patch in the first place here's an explanation
what the main point is:
there are (many) devices out there which have the EEPROM data provided
on a separate flash (for example in a calibration data partition). In
this case there are some manufacturers who have programmed invalid
EEPROM magic bytes, thus breaking the check I introduced earlier.
The "ath9k_hw_use_flash" check detects exactly this: whenever the
EEPROM data comes from an external source then the EEPROM magic check
is skipped.

I wonder if we should also backport this to 4.4, because that is
affected as well.

Thanks for fixing this Felix and sorry for breaking it!

> ---
>  drivers/net/wireless/ath/ath9k/eeprom.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
> index a7afdee..73fb423 100644
> --- a/drivers/net/wireless/ath/ath9k/eeprom.c
> +++ b/drivers/net/wireless/ath/ath9k/eeprom.c
> @@ -150,18 +150,18 @@ int ath9k_hw_nvram_swap_data(struct ath_hw *ah, bool *swap_needed, int size)
>                 return -EIO;
>         }
>
> -       if (magic == AR5416_EEPROM_MAGIC) {
> -               *swap_needed = false;
> -       } else if (swab16(magic) == AR5416_EEPROM_MAGIC) {
> +       *swap_needed = false;
> +       if (swab16(magic) == AR5416_EEPROM_MAGIC) {
>                 if (ah->ah_flags & AH_NO_EEP_SWAP) {
>                         ath_info(common,
>                                  "Ignoring endianness difference in EEPROM magic bytes.\n");
> -
> -                       *swap_needed = false;
>                 } else {
>                         *swap_needed = true;
>                 }
> -       } else {
> +       } else if (magic != AR5416_EEPROM_MAGIC) {
> +               if (ath9k_hw_use_flash(ah))
> +                       return 0;
> +
>                 ath_err(common,
>                         "Invalid EEPROM Magic (0x%04x).\n", magic);
>                 return -EINVAL;
> --
> 2.2.2
>
