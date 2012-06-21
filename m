Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:54846 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759865Ab2FUQtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 12:49:04 -0400
Received: by yhnn12 with SMTP id n12so801218yhn.10
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 09:49:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340292308-6993-1-git-send-email-ozancag@gmail.com>
References: <1340292308-6993-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 21 Jun 2012 09:48:43 -0700
Message-ID: <CAB=NE6Uh90nV00TKSk+Rh9AG0yffKkYBZ7DiAe0Hvds-wMXQcg@mail.gmail.com> (sfid-20120621_184909_581862_4CD6AF6E)
Subject: Re: [PATCH v2] compat: Define include guard for vga_switcheroo.h
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 21, 2012 at 8:25 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> The check is missing in upstream. Patch sent but until this gets
> merged, define it in compat tree for fixing compat-drm builds.
>
> Also add a temporary header with the same name which will be used
> to check whether the header should be included or not.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
> ---
>  include/linux/compat-3.5.h     |    6 ++++++
>  include/linux/vga_switcheroo.h |    6 ++++++
>  2 files changed, 12 insertions(+)
>  create mode 100644 include/linux/vga_switcheroo.h
>
> diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
> index 74c8176..e999aee 100644
> --- a/include/linux/compat-3.5.h
> +++ b/include/linux/compat-3.5.h
> @@ -78,6 +78,12 @@ static inline int fault_in_multipages_readable(const char __user *uaddr,
>  /* switcheroo is available on >= 2.6.34 */
>  #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
>  #include <linux/vga_switcheroo.h>
> +
> +/* FIXME: The include guard is sent upstream, drop this
> + * once the guard is merged. */
> +#ifndef LINUX_VGA_SWITCHEROO_H
> +#define LINUX_VGA_SWITCHEROO_H
> +#endif

Don't you want this under the ifdef above?

>  /*
>  * This backports:
>  *
> diff --git a/include/linux/vga_switcheroo.h b/include/linux/vga_switcheroo.h
> new file mode 100644
> index 0000000..26ac71d
> --- /dev/null
> +++ b/include/linux/vga_switcheroo.h
> @@ -0,0 +1,6 @@
> +/* Hack for fixing the missing include guard in upstream
> + * header. We will drop this when the patch is merged upstream. */
> +

How about just adding this file but with something like this:

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
/*
 * XXX: The include guard was sent upstream, drop this
 * once the guard is merged.
 */
#ifndef LINUX_VGA_SWITCHEROO_H /* in case this gets upstream */
#include_next <linux/vga_switcheroo.h>
#ifndef LINUX_VGA_SWITCHEROO_H /* do not redefine once this gets upstream */
#define LINUX_VGA_SWITCHEROO_H
#endif /* case 1 LINUX_VGA_SWITCHEROO_H
#endif /* case 2 LINUX_VGA_SWITCHEROO_H
#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */

  Luis
