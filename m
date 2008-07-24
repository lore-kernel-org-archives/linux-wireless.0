Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:4069 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYGXQNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 12:13:20 -0400
Received: by yx-out-2324.google.com with SMTP id 8so506273yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 09:13:19 -0700 (PDT)
Message-ID: <69e28c910807240913t4430fc73yd89da535f3698ee2@mail.gmail.com> (sfid-20080724_181323_537464_7E7C72C3)
Date: Thu, 24 Jul 2008 18:13:18 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH] WIRELESS: Make wireless immediately deselectable.
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807241201230.3685@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <alpine.LFD.1.10.0807241201230.3685@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 6:03 PM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>
> Use a "menuconfig" Kconfig directive to allow wireless support to be
> one-click deselectable.
>
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
>
> ---
>
>  this *looks* like it's a safe enhancement.
>
> diff --git a/net/Kconfig b/net/Kconfig
> index b986687..4e01cec 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -239,14 +239,17 @@ source "net/rxrpc/Kconfig"
>  config FIB_RULES
>        bool
>
> -menu "Wireless"
> +menuconfig WIRELESS
> +       bool "Wireless"
>        depends on !S390
>
> +if WIRELESS
> +
>  source "net/wireless/Kconfig"
>  source "net/mac80211/Kconfig"
>  source "net/ieee80211/Kconfig"
>
> -endmenu
> +endif # WIRELESS
>
>  source "net/rfkill/Kconfig"
>  source "net/9p/Kconfig"
>
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry:
>    Have classroom, will lecture.
>
> http://crashcourse.ca                          Waterloo, Ontario, CANADA
> ========================================================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

This should default to Enabled.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
