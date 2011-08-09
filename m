Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:50581 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1HISAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 14:00:10 -0400
Received: by yie30 with SMTP id 30so176609yie.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 11:00:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312895383-3624-1-git-send-email-guy@wizery.com>
References: <1312895383-3624-1-git-send-email-guy@wizery.com>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Tue, 9 Aug 2011 20:59:55 +0300
Message-ID: <CA+XVXfeXFZ-oLRWxROuQQji5+m2xeDnQWfc8kJ+m=hPPeq7wRw@mail.gmail.com> (sfid-20110809_200015_383917_BED31FB9)
Subject: Re: [PATCH v2] wl12xx: use 2 spare TX blocks for GEM cipher
To: Guy Eilam <guy@wizery.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 9, 2011 at 16:09, Guy Eilam <guy@wizery.com> wrote:
> Add tx_spare_blocks member to the wl1271 struct
> for more generic configuration of the amount
> of spare TX blocks that should be used.
> The default value is 1.
> In case GEM cipher is used by the STA, we need
> 2 spare TX blocks instead of just 1.
>
> Signed-off-by: Guy Eilam <guy@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/main.c   |   12 ++++++++++++
>  drivers/net/wireless/wl12xx/tx.c     |    4 +---
>  drivers/net/wireless/wl12xx/tx.h     |    1 +
>  drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
>  4 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 1c56137..1d2b3e9 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -2736,6 +2736,17 @@ static int wl1271_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
>                        0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>                };
>
> +               /*
> +                * A STA set to GEM cipher requires 2 tx spare blocks.
> +                * Return to default value when GEM cipher key is removed
> +                */
> +               if (key_type == KEY_GEM) {
> +                       if (action == KEY_ADD_OR_REPLACE)
> +                               wl->tx_spare_blocks = 2;
> +                       else if (action == KEY_REMOVE)
> +                               wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
> +               }
> +

What about recovery? Note this code won't be reached in case
wl1271_op_set_key() is called when wl->state == OFF.
We should probably always revert to 1 blocks on unjoin or remove_interface.

> --- a/drivers/net/wireless/wl12xx/tx.c
> +++ b/drivers/net/wireless/wl12xx/tx.c
> @@ -200,9 +200,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
>        u32 len;
>        u32 total_blocks;
>        int id, ret = -EBUSY, ac;
> -
> -       /* we use 1 spare block */
> -       u32 spare_blocks = 1;
> +       u32 spare_blocks = wl->tx_spare_blocks;

What about dummy packets? Perhaps we should still use 1 block for them?

Arik
