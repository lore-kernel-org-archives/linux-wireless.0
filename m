Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42615 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbZENRcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 13:32:21 -0400
Received: by fxm2 with SMTP id 2so1455328fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 10:32:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A0C5329.6090505@gmail.com>
References: <4A0C5329.6090505@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 14 May 2009 19:32:00 +0200
Message-ID: <69e28c910905141032k6419110es9a14c50040c70c72@mail.gmail.com>
Subject: Re: [PATCH] zd1211rw: Replace ZD_CS_MULTICAST with ZD_CS_NO_ACK
To: linville@tuxdriver.com, dsd@gentoo.org, kune@deine-taler.de
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/14 Gábor Stefanik <netrolller.3d@gmail.com>:
> According to my tests, all that ZD_CS_MULTICAST does is to
> disable retrying/waiting for an ACK. Reflect this by renaming
> the bit to ZD_CS_NO_ACK and setting it based on
> IEEE80211_TX_CTL_NO_ACK, instead of is_multicast_ether_addr.
>
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> drivers/net/wireless/zd1211rw/zd_mac.c |    6 +++---
> drivers/net/wireless/zd1211rw/zd_mac.h |    2 +-
> 2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c
> b/drivers/net/wireless/zd1211rw/zd_mac.c
> index 85c27ac..d1ec99f 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -430,9 +430,9 @@ static void cs_set_control(struct zd_mac *mac, struct
> zd_ctrlset *cs,
>    if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
>        cs->control |= ZD_CS_NEED_RANDOM_BACKOFF;
>
> -    /* Multicast */
> -    if (is_multicast_ether_addr(header->addr1))
> -        cs->control |= ZD_CS_MULTICAST;
> +    /* No ACK expected (multicast, etc.) */
> +    if (info->flags & IEEE80211_TX_CTL_NO_ACK)
> +        cs->control |= ZD_CS_NO_ACK;
>
>    /* PS-POLL */
>    if (ieee80211_is_pspoll(header->frame_control))
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h
> b/drivers/net/wireless/zd1211rw/zd_mac.h
> index 4c05d3e..7c27591 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.h
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.h
> @@ -87,7 +87,7 @@ struct zd_ctrlset {
>
> /* zd_ctrlset control field */
> #define ZD_CS_NEED_RANDOM_BACKOFF    0x01
> -#define ZD_CS_MULTICAST            0x02
> +#define ZD_CS_NO_ACK            0x02
>
> #define ZD_CS_FRAME_TYPE_MASK        0x0c
> #define ZD_CS_DATA_FRAME        0x00
> --
> 1.5.6.3
>
>

Nah, ignore this, it got wordwrapped. (I thought Thunderbird allows
disabling word-wrap... :-( )

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
