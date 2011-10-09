Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40776 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1JIAIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 20:08:07 -0400
Received: by iakk32 with SMTP id k32so5781425iak.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2011 17:08:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317987297-18172-1-git-send-email-coelho@ti.com>
References: <1317987297-18172-1-git-send-email-coelho@ti.com>
Date: Sun, 9 Oct 2011 02:08:07 +0200
Message-ID: <CAB3XZEeiyAxzE6tiqe2D71jKuusa-hPz-2fw5bqHocaw+d1xWg@mail.gmail.com> (sfid-20111009_020815_207809_AB927020)
Subject: Re: [PATCH 1/2] wl12xx: sdio: use dev_dbg instead of wl1271_debug
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 7, 2011 at 1:34 PM, Luciano Coelho <coelho@ti.com> wrote:
> To prevent a useless dependency between the sdio module and the wl12xx
> module, we need to replace the wl1271_debug macros (and friends) for
> dev_dbg and other equivalents.
>
> At the same time, remove the SDIO data hexdump, since this produces
> way too much data and is not particularly useful.  There's not
> print_hex_dump() equivalent for dynamic debug, so it's hard to control
> when the dumps are printed out.
>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
[...]
>                if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
> -                       wl1271_error("can't keep power while host "
> +                       dev_err(dev, "can't keep power while host \n"
>                                     "is suspended");

you missed the concatenation here :)
