Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:46215 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbZJMCd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 22:33:29 -0400
Received: by ey-out-2122.google.com with SMTP id 4so2042969eyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2009 19:32:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255382358-20760-4-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
	 <1255382358-20760-4-git-send-email-hauke@hauke-m.de>
Date: Tue, 13 Oct 2009 03:32:21 +0100
Message-ID: <3ace41890910121932r6f832fe8of70d9b2bdd3d2635@mail.gmail.com>
Subject: Re: [PATCH 2/9] [compat-2.6 and compat-stable] Remove unused code
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 12, 2009 at 10:19 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28) can not be true in
> compat-2.6.28.h. The definitions are not needed in compat-wireless any
> more. Removing this does not break compiling with mainline kernel 2.6.25
> to 2.6.32

Hmm, I am not questioning your decision for removing unused code, but
if they are genuinely unused, why were they introduced in the first
place?

As a side comment, while it is unusual (compared to the usual <
version_X), it is a possible scenario for compat-X.h to have codes
that conditions on LINUX_VERSION_CODE >= version_X - and if memory
serves the bits you are removing were added only recently; and they
looks like what they are (i.e. public kernel symbols became
private-static during 2.6.27<->2.6.28 or the other way round).

I guess I am looking for a reason why they were added in the first
place, if they serve no purpose.

>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  compat/compat-2.6.28.h |   24 ------------------------
>  1 files changed, 0 insertions(+), 24 deletions(-)
>
> diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
> index 90d080c..dd223c6 100644
> --- a/compat/compat-2.6.28.h
> +++ b/compat/compat-2.6.28.h
> @@ -146,22 +146,6 @@ static inline void skb_queue_splice_tail_init(struct sk_buff_head *list,
>        }
>  } /* From include/linux/skbuff.h */
>
> -struct module;
> -struct tracepoint;
> -
> -#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
> -struct tracepoint {
> -       const char *name;               /* Tracepoint name */
> -       int state;                      /* State. */
> -       void **funcs;
> -} __attribute__((aligned(32)));                /*
> -                                        * Aligned on 32 bytes because it is
> -                                        * globally visible and gcc happily
> -                                        * align these on the structure size.
> -                                        * Keep in sync with vmlinux.lds.h.
> -                                        */
> -#endif
> -
>  #ifndef DECLARE_TRACE
>
>  #define TP_PROTO(args...)      args
> @@ -181,17 +165,9 @@ struct tracepoint {
>                return -ENOSYS;                                         \
>        }
>
> -#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
> -#define DEFINE_TRACE(name)
> -#endif
>  #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
>  #define EXPORT_TRACEPOINT_SYMBOL(name)
>
> -#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
> -static inline void tracepoint_update_probe_range(struct tracepoint *begin,
> -       struct tracepoint *end)
> -{ }
> -#endif
>
>  #endif
>
> --
> 1.6.2.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
