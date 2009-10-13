Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:54998 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZJMT5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 15:57:02 -0400
Received: by iwn10 with SMTP id 10so2960212iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 12:56:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255382358-20760-8-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
	<1255382358-20760-8-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 13 Oct 2009 12:56:06 -0700
Message-ID: <43e72e890910131256n36fc0e8em6735c69128c3e593@mail.gmail.com>
Subject: Re: [PATCH 6/9] [compat-2.6] Fix build with kernel < 2.6.27
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 12, 2009 at 2:19 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> iw_handler.h have changed in kernel 2.6.27.
> For older kernel we need some extra backport code.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  compat/compat-2.6.27.h |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
>
> diff --git a/compat/compat-2.6.27.h b/compat/compat-2.6.27.h
> index 2543482..8cc6c22 100644
> --- a/compat/compat-2.6.27.h
> +++ b/compat/compat-2.6.27.h
> @@ -163,6 +163,26 @@ static inline void list_splice_tail_init(struct list_head *list,
>  extern unsigned int mmc_align_data_size(struct mmc_card *, unsigned int);
>  extern unsigned int sdio_align_size(struct sdio_func *func, unsigned int sz);
>
> +/** Include iw_handler.h before we redefine some methods **/
> +#include <net/iw_handler.h>
> +
> +#define iwe_stream_add_value(info, event, value, ends, iwe, event_len) iwe_stream_add_value(event, value, ends, iwe, event_len)
> +#define iwe_stream_add_point(info, stream, ends, iwe, extra) iwe_stream_add_point(stream, ends, iwe, extra)
> +#define iwe_stream_add_event(info, stream, ends, iwe, event_len) iwe_stream_add_event(stream, ends, iwe, event_len)
> +
> +/* Flags available in struct iw_request_info */
> +#define IW_REQUEST_FLAG_COMPAT 0x0001  /* Compat ioctl call */
> +
> +static inline int iwe_stream_lcp_len(struct iw_request_info *info)
> +{
> +#ifdef CONFIG_COMPAT
> +       if (info->flags & IW_REQUEST_FLAG_COMPAT)
> +               return IW_EV_COMPAT_LCP_LEN;
> +#endif
> +       return IW_EV_LCP_LEN;
> +}
> +/** source: include/net/iw_handler.h **/
> +
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)) */
>
>  #endif /* LINUX_26_27_COMPAT_H */

I guess for older releases where we copied over the iw_handler.h we
were then sending the kernel the wrong data for these callers. We
could just try to propagate the iw_handler changes to
compat-wireless-stable. This would probably fix a few unreported
issues.

  Luis
