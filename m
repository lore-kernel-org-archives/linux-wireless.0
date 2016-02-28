Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36112 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbcB1RfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 12:35:22 -0500
Received: by mail-ob0-f174.google.com with SMTP id s6so66150882obg.3
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 09:35:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456669193-56860-1-git-send-email-nbd@openwrt.org>
References: <1456669193-56860-1-git-send-email-nbd@openwrt.org>
Date: Sun, 28 Feb 2016 09:35:21 -0800
Message-ID: <CAA93jw5Vk1-1AcawzQxNT1Re9EsMPUK220A5WsxS6MhX3VJQBQ@mail.gmail.com> (sfid-20160228_183525_818672_9F6E6DB8)
Subject: Re: [PATCH] mac80211: fix AP buffered multicast frames with queue
 control and txq
From: Dave Taht <dave.taht@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 28, 2016 at 6:19 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Buffered multicast frames must be passed to the driver directly via
> drv_tx instead of going through the txq, otherwise they cannot easily be
> scheduled to be sent after DTIM.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  net/mac80211/tx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 3a7475f..b294820 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1247,7 +1247,8 @@ static void ieee80211_drv_tx(struct ieee80211_local *local,
>         struct txq_info *txqi;
>         u8 ac;
>
> -       if (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE)
> +       if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
> +           (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
>                 goto tx_normal;
>
>         if (!ieee80211_is_data(hdr->frame_control))
> --
> 2.2.2

I would like hooks to emerge to be able to keep the level of multicast
at a dull roar, relative to other traffic, and the impact of a
multicast bursts measureable (stat exposed to userspace, something
reporting back to the main tx queues that one just happened and how
long it took). On receive, too.....


>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
