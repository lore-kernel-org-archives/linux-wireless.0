Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37569 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaIWJEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 05:04:22 -0400
Received: by mail-wg0-f42.google.com with SMTP id a1so3842303wgh.13
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 02:04:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1411149890-12618-1-git-send-email-greearb@candelatech.com>
References: <1411149890-12618-1-git-send-email-greearb@candelatech.com>
Date: Tue, 23 Sep 2014 11:04:21 +0200
Message-ID: <CA+BoTQmMuwz54ExCCBvScfUAzSHmGhGvDi-Xb268eAfsNyUxfQ@mail.gmail.com> (sfid-20140923_110427_159341_EACE5E3D)
Subject: Re: [PATCH 1/3] ath10k: use 64-bit vdev map.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 September 2014 20:04,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> This can allow more than 32 stations to be supported
> without over-running the bitmap.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c |  4 ++--
>  drivers/net/wireless/ath/ath10k/core.h |  2 +-
>  drivers/net/wireless/ath/ath10k/mac.c  | 21 ++++++++++++---------
>  3 files changed, 15 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index cee18c8..37e3166 100644
[...]
> @@ -2772,9 +2772,12 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
>                 ret = -EBUSY;
>                 goto err;
>         }
> -       bit = ffs(ar->free_vdev_map);
> +       bit = __ffs64(ar->free_vdev_map);
>
> -       arvif->vdev_id = bit - 1;
> +       ath10k_warn(ar, "Creating vdev id: %i  map: %llu\n",
> +                   bit, ar->free_vdev_map);

Shouldn't this be a ath10k_dbg()? It probably makes sense to print the
map as hex instead of a decimal too. Prints should be lower case and
debug needs a prefix, i.e.

 "mac create vdev %i map %llx"


Michał
