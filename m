Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:45010 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab0GGVPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 17:15:36 -0400
Received: by pxi14 with SMTP id 14so42455pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jul 2010 14:15:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006270051.24299.chunkeey@googlemail.com>
References: <201006270051.24299.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 7 Jul 2010 14:15:11 -0700
Message-ID: <AANLkTinO60FTSUJ372RTAxaIIzK640MFKllOKlLdBqKd@mail.gmail.com>
Subject: Re: [PATCH] iw: fix ampdu spacing & max amsdu length reporting
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I know Johannes is on vacation, so just a reminder :)

On Sat, Jun 26, 2010 at 3:51 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> diff --git a/scan.c b/scan.c
> index 09b1047..cd58290 100644
> --- a/scan.c
> +++ b/scan.c
> @@ -497,7 +497,7 @@ static void print_ht_capa(const uint8_t type, uint8_t len, const uint8_t *data)
>        printf("\n");
>        print_ht_capability(data[0] | (data[1] << 8));
>        print_ampdu_length(data[2] & 3);
> -       print_ampdu_spacing((data[2] >> 2) & 3);
> +       print_ampdu_spacing((data[2] >> 2) & 7);
>        print_ht_mcs(data + 3);
>  }
>
> diff --git a/util.c b/util.c
> index 0c6d978..80d5402 100644
> --- a/util.c
> +++ b/util.c
> @@ -457,8 +457,8 @@ void print_ht_capability(__u16 cap)
>
>        PRINT_HT_CAP((cap & BIT(10)), "HT Delayed Block Ack");
>
> -       PRINT_HT_CAP((cap & BIT(11)), "Max AMSDU length: 3839 bytes");
> -        PRINT_HT_CAP(!(cap & BIT(11)), "Max AMSDU length: 7935 bytes");
> +       PRINT_HT_CAP(!(cap & BIT(11)), "Max AMSDU length: 3839 bytes");
> +       PRINT_HT_CAP((cap & BIT(11)), "Max AMSDU length: 7935 bytes");
>
>        /*
>         * For beacons and probe response this would mean the BSS
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
