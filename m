Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from inx.pm.waw.pl ([91.202.125.194]:34618 "EHLO inx.pm.waw.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbdIASFn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 14:05:43 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@fb.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/31] timer: Remove meaningless .data/.function assignments
References: <1504222183-61202-1-git-send-email-keescook@chromium.org>
        <1504222183-61202-14-git-send-email-keescook@chromium.org>
Date: Fri, 01 Sep 2017 19:59:02 +0200
In-Reply-To: <1504222183-61202-14-git-send-email-keescook@chromium.org> (Kees
        Cook's message of "Thu, 31 Aug 2017 16:29:25 -0700")
Message-ID: <m34lsmb8rd.fsf@pm.waw.pl> (sfid-20170901_200604_262505_3A83794F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kees Cook <keescook@chromium.org> writes:

> Several timer users needlessly reset their .function/.data fields during
> their timer callback, but nothing else changes them. Some users do not
> use their .data field at all. Each instance is removed here.

For *wan/hdlc*
Acked-by: Krzysztof Halasa <khc@pm.waw.pl>

> --- a/drivers/net/wan/hdlc_cisco.c
> +++ b/drivers/net/wan/hdlc_cisco.c
> @@ -276,8 +276,6 @@ static void cisco_timer(unsigned long arg)
>  	spin_unlock(&st->lock);
>  
>  	st->timer.expires = jiffies + st->settings.interval * HZ;
> -	st->timer.function = cisco_timer;
> -	st->timer.data = arg;
>  	add_timer(&st->timer);
>  }
>  
> diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
> index de42faca076a..7da2424c28a4 100644
> --- a/drivers/net/wan/hdlc_fr.c
> +++ b/drivers/net/wan/hdlc_fr.c
> @@ -644,8 +644,6 @@ static void fr_timer(unsigned long arg)
>  			state(hdlc)->settings.t391 * HZ;
>  	}
>  
> -	state(hdlc)->timer.function = fr_timer;
> -	state(hdlc)->timer.data = arg;
>  	add_timer(&state(hdlc)->timer);
>  }

-- 
Krzysztof Halasa
