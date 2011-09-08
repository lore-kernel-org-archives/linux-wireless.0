Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62646 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab1IHMld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 08:41:33 -0400
Received: by vxi9 with SMTP id 9so147124vxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 05:41:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315472282-21051-2-git-send-email-helmut.schaa@googlemail.com>
References: <1315472282-21051-1-git-send-email-helmut.schaa@googlemail.com>
	<1315472282-21051-2-git-send-email-helmut.schaa@googlemail.com>
Date: Thu, 8 Sep 2011 14:41:32 +0200
Message-ID: <CAOZOX0X7qcbOuLWeoM7Lyhg80A-g-=JhSqFiB2EWE6BiW6FOZQ@mail.gmail.com> (sfid-20110908_144136_044681_01B20FE7)
Subject: Re: [PATCH 2/2] rt2x00: Remove special case for rate probe frames
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, nbd@openwrt.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 8, 2011 at 10:58 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> This is handled in minstrel_ht now. No need to special case it here
> again.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: Ivo Van Doorn <ivdoorn@gmail.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>
> Ivo, I'm sending this directly to John due to the dependency on the
> minstrel_ht patch.
>
>  drivers/net/wireless/rt2x00/rt2x00queue.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index ba0d7e6..033d2cd 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -330,11 +330,9 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
>        }
>
>        /*
> -        * This frame is eligible for an AMPDU, however, don't aggregate
> -        * frames that are intended to probe a specific tx rate.
> +        * This frame is eligible for an AMPDU.
>         */
> -       if (tx_info->flags & IEEE80211_TX_CTL_AMPDU &&
> -           !(tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE))
> +       if (tx_info->flags & IEEE80211_TX_CTL_AMPDU)
>                __set_bit(ENTRY_TXD_HT_AMPDU, &txdesc->flags);
>
>        /*
> --
> 1.7.3.4
>
>
