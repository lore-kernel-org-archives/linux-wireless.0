Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:42524 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab2LFXCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 18:02:55 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so5705704lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 15:02:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354817847-23440-11-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org> <1354817847-23440-11-git-send-email-juhosg@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Thu, 6 Dec 2012 15:02:33 -0800
Message-ID: <CAB=NE6WwuwKzLkLxsggvAGhF5TKcDjWbaw3vkst4gnLFEYjP7Q@mail.gmail.com> (sfid-20121207_000259_223886_53AF934A)
Subject: Re: [PATCH v2 10/13] qca-swiss-army-knife: allow to print initvals
 with more than 5 columns
To: Gabor Juhos <juhosg@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 10:17 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> @@ -416,19 +423,26 @@ static u32 ath9k_patch_initval(u32 idx, u32 val)
>         return val;
>  }
>
> -static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows, u32 columns, bool onedim)
> +static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
> +                                  u32 columns, bool onedim, bool wide)
>  {
> -       u32 p_columns = columns > 5 ? 5 : columns;
> +       u32 p_columns;
>         u32 col, row;
>
> -       /*
> -        * This checksum stuff is designed for columns <= 8),
> -        * and spreads the checksum over 64 bits but since currently
> -        * the initval max column size is 6 we only use the first 48
> -        * bits.
> -        */
> -       if (columns > 6)
> -               return;
> +       if (wide) {
> +               p_columns = columns;
> +       } else {
> +               p_columns = columns > 5 ? 5 : columns;
> +
> +               /*
> +               * This checksum stuff is designed for columns <= 8),
> +               * and spreads the checksum over 64 bits but since currently
> +               * the initval max column size is 6 we only use the first 48
> +               * bits.
> +               */
> +               if (columns > 6)
> +                       return;
> +       }

The comment here was for the case that we were using the old nasty
checksum thingy I invented, prior to you adding SHA1 checksum support.
The column limitation therefore seems artificial here ?

Also, as per Adrian's advice on the eeprom dump tool, perhaps we can
remove clutter from the initvals tool by allowing us to copy to the
local directory the initval files from a linux-next tag.

git show next-20121204:drivers/net/wireless/ath/ath9k/ar9002_initvals.h
> path/ar9002_initvals.h

For example. But this would mean requiring us to get diffs by using a
kernel git tree, separate from where we are. Not sure if there are
gains with this strategy. Its unclear.

  Luis
