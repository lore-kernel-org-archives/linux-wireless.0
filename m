Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:62908 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0D1Xda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 19:33:30 -0400
Received: by qyk9 with SMTP id 9so22083111qyk.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Apr 2010 16:33:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1272483466.14103.4.camel@localhost.localdomain>
References: <i2y446ae9281004271235sf6f04323j2faa28108481d81b@mail.gmail.com>
	 <1272413690.32717.10.camel@localhost.localdomain>
	 <1272483466.14103.4.camel@localhost.localdomain>
Date: Wed, 28 Apr 2010 16:33:28 -0700
Message-ID: <u2p446ae9281004281633xcbb3ed4peeed0dfce7dd4c81@mail.gmail.com>
Subject: Re: [PATCH] libertas: fix 8686 firmware loading regression in
	96021f096e5178582af296a2fbb6df7dbd6b695c
From: Steve deRosier <steve@cozybit.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Alagu Sankar <alagusankar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan,

I tried your patch, it works on the XO-1.5.

Thank you.

- Steve

On Wed, Apr 28, 2010 at 12:37 PM, Dan Williams <dcbw@redhat.com> wrote:
> The 'ready' condition was incorrectly evaluated which sometimes lead to
> failures loading the second-stage firmware on 8686 devices.
>
> Signed-off-by: Dan Williams <dcbw@redhat.com>
>
> ---
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index 13dfeda..64dd345 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -324,7 +324,9 @@ static int if_sdio_wait_status(struct if_sdio_card *card, const u8 condition)
>        timeout = jiffies + HZ;
>        while (1) {
>                status = sdio_readb(card->func, IF_SDIO_STATUS, &ret);
> -               if (ret || (status & condition))
> +               if (ret)
> +                       return ret;
> +               if ((status & condition) == condition)
>                        break;
>                if (time_after(jiffies, timeout))
>                        return -ETIMEDOUT;
>
>
>
