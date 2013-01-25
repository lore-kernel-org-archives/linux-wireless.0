Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48583 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3AYIg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 03:36:26 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so75698wgb.20
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 00:36:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359089270-29702-1-git-send-email-yeohchunyeow@gmail.com>
References: <1359089270-29702-1-git-send-email-yeohchunyeow@gmail.com>
Date: Fri, 25 Jan 2013 09:36:23 +0100
Message-ID: <CAGXE3d8M6Gsv5-4j2H68+tr=cSVrz2A7Ow5xCmHuF_mEy-pb7w@mail.gmail.com> (sfid-20130125_093632_172291_6778DC32)
Subject: Re: [PATCH] rt2x00: allow AP and mesh mode to operate simultaneously
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	IvDoorn@gmail.com, gwingerde@gmail.com,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2013 at 5:47 AM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Allow AP and Mesh mode to operate concurrently using
> single radio. Verify this using fonera 2.0n featuring
> RT3052 chipset and also TP-LINK TL-WN727N featuring
> RT5370 chipset.

Just curios: Are you actually running mesh + ap mode on a rt2x00 device?

Otherwise I'm fine with this.

Thanks,
Helmut

> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Acked-by: Helmut Schaa <helmut.schaa@googlemal.com>

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
