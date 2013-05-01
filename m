Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:42050 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab3EAUIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 16:08:37 -0400
Received: by mail-ie0-f180.google.com with SMTP id to1so2313472ieb.25
        for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 13:08:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367421455-18463-8-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
	<1367421455-18463-8-git-send-email-juhosg@openwrt.org>
Date: Wed, 1 May 2013 22:08:37 +0200
Message-ID: <CAL1gcdNg8YD9_uecmHjHggW6-M_yF5fis+7PNRhAABihmmMQzQ@mail.gmail.com> (sfid-20130501_220840_378509_170ECBDB)
Subject: Re: [PATCH 7/7] rt2x00: rt2x00dev: use rt2x00dev->bcn->limit
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 1, 2013 at 5:17 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The beacon data queue is initialized already,
> so fetch the number of the queue entries from
> that instead of using the entry_num field of
> the data queue descriptor.
>
> The two values are the same, and the use of the
> rt2x00dev->bcn->limit value allows us to get rid
> of a superfluous pointer dereference.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 6a20172..dff5012 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1336,7 +1336,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
>          * beacon entries.
>          */
>         rt2x00dev->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
> -       if (rt2x00dev->ops->bcn->entry_num > 0)
> +       if (rt2x00dev->bcn->limit > 0)
>                 rt2x00dev->hw->wiphy->interface_modes |=
>                     BIT(NL80211_IFTYPE_ADHOC) |
>                     BIT(NL80211_IFTYPE_AP) |
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
---
Gertjan
