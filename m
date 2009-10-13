Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:34107 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761149AbZJMTkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 15:40:23 -0400
Received: by iwn10 with SMTP id 10so2950830iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 12:39:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255382358-20760-2-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
	<1255382358-20760-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 13 Oct 2009 12:39:26 -0700
Message-ID: <43e72e890910131239x60c3f8d7j784dcf2a3cd9de51@mail.gmail.com>
Subject: Re: [PATCH 1/9] [compat-2.6 and compat-stable] Export
	round_jiffies_up again.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, larry.finger@gmail.com,
	Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 12, 2009 at 2:19 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The 2.6.27 mainline kernel does not export round_jiffies_up. It looks
> like the openSuse kernel 2.6.27 does export this symbol. Rename the
> compat symbol to not conflict with the openSuse kernel.
>
> CC: larry.finger@gmail.com
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  compat/compat-2.6.28.c |    2 --
>  compat/compat-2.6.28.h |    5 +++++
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
> index 613b009..33871a2 100644
> --- a/compat/compat-2.6.28.c
> +++ b/compat/compat-2.6.28.c
> @@ -260,7 +260,6 @@ static unsigned long round_jiffies_common(unsigned long j, int cpu,
>        return j;
>  }
>
> -#if 0
>  /**
>  * round_jiffies_up - function to round jiffies up to a full second
>  * @j: the time in (absolute) jiffies that should be rounded
> @@ -275,6 +274,5 @@ unsigned long round_jiffies_up(unsigned long j)
>        return round_jiffies_common(j, raw_smp_processor_id(), true);
>  }
>  EXPORT_SYMBOL_GPL(round_jiffies_up);
> -#endif

Did you then mean to rename the above to backport_round_jiffies_up then?

>  #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */
> diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
> index 4e5a2ef..90d080c 100644
> --- a/compat/compat-2.6.28.h
> +++ b/compat/compat-2.6.28.h
> @@ -195,6 +195,11 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
>
>  #endif
>
> +/* openSuse includes round_jiffies_up in it's kernel 2.6.27.
> + * This is needed to prevent conflicts with the openSuse definition.
> + */
> +#define round_jiffies_up backport_round_jiffies_up
> +
>  unsigned long round_jiffies_up(unsigned long j);
>
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)) */

because otherwise then we have here the define so existing
wireless-testing code maps to the backport_round_jiffies_up(), and the
declaration of round_jiffies_up() also gets preprocessed as
backport_round_jiffies_up() -- the only thing missing would be the
compat exported symbol but I saw that didn't change.

  Luis
