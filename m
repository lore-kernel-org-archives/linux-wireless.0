Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37477 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2C0Lv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 07:51:28 -0400
Received: by pbcun15 with SMTP id un15so143426pbc.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Mar 2012 04:51:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1332829680-32457-1-git-send-email-machen@suse.com>
References: <1332829680-32457-1-git-send-email-machen@suse.com>
Date: Tue, 27 Mar 2012 13:51:27 +0200
Message-ID: <CAGXE3d9LXZP+DJzU18xc1MYo9xEAD0UX9gZC6NUgCOa12RzsGg@mail.gmail.com> (sfid-20120327_135132_244128_5B9F671D)
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2x00dev: move rfkill_polling
 register to proper place
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Chen, Chien-Chia" <machen@suse.com>
Cc: IvDoorn@gmail.com, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 27, 2012 at 8:28 AM, Chen, Chien-Chia <machen@suse.com> wrote:
> Move rt2x00rfkill_register(rt2x00dev) to rt2x00lib_probe_dev().
> It fixes of starting rfkill_poll function at the right time if
> sets hard rfkill block and reboot. rt2x00mac_rfkill_poll should
> be starting before bringing up the wireless interface.

Looks reasonable to me. However, you should include John Linville in future
patch submissions (if your intention is to get them merged :D and not only
reviewed).

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

> Signed-off-by: Kevin Chou <kevin.chou@mediatek.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index fc9901e..90cc5e7 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1062,11 +1062,6 @@ static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
>
>        set_bit(DEVICE_STATE_INITIALIZED, &rt2x00dev->flags);
>
> -       /*
> -        * Register the extra components.
> -        */
> -       rt2x00rfkill_register(rt2x00dev);
> -
>        return 0;
>  }
>
> @@ -1210,6 +1205,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
>        rt2x00link_register(rt2x00dev);
>        rt2x00leds_register(rt2x00dev);
>        rt2x00debug_register(rt2x00dev);
> +       rt2x00rfkill_register(rt2x00dev);
>
>        return 0;
>
> --
> 1.7.3.4
>
