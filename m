Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48903 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab3EAUHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 16:07:36 -0400
Received: by mail-ie0-f180.google.com with SMTP id to1so2312384ieb.25
        for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 13:07:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367421455-18463-6-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
	<1367421455-18463-6-git-send-email-juhosg@openwrt.org>
Date: Wed, 1 May 2013 22:07:35 +0200
Message-ID: <CAL1gcdO7m8ee3HSKatySnS8=YTk-HuR5qkKb=6podzwLoXSyrg@mail.gmail.com> (sfid-20130501_220738_428298_333E58A5)
Subject: Re: [PATCH 5/7] rt2x00: rt2800lib: use rt2x00dev->bcn->winfo_size
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 1, 2013 at 5:17 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The beacon data queue is initialized already when
> the rt2800_clear_beacon_register() function is called.
>
> Fetch the size of the TXWI descriptor from that
> instead of using the winfo_size field of the data
> queue descriptor.
>
> The two values are the same, and the use of the
> rt2x00dev->bcn->winfo_size value allows us to
> get rid of a superfluous pointer dereference.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index b52d70c..bddfd6d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -840,7 +840,7 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
>                                                 unsigned int beacon_base)
>  {
>         int i;
> -       const int txwi_desc_size = rt2x00dev->ops->bcn->winfo_size;
> +       const int txwi_desc_size = rt2x00dev->bcn->winfo_size;
>
>         /*
>          * For the Beacon base registers we only need to clear
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
