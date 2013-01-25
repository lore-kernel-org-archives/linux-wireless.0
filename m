Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:60807 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3AYJFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 04:05:07 -0500
Received: by mail-vb0-f44.google.com with SMTP id fc26so92948vbb.17
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 01:05:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359089270-29702-1-git-send-email-yeohchunyeow@gmail.com>
References: <1359089270-29702-1-git-send-email-yeohchunyeow@gmail.com>
Date: Fri, 25 Jan 2013 10:05:05 +0100
Message-ID: <CAL1gcdPBYcD=ZvV4iOGpQw9=GiKX0OyWLL6UUtHOu2vO2z9yFw@mail.gmail.com> (sfid-20130125_100512_840459_5BE029E1)
Subject: Re: [PATCH] rt2x00: allow AP and mesh mode to operate simultaneously
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Ivo Van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2013 at 5:47 AM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Allow AP and Mesh mode to operate concurrently using
> single radio. Verify this using fonera 2.0n featuring
> RT3052 chipset and also TP-LINK TL-WN727N featuring
> RT5370 chipset.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index b40a538..f3c83f4 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1236,7 +1236,8 @@ static inline void rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
>          */
>         if_limit = &rt2x00dev->if_limits_ap;
>         if_limit->max = rt2x00dev->ops->max_ap_intf;
> -       if_limit->types = BIT(NL80211_IFTYPE_AP);
> +       if_limit->types = BIT(NL80211_IFTYPE_AP) |
> +                       BIT(NL80211_IFTYPE_MESH_POINT);
>
>         /*
>          * Build up AP interface combinations structure.
> --
> 1.7.0.4
>



--
---
Gertjan
